import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/fetcher/errors/base_request_error.dart';
import 'package:eat_it/models/app_error.dart';

class ServerError extends BaseRequestError {
  ServerError(Response<dynamic>? response) : super(response?.statusCode ?? 0) {
    error = AppError(
      title: 'error.server-error-title'.tr(),
      message: 'error.server-error'.tr(),
    );
  }
}
