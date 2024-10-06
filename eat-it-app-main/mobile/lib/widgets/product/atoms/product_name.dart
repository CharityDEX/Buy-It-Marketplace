import 'package:flutter/material.dart';

class ProductName extends StatelessWidget {
  final String productName;

  const ProductName({super.key, required this.productName});

  @override
  Widget build(BuildContext context) {
    return Text(
      productName,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
