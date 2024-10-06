import 'package:eat_it/models/product.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:eat_it/widgets/product/atoms/bonuses_maluses.dart';
import 'package:eat_it/widgets/product/atoms/life_cycle_analysis/life_cycle_analysis.dart';
import 'package:eat_it/widgets/product/atoms/product_caption.dart';
import 'package:eat_it/widgets/product/atoms/product_confirmation.dart';
import 'package:eat_it/widgets/product/atoms/product_name.dart';
import 'package:eat_it/widgets/product/atoms/product_score_bar.dart';
import 'package:flutter/material.dart';

class ProductDetailed extends StatelessWidget {
  final Product product;
  final Function() onNextScan;
  final Function() onAddBasket;

  const ProductDetailed(
      {super.key,
      required this.product,
      required this.onNextScan,
      required this.onAddBasket});

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: EdgeInsets.symmetric(
            vertical: 24.fontSize, horizontal: 16.fontSize),
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32.fontSize),
            child: ProductName(productName: product.productName),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32.fontSize),
            child: ProductCaption(
              brand: product.brands,
              quantity: product.quantity,
            ),
          ),
          SizedBox(
            height: 200.fontSize,
            child: FittedBox(
              fit: BoxFit.contain,
              child: ProductScoreBar(score: product.score),
            ),
          ),
          LifeCycleAnalysis(
              properties: product.lifeCycleAnalysis,
              scoreImpact: product.total,
              grade: product.grade),
          Container(
              margin: EdgeInsets.only(top: 20.fontSize),
              child: BonusesMaluses(categories: product.categories)),
          SizedBox(height: 20.fontSize),
          ProductConfirmation(onNextScan: onNextScan, onAddBasket: onAddBasket)
        ]);
  }
}
