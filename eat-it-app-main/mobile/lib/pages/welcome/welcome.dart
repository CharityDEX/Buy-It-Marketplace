import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/app_router.dart';
import 'package:eat_it/themes/app_theme.dart';
import 'package:eat_it/widgets/button/button.dart';
import 'package:eat_it/widgets/page_wrapper/page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageWrapper(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'welcome.title',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: secondaryColor),
              ).tr(),
              const SizedBox(height: 8),
              Text(
                'welcome.subtitle',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ).tr(),
              const Spacer(flex: 2),
              Image.asset('assets/welcome/welcome.png', height: 30.h),
              const Spacer(flex: 2),
              Button(
                text: 'welcome.login'.tr(),
                mode: ButtonThemeMode.accountActions,
                onPressed: () {
                  context.goNamed(RouteNames.login.name);
                },
              ),
              const SizedBox(height: 8),
              Button(
                text: 'welcome.sign-up'.tr(),
                mode: ButtonThemeMode.text,
                onPressed: () {
                  context.goNamed(RouteNames.signup.name);
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
