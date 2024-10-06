import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  final Widget child;

  const AppDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
