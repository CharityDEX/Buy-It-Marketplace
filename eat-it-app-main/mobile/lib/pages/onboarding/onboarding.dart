import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/app_router.dart';
import 'package:eat_it/async_storage/storage_keys.dart';
import 'package:eat_it/providers/local_storage_provider/local_storage_provider.dart';
import 'package:eat_it/widgets/button/button.dart';
import 'package:eat_it/widgets/indicator/indicator.dart';
import 'package:eat_it/widgets/onboarding_message/onboarding_message.dart';
import 'package:eat_it/widgets/page_wrapper/page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Onboarding extends ConsumerStatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  ConsumerState<Onboarding> createState() => OnboardingState();
}

class OnboardingState extends ConsumerState<Onboarding> {
  final messages = [
    OnboardingMessageData(
        title: 'onboarding.0.title'.tr(),
        message: 'onboarding.0.message'.tr(),
        image: "assets/onboarding/1.png"),
    OnboardingMessageData(
        title: 'onboarding.1.title'.tr(),
        message: 'onboarding.1.message'.tr(),
        image: "assets/onboarding/2.png"),
    OnboardingMessageData(
        title: 'onboarding.2.title'.tr(),
        message: 'onboarding.2.message'.tr(),
        image: "assets/onboarding/3.png"),
  ];

  var index = 0;

  void onFinish() async {
    context.goNamed(RouteNames.welcome.name);
    ref.read(localStorageProvider).setBool(StorageKeys.isOnboarded.name, true);
  }

  onNextScreen() {
    if (index < messages.length - 1) {
      setState(() {
        index = index + 1;
      });
    } else {
      onFinish();
    }
  }

  Widget animatedPageSwitcher(Widget child, Animation<double> animation) {
    final tweenSlide = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
        .chain(CurveTween(curve: Curves.ease));

    final tweenFade =
        Tween(begin: 0.4, end: 1.0).chain(CurveTween(curve: Curves.ease));

    return FadeTransition(
        opacity: animation.drive(tweenFade),
        child: SlideTransition(
          position: animation.drive(tweenSlide),
          child: child,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWrapper(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 6),
            Expanded(
              flex: 70,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: animatedPageSwitcher,
                child: OnboardingMessage(
                  data: messages[index],
                  key: ValueKey(index),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Indicator(count: messages.length, current: index),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Button(
                text: index < messages.length - 1
                    ? 'onboarding.next'.tr()
                    : 'onboarding.get-started'.tr(),
                onPressed: onNextScreen,
                mode: ButtonThemeMode.primary,
              ),
            ),
            const Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
