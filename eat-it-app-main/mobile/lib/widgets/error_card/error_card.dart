import 'package:eat_it/themes/app_theme.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Function()? onClose;

  const ErrorCard({
    super.key,
    required this.title,
    required this.message,
    this.onClose,
    this.icon = Icons.warning_amber_rounded,
  });

  Widget buildCard(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(
          10.fontSize,
          13.fontSize,
          10.fontSize,
          22.fontSize,
        ),
        decoration: const BoxDecoration(
            color: grayColor01,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Container(
              width: 48.fontSize,
              height: 48,
              decoration: BoxDecoration(
                  color: dangerColor.withAlpha(57),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Icon(icon, color: dangerColor, size: 30.fontSize),
            ),
            SizedBox(width: 14.fontSize),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            )
          ],
        ),
      );

  Widget buildCloseIcon() => Positioned(
      right: 10.fontSize,
      top: 10.fontSize,
      child: Icon(
        Icons.close,
        size: 20.fontSize,
        color: const Color(0xFF999999),
      ));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClose,
      child: Stack(children: [
        buildCard(context),
        onClose != null ? buildCloseIcon() : Container()
      ]),
    );
  }
}
