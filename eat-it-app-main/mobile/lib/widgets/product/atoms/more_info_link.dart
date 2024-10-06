import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/app_router.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final linkStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontFamily: 'Avenir',
  fontStyle: FontStyle.normal,
  fontSize: 12.fontSize,
  height: 1.334,
  color: const Color(0xFF5B67CA),
);

class MoreInfoLink extends StatelessWidget {
  const MoreInfoLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      padding: const EdgeInsets.only(bottom: 8),
      child: TextButton(
          onPressed: () => context.goNamed(RouteNames.moreInfo.name),
          child: Text("scanner.more-info-link", style: linkStyle).tr()),
    );
  }
}
