import 'package:eat_it/app_router.dart';
import 'package:eat_it/providers/local_storage_provider/local_storage_provider.dart';
import 'package:eat_it/widgets/error_screen_wrapper/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eat_it/themes/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:sizer/sizer.dart';

void main() async {
  await Future.delayed(const Duration(milliseconds: 100));

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final certificate = await rootBundle.loadString('assets/certificate.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(
    Uint8List.fromList(certificate.codeUnits),
  );

  final prefs = await SharedPreferences.getInstance();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  ErrorWidget.builder = (details) => const Scaffold(body: ErrorScreen());

  runApp(EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: ProviderScope(overrides: [
        localStorageProvider.overrideWithValue(prefs),
      ], child: const MainApp())));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => Sizer(
      builder: (context, orientation, deviceType) => MaterialApp.router(
            theme: appTheme,
            title: 'Eat.it',
            routerConfig: getAppRouter(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          ));
}
