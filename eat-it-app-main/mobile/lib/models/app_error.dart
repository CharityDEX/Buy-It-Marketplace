import 'package:easy_localization/easy_localization.dart';

class AppError {
  final String title;
  final String message;

  const AppError({required this.title, required this.message});

  @override
  String toString() => "[AppError] $title: $message";
}

final defaultError = AppError(
  title: 'default-error.title'.tr(),
  message: 'default-error.message'.tr(),
);
