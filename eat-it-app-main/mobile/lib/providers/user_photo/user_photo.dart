import 'package:eat_it/fetcher/fetcher.dart';
import 'package:eat_it/models/user_photo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_photo.g.dart';

@riverpod
class FetchedUserPhoto extends _$FetchedUserPhoto {
  @override
  Future<UserPhoto?> build() {
    ref.keepAlive();
    return Future(() => null);
  }

  Future<UserPhoto?> _fetchUserPhoto(int size) async {
    try {
      var response = await appFetcher
          .request(ref: ref, chain: 'get-me-photo', body: {'size': size});
      if (response == null) throw Exception();
      return UserPhoto.fromJson(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<UserPhoto?> fetchUserPhoto(int size) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        var product = await _fetchUserPhoto(size);
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
