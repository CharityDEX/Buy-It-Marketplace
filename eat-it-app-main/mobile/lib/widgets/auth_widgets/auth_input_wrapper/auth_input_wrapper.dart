import 'package:flutter/material.dart';

class AuthInputWrapper extends StatelessWidget {
  final Widget child;

  const AuthInputWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      margin: const EdgeInsets.only(top: 32),
      child: child,
    );
  }
}
