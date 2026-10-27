import 'package:flutter/widgets.dart';

abstract final class AppRadii {
  static const double card = 24;
  static const double button = 16;
  static const double chip = 12;

  static const cardRadius = BorderRadius.all(Radius.circular(card));
  static const buttonRadius = BorderRadius.all(Radius.circular(button));
  static const chipRadius = BorderRadius.all(Radius.circular(chip));
}
