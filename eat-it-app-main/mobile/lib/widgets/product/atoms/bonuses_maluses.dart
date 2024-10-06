import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/models/category.dart';
import 'package:eat_it/widgets/category_card/category_card.dart';
import 'package:flutter/material.dart';

class BonusesMaluses extends StatelessWidget {
  final List<Category> categories;

  const BonusesMaluses({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('scanner.titles.bonus-malus',
            style: Theme.of(context).textTheme.labelMedium).tr(),
        const SizedBox(height: 8),
        for (Category category in categories)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: CategoryCard(category: category),
          )
      ],
    );
  }
}
