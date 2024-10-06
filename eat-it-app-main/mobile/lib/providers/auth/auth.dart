import 'package:eat_it/fetcher/fetcher.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<String?> build() async {
    return null;
  }

  Future<String?> login(String login, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      var response = await appFetcher.request(
          ref: ref,
          chain: 'login',
          body: {'login': login, 'password': password});
      if (response == null || response.statusCode != 200) {
        return null;
      }

      return response.data['token'];
    });

    return state.value;
  }

  Future<void> hideError() async {
    state = const AsyncValue.data(null);
  }
}
