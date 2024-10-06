import 'dart:io';

import 'package:dio/dio.dart';

class NoConnectionError extends DioError {
  NoConnectionError(DioError err)
      : super(
          requestOptions: err.requestOptions,
          response: err.response,
          stackTrace: err.stackTrace,
          error: err.error,
          type: err.type,
          message: "${err.message}, No internet connection",
        );
}

class NoConnection extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.error is SocketException) {
      handler.reject(NoConnectionError(err));
    } else {
      handler.next(err);
    }
  }
}
