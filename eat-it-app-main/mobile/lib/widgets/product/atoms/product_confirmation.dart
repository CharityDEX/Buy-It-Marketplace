import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/widgets/button/button.dart';
import 'package:flutter/material.dart';

class ProductConfirmation extends StatelessWidget {
  final Function() onNextScan;
  final Function() onAddBasket;

  const ProductConfirmation(
      {super.key, required this.onNextScan, required this.onAddBasket});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Button(
            onPressed: onAddBasket,
            text: 'scanner.add-basket'.tr(),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Button(
            mode: ButtonThemeMode.secondary,
            onPressed: onNextScan,
            text: 'scanner.scan-more'.tr(),
          ),
        ),
      ],
    );
  }
}
