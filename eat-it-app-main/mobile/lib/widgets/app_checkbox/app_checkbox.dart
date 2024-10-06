import 'package:eat_it/themes/app_theme.dart';
import 'package:flutter/material.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;

  final bool isError;

  final Widget label;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          unselectedWidgetColor: isError ? dangerColor : secondaryColor),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: label,
        controlAffinity: ListTileControlAffinity.leading,
        checkColor: Colors.white,
        activeColor: isError ? dangerColor : secondaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }
}
