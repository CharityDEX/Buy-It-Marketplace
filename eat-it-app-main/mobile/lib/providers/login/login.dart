import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/async_storage/storage_keys.dart';
import 'package:eat_it/fetcher/errors/base_request_error.dart';
import 'package:eat_it/fetcher/fetcher.dart';
import 'package:eat_it/models/app_error.dart';
import 'package:eat_it/providers/local_storage_provider/local_storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login.g.dart';

class AuthState {
  final AppError? error;
  final bool success;

  const AuthState({this.error, required this.success});
}

@riverpod
class Login extends _$Login {
  @override
  FutureOr<AuthState?> build() async {
    return Future(() => null);
  }

  Future<AuthState?> login(String login, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        var response = await notAuthhorizedFetcher.request(
            ref: ref,
            chain: 'login',
            body: {'login': login, 'password': password});

        if (response != null && response.statusCode == 200) {
          ref.read(localStorageProvider).setString(
              StorageKeys.accessToken.name, response.data['accessToken']);
          ref.read(localStorageProvider).setString(
              StorageKeys.refreshToken.name, response.data['refreshToken']);

          return const AuthState(success: true);
        }

        return const AuthState(success: false);
      } on BaseRequestError catch (e) {
        return AuthState(error: e.error, success: false);
      } on DioError catch (e) {
        if (e.response?.statusCode == 401) {
          return AuthState(
            error: AppError(
              title: 'login.errors.bad-login.title'.tr(),
              message: 'login.errors.bad-login.message'.tr(),
            ),
            success: false,
          );
        }

        return AuthState(error: defaultError, success: false);
      } catch (e) {
        return AuthState(error: defaultError, success: false);
      }
    });

    return state.value;
  }
}
