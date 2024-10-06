import 'package:eat_it/utils/score_bands.dart';
import 'package:flutter/material.dart';
import 'package:eat_it/utils/relative_font_size.dart';

const primaryColor = Color(0xFF70C654);
const dangerColor = Color(0xFFEB5757);
const secondaryColor = Color(0xFF5B67CA);

const grayColor01 = Color(0xFFF1F3FB);

final typography = TextTheme(
  headlineLarge: TextStyle(
      fontFamily: 'Satoshi',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w900,
      fontSize: 40.fontSize,
      height: 1.35,
      color: Colors.black),
  headlineMedium: TextStyle(
      fontFamily: 'Avenir',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w800,
      fontSize: 24.fontSize,
      height: 1.375,
      color: Colors.black),
  labelLarge: TextStyle(
      fontFamily: 'Avenir',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 18.fontSize,
      height: 1.389,
      color: Colors.black),
  labelMedium: TextStyle(
      fontFamily: 'Avenir',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: 12.fontSize,
      height: 1.333,
      color: const Color(0xFF999999)),
  labelSmall: TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 10.fontSize,
    height: 1.5,
    letterSpacing: 0,
    color: const Color(0xFF999999),
  ),
  bodySmall: TextStyle(
      fontFamily: 'Avenir',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: 12.fontSize,
      height: 1.333,
      letterSpacing: -0.25,
      color: const Color(0xFF000000)),
  bodyMedium: TextStyle(
      fontFamily: 'Avenir',
      fontStyle: FontStyle.normal,
      height: 1.428,
      fontWeight: FontWeight.w400,
      fontSize: 16.fontSize,
      color: const Color(0xFF4E4E4E)),
  bodyLarge: TextStyle(
      fontFamily: 'Avenir',
      fontStyle: FontStyle.normal,
      height: 1.4,
      fontWeight: FontWeight.w700,
      fontSize: 14.fontSize,
      color: Colors.white),
);

final appTheme = ThemeData(
  primaryColor: primaryColor,
  fontFamily: 'Avenir',
  textTheme: typography,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: secondaryColor,
    selectionHandleColor: secondaryColor,
    selectionColor: secondaryColor.withAlpha(150),
  ),
  // colorScheme: const ColorScheme(
  //     brightness: Brightness.light,
  //     primary: Color(0xFFF1F3FB),
  //     onPrimary: Color(0xFFF1F3FB),
  //     secondary: Color(0xFFF1F3FB),
  //     onSecondary: Color(0xFFF1F3FB),
  //     error: Color(0xFFF1F3FB),
  //     onError: Color(0xFFF1F3FB),
  //     background: Color(0xFFF1F3FB),
  //     onBackground: Color(0xFFF1F3FB),
  //     surface: Color(0xFFF1F3FB),
  //     onSurface: Color(0xFFF1F3FB)),
);

const scoreColors = {
  ScoreBand.low: redColor,
  ScoreBand.medium: yellowColor,
  ScoreBand.high: greenColor,
};

const greenColor = Color(0xFF70C654);
const yellowColor = Color(0xFFF8CF61);
const redColor = Color(0xFFEB5757);
const greyColor = Color(0xFF999999);
