import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/app_router.dart';
import 'package:eat_it/themes/app_theme.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.pushNamed(RouteNames.restorePassword.name);
      },
      child: Text(
        "login.forgot-password",
        style: TextStyle(
          fontFamily: 'Hind Siliguri',
          fontWeight: FontWeight.w400,
          fontSize: 12.fontSize,
          height: 1.42,
          color: secondaryColor,
        ),
      ).tr(),
    );
  }
}
