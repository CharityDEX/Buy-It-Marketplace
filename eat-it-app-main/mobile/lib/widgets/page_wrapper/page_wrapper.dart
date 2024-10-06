import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const PageWrapper({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding == null
          ? EdgeInsets.symmetric(vertical: 2.h, horizontal: 16)
          : padding!,
      child: SafeArea(child: child),
    );
  }
}
