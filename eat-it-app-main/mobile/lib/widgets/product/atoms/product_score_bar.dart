import 'package:eat_it/widgets/progress_bar/progress_bar.dart';
import 'package:flutter/material.dart';

class ProductScoreBar extends StatelessWidget {
  final double score;

  const ProductScoreBar({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        alignment: AlignmentDirectional.center,
        margin: const EdgeInsets.symmetric(vertical: 25),
        child: ProgressBar(score: score),
      ),
    );
  }
}
