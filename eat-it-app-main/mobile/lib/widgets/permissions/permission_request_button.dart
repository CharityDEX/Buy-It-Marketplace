import 'package:eat_it/widgets/button/button.dart';
import 'package:eat_it/widgets/permissions/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequestButton extends StatelessWidget {
  final String buttonText;
  final ButtonThemeMode buttonTheme;
  final String permissionMessage;
  final Permission permission;
  final Function() onPressed;

  const PermissionRequestButton({
    super.key,
    required this.buttonText,
    required this.permissionMessage,
    required this.buttonTheme,
    required this.permission,
    required this.onPressed,
  });

  void press(BuildContext context) async {
    if (await permission.request() == PermissionStatus.granted) {
      onPressed();
    } else if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => PermissionDialog(
          permission: permission,
          onPressed: onPressed,
          message: permissionMessage,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Button(
      text: buttonText,
      onPressed: () => press(context),
      mode: buttonTheme,
    );
  }
}
