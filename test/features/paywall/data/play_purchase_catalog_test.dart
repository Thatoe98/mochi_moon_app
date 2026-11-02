import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:mochi_moon/features/paywall/data/play_offer.dart';
import 'package:mochi_moon/features/paywall/data/play_purchase_catalog.dart';
import 'package:mochi_moon/features/paywall/domain/purchase_catalog.dart';
import 'package:mocktail/mocktail.dart';

class _MockStore extends Mock implements InAppPurchase;

class _FakeParam extends Fake implements PurchaseParam;

class _FakePurchase extends Fake implements PurchaseDetails;

class _Verifier implements PurchaseVerifier {
  _Verifier({this.accept = true});

  final bool accept;
  final tokens = <String>[];

  @override
  Future<bool> verify({
    required String productId,
    required String token,
  }) async {
    tokens.add(token);
    return accept;
  }
}

ProductDetails _product(PremiumPlan plan, String price) => ProductDetails(
  id: plan.productId,
  title: plan.name,
  description: '',
  price: price,
  rawPrice: 1,
  currencyCode: 'USD',
);

PurchaseDetails _purchase(
  PurchaseStatus status, {
  String token = 'tok',
  String? product,
}) {
  return PurchaseDetails(
    productID: product ?? PremiumPlan.monthly.productId,
    verificationData: PurchaseVerificationData(
      localVerificationData: token,
      serverVerificationData: token,
      source: 'google_play',
    ),
    transactionDate: null,
    status: status,
  )..pendingCompletePurchase = true;
}

