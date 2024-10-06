import 'package:eat_it/services/lifecycle_event_handler.dart';
import 'package:eat_it/widgets/app_dialog/app_dialog.dart';
import 'package:eat_it/widgets/permissions/permission_message.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDialog extends StatefulWidget {
  final Permission permission;
  final String message;
  final Function() onPressed;

  const PermissionDialog({
    super.key,
    required this.permission,
    required this.onPressed,
    required this.message,
  });

  @override
  State<PermissionDialog> createState() => PermissionDialogState();
}

class PermissionDialogState extends State<PermissionDialog> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(onResumed: () async {
      if (await widget.permission.request() == PermissionStatus.granted) {
        if (context.mounted) {
          Navigator.of(context).pop();
          widget.onPressed();
        }
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: PermissionMessage(message: widget.message),
    );
  }
}
