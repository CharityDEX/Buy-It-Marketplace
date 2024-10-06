import 'package:dio/dio.dart';
import 'package:eat_it/app_router.dart';
import 'package:eat_it/async_storage/storage_keys.dart';
import 'package:eat_it/fetcher/fetcher.dart';
import 'package:eat_it/fetcher/interceptors/locale.dart';
import 'package:eat_it/fetcher/interceptors/no_connection.dart';
import 'package:eat_it/fetcher/interceptors/version.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenError extends DioError {
  TokenError({required super.requestOptions})
      : super(message: "Token exception");
}

final futureSharedPreferences = SharedPreferences.getInstance();

class RefreshTokenInterceptor extends QueuedInterceptor {
  final Dio dio;

  RefreshTokenInterceptor({required this.dio});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final sharedPreferences = await futureSharedPreferences;
    var refreshToken =
        sharedPreferences.getString(StorageKeys.refreshToken.name);

    if (refreshToken == null) {
      handler.reject(TokenError(requestOptions: options));
      return;
    }

    options.headers['Authorization'] = "Bearer $refreshToken";
    handler.next(options);
  }
}

var fetcher = Fetcher(baseOptions, [
  (_) => NoConnection(),
  versionInterceptor,
  localeInterceptor,
  (dio) => RefreshTokenInterceptor(dio: dio)
]);

Future<String> refreshToken() async {
  var response = await fetcher.request(
    ref: WidgetRef,
    chain: 'refresh-token',
    body: {},
  );

  if (response == null ||
      response.data == null ||
      response.data['accessToken'] == null ||
      response.data['refreshToken'] == null) {
    if (navigator.currentContext != null) {
      GoRouter.of(navigator.currentContext!).goNamed(RouteNames.welcome.name);
    }

    final sharedPreferences = await futureSharedPreferences;

    sharedPreferences.remove(StorageKeys.accessToken.name);
    sharedPreferences.remove(StorageKeys.refreshToken.name);

    throw Exception("No response refresh token");
  }

  final sharedPreferences = await futureSharedPreferences;

  sharedPreferences.setString(
      StorageKeys.accessToken.name, response.data['accessToken']);
  sharedPreferences.setString(
      StorageKeys.refreshToken.name, response.data['refreshToken']);

  return response.data['accessToken'];
}

class AuthInterceptor extends QueuedInterceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final sharedPreferences = await futureSharedPreferences;

    var accessToken = sharedPreferences.getString(StorageKeys.accessToken.name);

    if (accessToken == null || JwtDecoder.tryDecode(accessToken) == null) {
      handler.reject(TokenError(requestOptions: options));

      if (navigator.currentContext != null) {
        GoRouter.of(navigator.currentContext!).goNamed(RouteNames.welcome.name);
      }

      final sharedPreferences = await futureSharedPreferences;

      sharedPreferences.remove(StorageKeys.accessToken.name);
      sharedPreferences.remove(StorageKeys.refreshToken.name);

      return;
    }

    if (JwtDecoder.isExpired(accessToken)) {
      try {
        accessToken = await refreshToken();
      } catch (e) {
        handler.reject(TokenError(requestOptions: options));
        return;
      }
    }

    options.headers['Authorization'] = "Bearer $accessToken";
    try {
      handler.next(options);

      return;
    } catch (e) {
      rethrow; // При выключенном интеренете здесь может возникать ошибка, в интернете говорят оня появляется из-за версии dio выше 4.0.4
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (navigator.currentContext != null) {
        GoRouter.of(navigator.currentContext!).goNamed(RouteNames.welcome.name);
      }

      final sharedPreferences = await futureSharedPreferences;

      sharedPreferences.remove(StorageKeys.accessToken.name);
      sharedPreferences.remove(StorageKeys.refreshToken.name);
    }
    handler.next(err);
  }
}
