import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/app_router.dart';
import 'package:eat_it/providers/user_score/user_score.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:eat_it/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class BuyConfirmation extends ConsumerStatefulWidget {
  const BuyConfirmation({super.key});

  @override
  ConsumerState<BuyConfirmation> createState() => _BuyConfirmationState();
}

class _BuyConfirmationState extends ConsumerState<BuyConfirmation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/confirmation/background.png'),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          SizedBox(
            height: 65.h,
            width: 85.w,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/confirmation/noodle.png',
                    // width: 270,
                    height: 40.h,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'confirmation.title'.tr(),
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 40.fontSize,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'confirmation.subtitle'.tr(
                        args: [ref.read(userScore.notifier).state.toString()]),
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 18.fontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Button(
                    text: 'Ok',
                    horizontalPadding: 36,
                    onPressed: () {
                      context.goNamed(RouteNames.profile.name);
                    },
                  ),
                ],
              ),
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    ));
  }
}
