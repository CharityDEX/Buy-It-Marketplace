import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/models/category.dart';
import 'package:eat_it/widgets/base_card/base_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      icon: Container(
          padding: const EdgeInsets.all(8),
          width: 32,
          height: 32,
          child: SvgPicture.network(category.icon, width: 32, height: 32)),
      color: category.color,
      title: category.title,
      message: category.message,
      lowerMessageColor: category.colorValue,
      lowerMessage: category.type == CategoryType.bonus
          ? tr('scanner.category.bonus', args: [category.value.toString()])
          : tr('scanner.category.malus', args: [category.value.toString()]),
    );
  }
}
