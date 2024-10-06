import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/config.dart';
import 'package:eat_it/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          title: const Text('privacy-policy-title').tr(),
        ),
        body: SfPdfViewer.network(privacyPolicy));
  }
}
