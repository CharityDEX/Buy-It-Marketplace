import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Indicator extends StatelessWidget {
  final int count;
  final int current;

  const Indicator({Key? key, required this.count, required this.current})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSmoothIndicator(
          count: count,
          activeIndex: current,
          effect: const WormEffect(
            activeDotColor: Color.fromARGB(255, 112, 198, 84),
            dotColor: Color.fromARGB(255, 220, 220, 220),
            spacing: 4.5,
            dotHeight: 7.5,
            dotWidth: 7.5,
            type: WormType.normal,
          ),
        ),
      ],
    );
  }
}
