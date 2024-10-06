import 'package:eat_it/fetcher/fetcher.dart';
import 'package:eat_it/models/user_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data.g.dart';

@riverpod
class FetchedUserData extends _$FetchedUserData {
  @override
  Future<UserData?> build() {
    ref.keepAlive();
    return Future(() => null);
  }

  Future<UserData?> _fetchUser() async {
    try {
      var response =
          await appFetcher.request(ref: ref, chain: 'get-me', body: {});
      if (response == null) throw Exception();
      return UserData.fromJson(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<UserData?> fetchUser() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        var product = await _fetchUser();
        if (product != null) {
          return product;
        }
      } catch (e) {
        return state.value;
      }
    });

    return null;
  }

  void clear() {
    state = const AsyncData(null);
  }
}
