import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:eat_it/widgets/button/button.dart';
import 'package:eat_it/widgets/page_wrapper/page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class EmptyBasketPagePlaceholder extends StatelessWidget {
  const EmptyBasketPagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(flex: 2),
            Image.asset("assets/basketPage/empty-basket.png"),
            const Spacer(),
            Container(
              constraints: BoxConstraints(maxWidth: 65.w),
              child: Text(
                "basketpage.empty.text".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14.fontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            const Spacer(flex: 2),
            Button(
              horizontalPadding: 20,
              text: "basketpage.empty.button".tr(),
              onPressed: () {
                context.go('/scanner');
              },
              mode: ButtonThemeMode.secondary,
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
