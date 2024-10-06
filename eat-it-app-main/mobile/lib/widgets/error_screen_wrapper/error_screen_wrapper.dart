import 'package:eat_it/providers/errors/errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorScreenWrapper extends ConsumerWidget {
  final Widget child;

  const ErrorScreenWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(errorsProvider);

    return child;
  }
}