PricingPhaseWrapper _phase(int micros, String text) => PricingPhaseWrapper(
  billingCycleCount: 1,
  billingPeriod: 'P1Y',
  formattedPrice: text,
  priceAmountMicros: micros,
  priceCurrencyCode: 'USD',
  recurrenceMode: RecurrenceMode.finiteRecurring,
);

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeParam());
    registerFallbackValue(_FakePurchase());
  });

  late _MockStore store;
  late StreamController<List<PurchaseDetails>> stream;

  setUp(() {
    store = _MockStore();
    stream = StreamController<List<PurchaseDetails>>.broadcast();
    when(() => store.purchaseStream).thenAnswer((_) => stream.stream);
    when(() => store.isAvailable()).thenAnswer((_) async => true);
    when(() => store.completePurchase(any())).thenAnswer((_) async {});
    when(() => store.queryProductDetails(any())).thenAnswer(
      (_) async => ProductDetailsResponse(
        productDetails: [
          _product(PremiumPlan.yearly, r'$29.99'),
          _product(PremiumPlan.monthly, r'$3.99'),
        ],
        notFoundIDs: const [],
      ),
    );
  });

  tearDown(() => stream.close());

  PlayPurchaseCatalog build(PurchaseVerifier verifier) => PlayPurchaseCatalog(
    store: store,
    verifier: verifier,
    restoreTimeout: const Duration(milliseconds: 200),
  )..start();

  test('prices come from the store', () async {
    final catalog = build(_Verifier());
    final offers = await catalog.offers();
    expect(offers.map((o) => o.price), [r'$29.99', r'$3.99']);
    expect(catalog.canPurchase, isTrue);
  });

  test('an unavailable store has no prices and cannot sell', () async {
    when(() => store.isAvailable()).thenAnswer((_) async => false);
    final catalog = build(_Verifier());
    final offers = await catalog.offers();
    expect(offers.every((o) => o.price == null), isTrue);
    expect(catalog.canPurchase, isFalse);
    expect(await catalog.buy(PremiumPlan.monthly), BuyResult.unavailable);
  });

  test('a store error leaves the paywall without prices', () async {
    when(() => store.queryProductDetails(any())).thenThrow(Exception('x'));
    final catalog = build(_Verifier());
    final offers = await catalog.offers();
    expect(offers.every((o) => o.price == null), isTrue);
    expect(catalog.canPurchase, isFalse);
  });

  test('a verified purchase is acknowledged', () async {
    final verifier = _Verifier();
    build(verifier);
    final purchase = _purchase(PurchaseStatus.purchased, token: 'abc');
    stream.add([purchase]);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(verifier.tokens, ['abc']);
    verify(() => store.completePurchase(purchase)).called(1);
  });

  test('a purchase the server refuses is not acknowledged', () async {
    final verifier = _Verifier(accept: false);
    build(verifier);
    stream.add([_purchase(PurchaseStatus.purchased)]);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(verifier.tokens, hasLength(1));
    verifyNever(() => store.completePurchase(any()));
  });

  test(
    'the report credit has a store price and is bought as a consumable',
    () async {
      when(() => store.queryProductDetails(any())).thenAnswer(
        (_) async => ProductDetailsResponse(
          productDetails: [
            ProductDetails(
              id: reportCreditProductId,
              title: 'Report',
              description: '',
              price: r'$1.99',
              rawPrice: 1.99,
              currencyCode: 'USD',
            ),
          ],
          notFoundIDs: const [],
        ),
      );
      when(
        () => store.buyConsumable(purchaseParam: any(named: 'purchaseParam')),
      ).thenAnswer((_) async => true);
      final catalog = build(_Verifier());

      expect(await catalog.reportCreditPrice(), r'$1.99');
      expect(await catalog.buyReportCredit(), BuyResult.started);
      verify(
        () => store.buyConsumable(purchaseParam: any(named: 'purchaseParam')),
      ).called(1);
    },
  );

  test('without a store price the report credit cannot be bought', () async {
    final catalog = build(_Verifier());
    expect(await catalog.reportCreditPrice(), isNull);
    expect(await catalog.buyReportCredit(), BuyResult.unavailable);
    verifyNever(
      () => store.buyConsumable(purchaseParam: any(named: 'purchaseParam')),
    );
  });

  test(
    'a report credit is completed only after the server counts it',
    () async {
      final verifier = _Verifier();
      build(verifier);
      final purchase = _purchase(
        PurchaseStatus.purchased,
        token: 'credit-token',
        product: reportCreditProductId,
      );
      stream.add([purchase]);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(verifier.tokens, ['credit-token']);
      verify(() => store.completePurchase(purchase)).called(1);
    },
  );

  test('a report credit the server refuses is not completed', () async {
    build(_Verifier(accept: false));
    stream.add([
      _purchase(PurchaseStatus.purchased, product: reportCreditProductId),
    ]);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    verifyNever(() => store.completePurchase(any()));
  });

  test('a pending purchase waits', () async {
    final verifier = _Verifier();
    build(verifier);
    stream.add([_purchase(PurchaseStatus.pending)]);
    await Future<void>.delayed(Duration.zero);

    expect(verifier.tokens, isEmpty);
    verifyNever(() => store.completePurchase(any()));
  });

  test('restore finds a verified earlier purchase', () async {
    final verifier = _Verifier();
    final catalog = build(verifier);
    when(() => store.restorePurchases()).thenAnswer((_) async {
      stream.add([_purchase(PurchaseStatus.restored)]);
    });

    expect(await catalog.restore(), isTrue);
  });

  test('restore reports nothing found when no purchase arrives', () async {
    final catalog = build(_Verifier());
    when(() => store.restorePurchases()).thenAnswer((_) async {});

    expect(await catalog.restore(), isFalse);
  });

  group('chooseOffer', () {
    GooglePlayProductDetails entry(List<List<PricingPhaseWrapper>> offers) {
      final wrapper = ProductDetailsWrapper(
        description: '',
        name: 'Yearly',
        productId: PremiumPlan.yearly.productId,
        productType: ProductType.subs,
        subscriptionOfferDetails: [
          for (var i = 0; i < offers.length; i++)
            SubscriptionOfferDetailsWrapper(
              basePlanId: 'base',
              offerTags: const [],
              offerIdToken: 'token-$i',
              pricingPhases: offers[i],
            ),
        ],
        title: 'Yearly',
      );
      return GooglePlayProductDetails.fromProductDetails(wrapper).first;
    }

    List<GooglePlayProductDetails> all(List<List<PricingPhaseWrapper>> offers) {
      final wrapper = ProductDetailsWrapper(
        description: '',
        name: 'Yearly',
        productId: PremiumPlan.yearly.productId,
        productType: ProductType.subs,
        subscriptionOfferDetails: [
          for (var i = 0; i < offers.length; i++)
            SubscriptionOfferDetailsWrapper(
              basePlanId: 'base',
              offerTags: const [],
              offerIdToken: 'token-$i',
              pricingPhases: offers[i],
            ),
        ],
        title: 'Yearly',
      );
      return GooglePlayProductDetails.fromProductDetails(wrapper);
    }

    test(
      'a trial plan takes the free-start offer and shows the real price',
      () {
        final entries = all([
          [_phase(29990000, r'$29.99')],
          [_phase(0, 'Free'), _phase(29990000, r'$29.99')],
        ]);
        final choice = chooseOffer(entries, trial: true)!;
        expect(choice.token, 'token-1');
        expect(choice.price, r'$29.99');
      },
    );

    test('a plan without a trial takes the simplest offer', () {
      final entries = all([
        [_phase(0, 'Free'), _phase(3990000, r'$3.99')],
        [_phase(3990000, r'$3.99')],
      ]);
      final choice = chooseOffer(entries, trial: false)!;
      expect(choice.token, 'token-1');
    });

    test('no entries means no offer', () {
      expect(chooseOffer(const [], trial: true), isNull);
      expect(
        entry([
          [_phase(1, 'x')],
        ]).offerToken,
        'token-0',
      );
    });
  });
}
