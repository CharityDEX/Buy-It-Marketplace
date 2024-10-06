import 'package:eat_it/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AuthCodeVerify extends StatelessWidget {
  final Function(String) onCompleteCode;
  final Function(String)? onChange;
  final Function? onTap;
  final bool isError;
  final TextEditingController controller;

  const AuthCodeVerify({
    super.key,
    required this.onCompleteCode,
    required this.controller,
    this.isError = false,
    this.onTap,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 4,
      obscureText: false,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(10),
        borderWidth: 2,
        fieldHeight: 100,
        fieldWidth: 60,
        activeColor: isError ? dangerColor : secondaryColor,
        activeFillColor: Colors.white,
        selectedColor: secondaryColor,
        selectedFillColor: Colors.white,
        inactiveColor: isError ? dangerColor : secondaryColor,
        inactiveFillColor: Colors.white,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      keyboardType: TextInputType.number,
      controller: controller,
      onCompleted: (v) => onCompleteCode(v),
      onChanged: (value) {
        if (onChange != null) onChange!(value);
      },
      onTap: onTap,
      beforeTextPaste: (text) => true,
    );
  }
}
