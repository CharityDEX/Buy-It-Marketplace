import 'package:eat_it/themes/app_theme.dart';
import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  final Widget icon;
  final Color color;
  final String title;
  final String message;
  final String? lowerMessage;
  final Color? lowerMessageColor;

  const BaseCard(
      {super.key,
      required this.icon,
      required this.color,
      required this.title,
      required this.message,
      this.lowerMessage,
      this.lowerMessageColor});

  getLowerMessageWidget(context) {
    if (lowerMessage == null) {
      return Container();
    }

    return Column(
      children: [
        const SizedBox(height: 3),
        Text(
          lowerMessage ?? '',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: lowerMessageColor),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: const BoxDecoration(
            color: grayColor01,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: icon,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title.toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  getLowerMessageWidget(context),
                ],
              ),
            )
          ],
        ));
  }
}
