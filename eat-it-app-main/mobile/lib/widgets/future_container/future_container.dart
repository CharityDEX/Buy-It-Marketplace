import 'package:flutter/material.dart';

extension FutureWidget<T> on Future<T> {
  Widget build({
    required Widget Function(T) data,
    required Widget Function(Object err, StackTrace stack) error,
    required Widget Function() loading,
  }) {
    return FutureBuilder(
        future: this,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return data(snapshot.data!);
          }

          if (snapshot.hasError) {
            return error(snapshot.error!, snapshot.stackTrace!);
          }

          return loading();
        });
  }
}
