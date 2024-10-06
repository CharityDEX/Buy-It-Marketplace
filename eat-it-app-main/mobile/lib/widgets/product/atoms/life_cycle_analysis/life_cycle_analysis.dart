import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/models/parameter.dart';
import 'package:eat_it/widgets/product/atoms/life_cycle_analysis/header_impact_card.dart';
import 'package:eat_it/widgets/product/atoms/life_cycle_analysis/property.dart';
import 'package:flutter/material.dart';

class LifeCycleAnalysis extends StatelessWidget {
  final List<Parameter> properties;
  final double scoreImpact;
  final String grade;

  const LifeCycleAnalysis(
      {super.key,
      required this.properties,
      required this.scoreImpact,
      required this.grade});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('scanner.titles.life-cycle-analysis',
                style: Theme.of(context).textTheme.labelMedium)
            .tr(),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
              color: Color(0xFFF1F3FB),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(children: [
            HeaderImpactCard(averageImpact: scoreImpact, grade: grade),
            const SizedBox(height: 20),
            Column(
              children: [
                for (var property in properties)
                  ImpactLine(name: property.name, impact: property.value)
              ],
            ),
          ]),
        )
      ],
    );
  }
}
