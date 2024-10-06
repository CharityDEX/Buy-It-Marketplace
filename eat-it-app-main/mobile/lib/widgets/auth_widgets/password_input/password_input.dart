import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/regExp/reg_exp.dart';
import 'package:eat_it/widgets/input/form_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;

  final bool repeatPassword;
  final bool isError;

  const PasswordInput(
      {super.key,
      required this.controller,
      this.repeatPassword = false,
      this.isError = false});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool visible = false;

  void onToggleVisibility() {
    setState(() {
      visible = !visible;
    });
  }

  String? validatePassword(String? value) {
    if (!passwordRegex.hasMatch(value ?? '')) {
      return 'login.validations.password'.tr();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormInput(
        controller: widget.controller,
        icon: SvgPicture.asset('assets/icons/lock.svg'),
        obscureText: !visible,
        enableSuggestions: false,
        autocorrect: false,
        isError: widget.isError,
        validator: validatePassword,
        rightIcon: IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(visible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined),
        ),
        placeholder: widget.repeatPassword
            ? "password.repeat-password".tr()
            : "password.placeholder".tr());
  }
}
