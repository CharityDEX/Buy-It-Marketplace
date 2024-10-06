import 'dart:ui';

import 'package:sizer/sizer.dart';

double spFontSize(double fontSize) =>
    lerpDouble(fontSize / 375.0, fontSize, 100.w / 375.0) ?? fontSize;

final fontSizes = [10.0, 12.0, 14.0, 16, 18.0, 24.0, 32.0, 40.0, 48.0, 64.0]
    .asMap()
    .map((key, value) => MapEntry(value, spFontSize(value.toDouble())));

extension ResponsiveFontSize on double {
  double get fontSize => fontSizes[this] ?? spFontSize(this);
}

extension ResponsiveFontSizeInt on int {
  double get fontSize => fontSizes[toDouble()] ?? spFontSize(toDouble());
}
