import 'package:dio/dio.dart';
import 'package:eat_it/fetcher/errors/base_request_error.dart';
import 'package:eat_it/models/app_error.dart';

class CustomServerError extends BaseRequestError {
  CustomServerError(Response<dynamic> response)
      : super(response.statusCode ?? 0) {
    error = AppError(
      title: response.data['title'] ?? '',
      message: response.data['message'] ?? '',
    );
  }
}
