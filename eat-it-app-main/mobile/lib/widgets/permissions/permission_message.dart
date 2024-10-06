import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionMessage extends StatelessWidget {
  final String message;

  const PermissionMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("permissions.title".tr(),
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Button(
            mode: ButtonThemeMode.text,
            text: "permissions.open-settings".tr(),
            onPressed: openAppSettings,
          )
        ],
      ),
    );
  }
}
