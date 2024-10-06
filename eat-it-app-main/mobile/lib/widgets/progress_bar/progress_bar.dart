import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/themes/app_theme.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:eat_it/utils/score_bands.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'fork_lib/sleek_circular_slider.dart';

class ProgressBar extends StatelessWidget {
  final double score;

  const ProgressBar({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final scoreBand = determineScoreBand(score.round());
    final colorByScore = scoreColors[scoreBand];

    return SleekCircularSlider(
      initialValue: score,
      max: max(score, 100),
      min: min(score, 0),
      innerWidget: (percentage) => Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 1.h),
          Text(
            percentage.round().toString(),
            style: TextStyle(
              fontFamily: 'Avenir',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w800,
              fontSize: 48.fontSize,
              color: Colors.black,
              height: 1.75,
            ),
          ),
          RichText(
            text: TextSpan(
              text: "scanner.progress-bar-caption".tr(),
              style: Theme.of(context).textTheme.labelLarge,
              children: const [
                TextSpan(
                    text: '100', style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ],
      )),
      appearance: CircularSliderAppearance(
        size: 70.w,
        angleRange: 180,
        startAngle: 180,
        customColors: CustomSliderColors(
          dotColor: colorByScore,
          dotBorderColor: Colors.white,
          hideShadow: true,
          trackColor: const Color(0xFFF1F3FB),
          progressBarColor: colorByScore,
        ),
        customWidths: CustomSliderWidths(
          trackWidth: 4.8.w,
          progressBarWidth: 4.8.w,
          handlerSize: 3.5.w,
        ),
      ),
    );
  }
}
