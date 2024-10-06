import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/app_router.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermLinks extends StatelessWidget {
  final Color color;

  const TermLinks({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'signup.terms.start'.tr(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
        children: [
          TextSpan(
            text: 'signup.terms.links.terms-of-service'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.pushNamed(RouteNames.termsOfService.name),
          ),
          TextSpan(text: 'signup.terms.and'.tr()),
          TextSpan(
            text: 'signup.terms.links.privacy-policy'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.pushNamed(RouteNames.privacyPolicy.name),
          ),
        ],
      ),
    );
  }
}
