import 'package:eat_it/themes/app_theme.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:flutter/material.dart';

enum ButtonThemeMode { primary, secondary, accountActions, text }

class Button extends StatelessWidget {
  Color getBackgroundColor(BuildContext context, ButtonThemeMode theme) {
    final Map<ButtonThemeMode, Color> colors = {
      ButtonThemeMode.primary: Theme.of(context).primaryColor,
      ButtonThemeMode.secondary: const Color(0xFFF1F3FB),
      ButtonThemeMode.accountActions: const Color(0xFF5B67CA),
      ButtonThemeMode.text: Colors.transparent,
    };

    return colors[theme] ?? Theme.of(context).primaryColor;
  }

  TextStyle getTextStyle(ButtonThemeMode theme) {
    final Map<ButtonThemeMode, TextStyle> colors = {
      ButtonThemeMode.primary: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 14.fontSize,
          height: 1.358,
          fontFamily: 'Avenir'),
      ButtonThemeMode.secondary: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.fontSize,
          height: 1.358,
          color: const Color(0xFF999999),
          fontFamily: 'Avenir'),
      ButtonThemeMode.accountActions: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 14.fontSize,
          height: 1.358,
          fontFamily: 'Avenir',
          color: Colors.white),
      ButtonThemeMode.text: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16.fontSize,
          height: 1.06,
          fontFamily: 'Avenir',
          color: secondaryColor)
    };

    return colors[theme] ??
        TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 14.fontSize,
          height: 1.358,
        );
  }

  const Button({
    Key? key,
    required this.text,
    this.onPressed,
    this.horizontalPadding = 10,
    this.mode = ButtonThemeMode.primary,
  }) : super(key: key);

  final double horizontalPadding;
  final ButtonThemeMode mode;
  final String text;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 0, horizontal: 10.fontSize)),
        shadowColor: const MaterialStatePropertyAll(Colors.transparent),
        backgroundColor: MaterialStatePropertyAll(
          getBackgroundColor(context, mode),
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.fontSize,
          horizontal: horizontalPadding.fontSize,
        ),
        child: Text(text, style: getTextStyle(mode)),
      ),
    );
  }
}
