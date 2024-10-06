import 'package:flutter/material.dart';

import '../../error_screen_wrapper/error_screen_wrapper.dart';
import '../../page_wrapper/page_wrapper.dart';

class AuthFormWrapper extends StatelessWidget {
  final Widget child;

  const AuthFormWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ErrorScreenWrapper(
        child: PageWrapper(
          padding: const EdgeInsets.all(0),
          child: CustomScrollView(
            slivers: [SliverFillRemaining(hasScrollBody: false, child: child)],
          ),
        ),
      ),
    );
  }
}
