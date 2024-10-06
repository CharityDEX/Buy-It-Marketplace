import 'package:flutter/material.dart';

enum CategoryType { bonus, malus }

enum Categories {
  productionMode,
  ingridientsOrigin,
  endangeredSpecies,
  packaging
}

enum CategoryImpact { missing, low, medium, high }

class Category {
  final int value;
  final CategoryImpact status;
  final String message;
  final String title;
  final String icon;

  Category(
      {required this.value,
      required this.status,
      required this.message,
      required this.title,
      required this.icon});

  static Map<CategoryImpact, Color> colors = {
    CategoryImpact.missing: const Color(0xFF999999),
    CategoryImpact.low: const Color(0xFF70C654),
    CategoryImpact.medium: const Color(0xFFF8CF61),
    CategoryImpact.high: const Color(0xFFEB5757),
  };

  static Map<CategoryImpact, Color> colorValues = {
    CategoryImpact.missing: const Color(0xFFEB5757),
    CategoryImpact.low: const Color(0xFF70C654),
    CategoryImpact.medium: const Color(0xFFF8CF61),
    CategoryImpact.high: const Color(0xFFEB5757),
  };

  Color get color {
    return colors[status] ?? const Color(0xFF999999);
  }

  Color get colorValue {
    return colorValues[status] ?? const Color(0xFFEB5757);
  }

  CategoryType get type {
    if (value >= 0) {
      return CategoryType.bonus;
    }

    return CategoryType.malus;
  }
}
