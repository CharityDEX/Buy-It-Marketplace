import 'package:flutter/material.dart';

class ProductCaption extends StatelessWidget {
  final String brand;
  final String quantity;

  const ProductCaption(
      {super.key, required this.brand, required this.quantity});

  @override
  Widget build(BuildContext context) {
    final caption = '$brand${brand != '' ? ',' : ''} $quantity';
    return Text(caption, style: Theme.of(context).textTheme.labelLarge);
  }
}
