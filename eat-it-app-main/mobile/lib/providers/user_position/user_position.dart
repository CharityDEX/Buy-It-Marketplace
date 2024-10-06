import 'package:eat_it/fetcher/fetcher.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_position.g.dart';

class UserPositionResponce {
  int? position;

  UserPositionResponce({this.position});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['position'] = position;
    return data;
  }

  UserPositionResponce.fromJson(Map<String, dynamic> json) {
    position = json['position'];
  }
}

@riverpod
class UserPosition extends _$UserPosition {
  @override
  Future<UserPositionResponce?> build() {
    ref.keepAlive();
    return Future(() => null);
  }

  Future<UserPositionResponce?> _fetchUserPosition() async {
    try {
      var response = await appFetcher
          .request(ref: ref, chain: 'get-me-position', body: {});
      if (response == null) throw Exception();
      return UserPositionResponce.fromJson(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<UserPositionResponce?> fetchUserPosition() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        var product = await _fetchUserPosition();
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
