import 'package:eat_it/themes/app_theme.dart';
import 'package:eat_it/utils/determine_color.dart';
import 'package:eat_it/utils/pair.dart';
import 'package:flutter/material.dart';

final List<Pair<List<int>, Color>> colors = [
  Pair([0, 33], greenColor),
  Pair([34, 66], yellowColor),
  Pair([67, 100], redColor)
];

class ImpactLine extends StatelessWidget {
  final String impact;
  final String name;

  const ImpactLine({
    super.key,
    required this.name,
    required this.impact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
                color: determineColor(colors, double.parse(impact)),
                borderRadius: const BorderRadius.all(Radius.circular(4))),
          ),
          const SizedBox(width: 8),
          Text(name),
          const Spacer(),
          Text('$impact%'),
        ],
      ),
    );
  }
}
