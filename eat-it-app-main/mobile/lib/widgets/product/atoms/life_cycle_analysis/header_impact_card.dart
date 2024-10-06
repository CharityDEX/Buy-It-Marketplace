import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/themes/app_theme.dart';
import 'package:eat_it/utils/determine_color.dart';
import 'package:eat_it/utils/pair.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

final List<Pair<List<int>, Color>> colors = [
  Pair([0, 33], redColor),
  Pair([34, 66], yellowColor),
  Pair([67, 100], greenColor)
];

class HeaderImpactCard extends StatelessWidget {
  final double averageImpact;
  final String grade;

  const HeaderImpactCard(
      {super.key, required this.averageImpact, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: determineColor(colors, averageImpact),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: SvgPicture.asset('assets/icons/tableware.svg'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'scanner.titles.life-cycle-analysis'.tr().toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 3),
            RichText(
              text: TextSpan(
                  text: 'scanner.average-impact-message'.tr(),
                  style: Theme.of(context).textTheme.bodySmall,
                  children: [
                    TextSpan(
                        text: '${averageImpact.ceil()}/100',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: determineColor(colors, averageImpact)))
                  ]),
            ),
          ]),
        )
      ],
    );
  }
}
