import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final double? borerRadius;
  final double? width;
  final double? height;
  final Widget? child;
  final Color? color;

  const RoundedContainer({super.key, this.borerRadius, this.width, this.height, this.child, this.color}); 

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borerRadius ?? 0)),
        color: color
      ),
      child: child
    );
  }
}