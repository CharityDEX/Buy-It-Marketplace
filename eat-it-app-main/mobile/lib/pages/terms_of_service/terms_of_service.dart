import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/config.dart';
import 'package:eat_it/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          title: const Text('terms-of-service-title').tr(),
        ),
        body: SfPdfViewer.network(termsOfService));
  }
}
