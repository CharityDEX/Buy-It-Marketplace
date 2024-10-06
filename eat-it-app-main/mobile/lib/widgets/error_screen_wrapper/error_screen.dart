import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/app_router.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:eat_it/widgets/button/button.dart';
import 'package:eat_it/widgets/page_wrapper/page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sizer/sizer.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWrapper(
          padding: EdgeInsets.symmetric(
              vertical: 24.fontSize, horizontal: 32.fontSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/errorPage/error.png'),
              SizedBox(height: 55.fontSize),
              Container(
                constraints: BoxConstraints(maxWidth: 65.w),
                child: Text(
                  'error.connection-error'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14.fontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Avenir'),
                ),
              ),
              SizedBox(height: 32.fontSize),
              Button(
                  text: 'error.try-again'.tr(),
                  onPressed: () async {
                    bool result =
                        await InternetConnectionChecker().hasConnection;

                    if (context.mounted && result) {
                      context.goNamed(RouteNames.splash.name);
                    }
                  })
            ],
          )),
    );
  }
}
