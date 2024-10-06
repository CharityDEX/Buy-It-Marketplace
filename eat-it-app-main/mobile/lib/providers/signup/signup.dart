import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/async_storage/storage_keys.dart';
import 'package:eat_it/fetcher/errors/base_request_error.dart';
import 'package:eat_it/fetcher/fetcher.dart';
import 'package:eat_it/models/app_error.dart';
import 'package:eat_it/providers/local_storage_provider/local_storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup.g.dart';

enum SignupStage { entry, confirmation, success }

class SignupState {
  final SignupStage stage;
  final String? email;
  final String? username;
  final String? password;

  final AppError? appError;

  const SignupState({
    this.email,
    this.username,
    this.appError,
    this.password,
    required this.stage,
  });
}

@riverpod
class Signup extends _$Signup {
  @override
  Future<SignupState> build() {
    ref.keepAlive();
    return Future(() => const SignupState(stage: SignupStage.entry));
  }

  Future<SignupState?> signup({
    required String email,
    required String username,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final response = await notAuthhorizedFetcher.request(
          ref: ref,
          chain: 'signup',
          body: {
            'email': email,
            'login': username,
            'password': password,
          },
        );

        if (response != null && response.statusCode == 200) {
          return SignupState(
            stage: SignupStage.confirmation,
            username: username,
            email: email,
            password: password,
          );
        }

        return SignupState(stage: SignupStage.entry, appError: defaultError);
      } on BaseRequestError catch (e) {
        return SignupState(stage: SignupStage.entry, appError: e.error);
      } catch (e) {
        return SignupState(stage: SignupStage.entry, appError: defaultError);
      }
    });

    return state.value;
  }

  Future<SignupState?> confirm({required String code}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final response = await notAuthhorizedFetcher
            .request(ref: ref, chain: 'verify-code', body: {
          'email': state.value?.email,
          'login': state.value?.username,
          'password': state.value?.password,
          'code': code,
        });

        if (response != null && response.statusCode == 200) {
          ref.read(localStorageProvider).setString(
              StorageKeys.accessToken.name, response.data['accessToken']);
          ref.read(localStorageProvider).setString(
              StorageKeys.refreshToken.name, response.data['refreshToken']);

          return const SignupState(stage: SignupStage.success);
        }

        if (response != null && response.statusCode == 400) {
          return SignupState(
            appError: AppError(
              title: 'signup-confirmation.errors.mismatch.title'.tr(),
              message: 'signup-confirmation.errors.mismatch.message'.tr(),
            ),
            stage: SignupStage.confirmation,
            email: state.value?.email,
            username: state.value?.username,
            password: state.value?.password,
          );
        }

        return SignupState(
          stage: SignupStage.confirmation,
          email: state.value?.email,
          username: state.value?.username,
          password: state.value?.password,
        );
      } on BaseRequestError catch (e) {
        return SignupState(
          appError: e.error,
          stage: SignupStage.confirmation,
          email: state.value?.email,
          username: state.value?.username,
          password: state.value?.password,
        );
      } catch (e) {
        return SignupState(
          appError: AppError(
            title: 'signup-confirmation.errors.mismatch.title'.tr(),
            message: 'signup-confirmation.errors.mismatch.message'.tr(),
          ),
          stage: SignupStage.confirmation,
          email: state.value?.email,
          username: state.value?.username,
          password: state.value?.password,
        );
      }
    });

    return state.value;
  }

  void clear() async {
    state = const AsyncData(SignupState(stage: SignupStage.entry));
  }
}
