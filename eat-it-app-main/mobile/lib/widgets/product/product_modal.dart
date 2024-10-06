import 'package:eat_it/models/product.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:eat_it/widgets/modal_card/modal_card.dart';
import 'package:eat_it/widgets/product/atoms/bonuses_maluses.dart';
import 'package:eat_it/widgets/product/atoms/more_info_link.dart';
import 'package:eat_it/widgets/product/atoms/product_caption.dart';
import 'package:eat_it/widgets/product/atoms/product_confirmation.dart';
import 'package:eat_it/widgets/product/atoms/product_name.dart';
import 'package:eat_it/widgets/product/atoms/product_score_bar.dart';
import 'package:flutter/material.dart';

class ProductModal extends StatelessWidget {
  final Product product;
  final Function() onNextScan;
  final Function() onAddBasket;

  const ProductModal(
      {super.key,
      required this.product,
      required this.onNextScan,
      required this.onAddBasket});

  @override
  Widget build(BuildContext context) {
    return ModalCard(
      child: Column(
        children: [
          Expanded(
            child: ListView(children: [
              ProductName(productName: product.productName),
              ProductCaption(brand: product.brands, quantity: product.quantity),
              SizedBox(
                height: 170.fontSize,
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: ProductScoreBar(score: product.score)),
              ),
              BonusesMaluses(categories: product.categories.take(2).toList()),
              const MoreInfoLink(),
            ]),
          ),
          SizedBox(height: 12.fontSize),
          ProductConfirmation(onNextScan: onNextScan, onAddBasket: onAddBasket)
        ],
      ),
    );
  }
}
