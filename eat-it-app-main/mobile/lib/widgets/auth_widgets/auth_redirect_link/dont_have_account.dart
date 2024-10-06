import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/app_router.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DontHaveAccount extends StatelessWidget {
  const DontHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          context.goNamed(RouteNames.signup.name);
        },
        child: RichText(
            text: TextSpan(
                text: "login.dont-have-account".tr(),
                style: TextStyle(
                  fontFamily: 'Hind Siliguri',
                  fontWeight: FontWeight.w400,
                  fontSize: 12.fontSize,
                  height: 1.21,
                  color: const Color(0xFF2C406E),
                ),
                children: [
              TextSpan(
                  text: "login.sign-up".tr(),
                  style: const TextStyle(fontWeight: FontWeight.w700))
            ])));
  }
}
