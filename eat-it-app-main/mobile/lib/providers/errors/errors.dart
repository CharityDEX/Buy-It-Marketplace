import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/app_router.dart';
import 'package:eat_it/widgets/app_dialog/app_dialog.dart';
import 'package:eat_it/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'errors.g.dart';

enum Status { ok, error }

@riverpod
class Errors extends _$Errors {
  @override
  Status build() {
    return Status.ok;
  }

  void drop() {
    state = Status.ok;
  }

  void setConnectionError() {
    setError(Status.error, 'error.connection-error'.tr());
  }

  void setServerError() {
    setError(Status.error, 'error.server-error'.tr());
  }

  void setError(Status status, String message) {
    if (status == Status.error &&
        state != Status.error &&
        navigator.currentContext != null) {
      showDialog(
        context: navigator.currentContext!,
        builder: (context) {
          return AppDialog(
              child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Button(
                    text: 'error.ok'.tr(),
                    onPressed: () {
                      state = Status.ok;
                      Navigator.pop(context);
                    })
              ],
            ),
          ));
        },
      ).then((value) => state = Status.ok);
    }
    state = status;
  }
}
