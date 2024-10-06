import 'package:eat_it/themes/app_theme.dart';
import 'package:eat_it/utils/pair.dart';
import 'package:flutter/material.dart';

Color determineColor(List<Pair<List<int>, Color>> colors, double value) {
  return colors.firstWhere((element) {
    var range = element.first;
    return range[0] <= value && range[1] >= value;
  }, orElse: () => Pair([], greyColor)).second;
}
