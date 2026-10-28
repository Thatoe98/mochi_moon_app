import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mochi_moon/features/deck/presentation/share_card_image.dart';

/// Paints [image] off screen and returns it as a PNG of
/// [shareImageSize] x [shareImagePixelRatio] pixels.
///
/// The widget is mounted briefly in the root overlay, so it inherits the
/// app's locale and fonts. Text scaling is pinned so the output never depends
/// on the user's accessibility settings.
Future<Uint8List> renderShareImage(BuildContext context, Widget image) async {
  final overlay = Overlay.of(context, rootOverlay: true);
  final key = GlobalKey();
  final entry = OverlayEntry(
    builder: (context) => Positioned(
      left: -2 * shareImageSize.width,
      top: 0,
      width: shareImageSize.width,
      height: shareImageSize.height,
      child: ExcludeSemantics(
        child: IgnorePointer(
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: RepaintBoundary(
              key: key,
              // Material gives the text a default style.
              child: Material(type: MaterialType.transparency, child: image),
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  try {
    await WidgetsBinding.instance.endOfFrame;
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final picture = await boundary.toImage(pixelRatio: shareImagePixelRatio);
    final data = await picture.toByteData(format: ui.ImageByteFormat.png);
    picture.dispose();
    return data!.buffer.asUint8List();
  } finally {
    entry
      ..remove()
      ..dispose();
  }
}
