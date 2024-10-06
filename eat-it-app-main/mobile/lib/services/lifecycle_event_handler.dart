import 'package:flutter/material.dart';

class LifecycleEventHandler with WidgetsBindingObserver {
  bool isResumed = true;
  final Function() onResumed;

  LifecycleEventHandler({required this.onResumed});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !isResumed) {
      isResumed = true;
      onResumed();
    } else if (state == AppLifecycleState.paused && isResumed) {
      isResumed = false;
    }
  }
}
