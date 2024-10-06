import 'package:eat_it/services/lifecycle_event_handler.dart';
import 'package:eat_it/widgets/permissions/permission_message.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionContainer extends StatefulWidget {
  final Widget child;
  final String message;
  final Permission permission;

  const PermissionContainer({
    super.key,
    required this.child,
    required this.message,
    required this.permission,
  });

  @override
  State<PermissionContainer> createState() => PermissionContainerState();
}

class PermissionContainerState extends State<PermissionContainer> {
  PermissionStatus? status;

  void requestPermission() => widget.permission
      .request()
      .then((value) => setState(() => status = value));

  @override
  void initState() {
    super.initState();
    requestPermission();

    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(onResumed: requestPermission),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (status == null) {
      return Container();
    }

    if (!status!.isGranted) {
      return PermissionMessage(message: widget.message);
    }

    return widget.child;
  }
}
