import 'package:eat_it/models/app_error.dart';

class FormInputValidator<T> {
  final T Function() getValue;
  final AppError? Function(T) validation;
  final Function(AppError) onError;

  const FormInputValidator({
    required this.getValue,
    required this.onError,
    required this.validation,
  });

  AppError? validate() => validation(getValue());
}
