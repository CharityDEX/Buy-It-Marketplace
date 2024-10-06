import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eat_it/fetcher/errors/custom_server_error.dart';
import 'package:eat_it/fetcher/errors/no_connection.dart';
import 'package:eat_it/fetcher/errors/server_error.dart';
import 'package:eat_it/fetcher/interceptors/auth.dart';
import 'package:eat_it/fetcher/interceptors/locale.dart';
import 'package:eat_it/fetcher/interceptors/no_connection.dart';
import 'package:eat_it/fetcher/interceptors/version.dart';
import 'package:eat_it/providers/errors/errors.dart';
import 'package:flutter/foundation.dart';

Map<String, dynamic> _parseAndDecode(String response) {
  return jsonDecode(response) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class Fetcher {
  late Dio dio;

  Fetcher(BaseOptions options, List<Interceptor Function(Dio)> interceptors) {
    dio = Dio(options);
    dio.transformer = BackgroundTransformer()..jsonDecodeCallback = parseJson;
    dio.interceptors.addAll(
      interceptors.map((createInterceptor) => createInterceptor(dio)),
    );
  }

  Future<Response<dynamic>?> request({
    required ref,
    required String chain,
    required body,
  }) async {
    try {
      final response = await dio.post('', data: {'chain': chain, ...body});
      return response;
    } on NoConnectionError {
      ref.read(errorsProvider.notifier).setConnectionError();
      throw NoConnectionRequestError();
    } on DioError catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      if (statusCode == 401) {
        rethrow;
      }

      if (e.response?.data['title'] != null) {
        throw CustomServerError(e.response!);
      }

      if (statusCode == 400) {
        return e.response;
      }

      if ((statusCode >= 500 && statusCode < 600) || statusCode == 404) {
        ref.read(errorsProvider.notifier).setServerError();
        throw ServerError(e.response);
      }

      rethrow;
    }
  }
}

const baseUrl = String.fromEnvironment(
  'baseUrl',
  defaultValue: 'https://eatitserver.uk/api',
);

final baseOptions = BaseOptions(
  baseUrl: baseUrl,
  contentType: 'application/json',
  connectTimeout: const Duration(seconds: 30),
);

var appFetcher = Fetcher(
  baseOptions,
  [
    (_) => NoConnection(),
    versionInterceptor,
    localeInterceptor,
    (_) => AuthInterceptor()
  ],
);

var notAuthhorizedFetcher = Fetcher(
  baseOptions,
  [
    (_) => NoConnection(),
    versionInterceptor,
    localeInterceptor,
  ],
);
