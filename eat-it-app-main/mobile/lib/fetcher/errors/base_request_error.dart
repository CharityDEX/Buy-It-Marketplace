import 'package:eat_it/models/app_error.dart';

abstract class BaseRequestError implements Exception {
  late AppError error;
  final int statusCode;

  BaseRequestError(this.statusCode);

  @override
  String toString() => error.toString();
}
