import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:eat_it/widgets/page_wrapper/page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StorePlaceholderPage extends StatelessWidget {
  const StorePlaceholderPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return PageWrapper(
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(flex: 2),
            Image.asset("assets/marketplace/market-placeholder-icon.png"),
            const Spacer(),
            Container(
              constraints: BoxConstraints(maxWidth: 65.w),
              child: Text(
                "marketPlaceholder.text".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14.fontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
