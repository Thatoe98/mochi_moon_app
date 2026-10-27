import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_info.freezed.dart';
part 'sign_info.g.dart';

enum Element { fire, earth, air, water }

@freezed
abstract class NamedColor with _$NamedColor {
  const factory NamedColor({required String name, required String hex}) =
      _NamedColor;

  factory NamedColor.fromJson(Map<String, dynamic> json) =>
      _$NamedColorFromJson(json);
}

@freezed
abstract class SignInfo with _$SignInfo {
  const factory SignInfo({
    required String id,
    required int index,
    required Element element,
    required List<NamedColor> palette,
  }) = _SignInfo;

  factory SignInfo.fromJson(Map<String, dynamic> json) =>
      _$SignInfoFromJson(json);
}
