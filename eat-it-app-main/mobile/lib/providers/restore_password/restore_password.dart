import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/fetcher/errors/base_request_error.dart';
import 'package:eat_it/fetcher/fetcher.dart';
import 'package:eat_it/models/app_error.dart';
import 'package:eat_it/providers/local_storage_provider/local_storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../async_storage/storage_keys.dart';

part 'restore_password.g.dart';

enum RestorePasswordStage {
  restorePassword,
  verifyCode,
  setNewPassword,
  success
}

class RestorePasswordState {
  final RestorePasswordStage stage;
  final String? login;
  final String? code;
  final AppError? error;

  const RestorePasswordState(
      {required this.stage, this.login, this.code, this.error});
}

@riverpod
class RestorePassword extends _$RestorePassword {
  @override
  Future<RestorePasswordState?> build() async {
    ref.keepAlive();
    return Future(() => null);
  }

  Future<RestorePasswordState?> restorePassword({required String login}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        var response = await notAuthhorizedFetcher.request(
          ref: ref,
          chain: 'restore-password',
          body: {'login': login},
        );

        if (response != null && response.statusCode == 200) {
          return RestorePasswordState(
            stage: RestorePasswordStage.verifyCode,
            login: login,
          );
        }

        return const RestorePasswordState(
          stage: RestorePasswordStage.restorePassword,
        );
      } on BaseRequestError catch (e) {
        return RestorePasswordState(
          stage: RestorePasswordStage.restorePassword,
          error: e.error,
        );
      } catch (e) {
        return RestorePasswordState(
          stage: RestorePasswordStage.restorePassword,
          error: defaultError,
        );
      }
    });

    return state.value;
  }

  Future<RestorePasswordState?> confirm({required String code}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        var response = await notAuthhorizedFetcher.request(
          ref: ref,
          chain: 'restore-verify-code',
          body: {'login': state.value?.login, 'code': code},
        );

        if (response != null && response.statusCode == 200) {
          return RestorePasswordState(
            stage: RestorePasswordStage.setNewPassword,
            login: state.value?.login,
            code: code,
          );
        }

        if (response != null && response.statusCode == 400) {
          return RestorePasswordState(
            stage: RestorePasswordStage.verifyCode,
            login: state.value?.login,
            error: AppError(
              title: 'signup-confirmation.errors.mismatch.title'.tr(),
              message: 'signup-confirmation.errors.mismatch.message'.tr(),
            ),
          );
        }

        return RestorePasswordState(
          stage: RestorePasswordStage.verifyCode,
          login: state.value?.login,
        );
      } on BaseRequestError catch (e) {
        return RestorePasswordState(
          stage: RestorePasswordStage.verifyCode,
          error: e.error,
          login: state.value?.login,
        );
      } catch (e) {
        return RestorePasswordState(
          stage: RestorePasswordStage.verifyCode,
          error: AppError(
            title: 'signup-confirmation.errors.mismatch.title'.tr(),
            message: 'signup-confirmation.errors.mismatch.message'.tr(),
          ),
          login: state.value?.login,
        );
      }
    });

    return state.value;
  }

  Future<RestorePasswordState?> setNewPassword(
      {required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        var response = await notAuthhorizedFetcher.request(
          ref: ref,
          chain: 'set-new-password',
          body: {
            'login': state.value?.login,
            'code': state.value?.code,
            'password': password,
          },
        );

        if (response != null && response.statusCode == 200) {
          ref.read(localStorageProvider).setString(
              StorageKeys.accessToken.name, response.data['accessToken']);
          ref.read(localStorageProvider).setString(
              StorageKeys.refreshToken.name, response.data['refreshToken']);

          return const RestorePasswordState(
              stage: RestorePasswordStage.success);
        }

        return RestorePasswordState(
          stage: RestorePasswordStage.setNewPassword,
          login: state.value?.login,
          code: state.value?.code,
        );
      } on BaseRequestError catch (e) {
        return RestorePasswordState(
          stage: RestorePasswordStage.setNewPassword,
          error: e.error,
          login: state.value?.login,
          code: state.value?.code,
        );
      } catch (e) {
        return RestorePasswordState(
          stage: RestorePasswordStage.setNewPassword,
          error: defaultError,
          login: state.value?.login,
          code: state.value?.code,
        );
      }
    });

    return state.value;
  }
}
