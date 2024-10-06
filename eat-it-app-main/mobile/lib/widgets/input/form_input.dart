import 'package:eat_it/themes/app_theme.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final Widget? icon;
  final Widget? rightIcon;
  final String? placeholder;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final int? maxLength;
  final String? Function(String?)? validator;
  final TextEditingController controller;

  final bool isError;

  const FormInput(
      {super.key,
      this.icon,
      this.rightIcon,
      this.obscureText = false,
      this.enableSuggestions = true,
      this.autocorrect = false,
      this.maxLength,
      this.validator,
      this.isError = false,
      required this.controller,
      this.placeholder});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      maxLength: maxLength,
      obscureText: obscureText,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0.0),
          // contentPadding: const EdgeInsets.fromLTRB(0, 10.0, 20.0, 10.0),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: isError ? dangerColor : const Color(0xFFE3E8F1),
                  width: 1)),
          errorStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: dangerColor),
          errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: dangerColor, width: 1)),
          prefixIconConstraints: const BoxConstraints(
              minHeight: 48, maxHeight: 48, maxWidth: 36, minWidth: 36),
          prefixIcon: icon != null
              ? Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  alignment: Alignment.centerLeft,
                  child: icon)
              : null,
          suffixIconConstraints: const BoxConstraints(
              minHeight: 48, maxHeight: 48, maxWidth: 36, minWidth: 36),
          suffixIcon: rightIcon != null
              ? Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  alignment: Alignment.centerRight,
                  child: rightIcon)
              : null,
          suffixIconColor: const Color(0xFF868889),
          prefixIconColor: const Color(0xFF868889),
          hintText: placeholder),
      controller: controller,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
          fontSize: 14.fontSize,
          fontWeight: FontWeight.w400,
          color: Color(0xFF000000),
          fontFamily: 'Hind Siliguri'),
    );
  }
}
