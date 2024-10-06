import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:eat_it/fetcher/errors/base_request_error.dart';
import 'package:eat_it/fetcher/fetcher.dart';
import 'package:eat_it/models/app_error.dart';
import 'package:eat_it/providers/basket_storage/basket_storage.dart';
import 'package:eat_it/providers/leaderboard/leaderboard.dart';
import 'package:eat_it/providers/user_data/user_data.dart';
import 'package:eat_it/providers/user_photo/user_photo.dart';
import 'package:eat_it/providers/user_position/user_position.dart';

part 'delete_user.g.dart';

class DeleteUserResponse {
  String? status;
  AppError? error;

  DeleteUserResponse({this.status, this.error});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    return data;
  }

  DeleteUserResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }
}

@riverpod
class DeleteUser extends _$DeleteUser {
  @override
  FutureOr<DeleteUserResponse?> build() async {
    return Future(() => null);
  }

  Future<DeleteUserResponse?> deleteUser() async {
    state = const AsyncValue.loading();
    try {
      var response =
          await appFetcher.request(ref: ref, chain: 'remove-me', body: {});
      if (response == null) {
        return Future.error('response error: $response');
      }
      state = AsyncValue.data(DeleteUserResponse.fromJson(response.data));
      ref.read(fetchedUserDataProvider.notifier).clear();
      ref.read(fetchedLeaderboardProvider.notifier).clear();
      ref.read(fetchedUserPhotoProvider.notifier).clear();
      ref.read(userPositionProvider.notifier).clear();
      ref.read(basketStorageProvider.notifier).clearBasket();
      return DeleteUserResponse.fromJson(response.data);
    } on BaseRequestError catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
    return state.value;
  }
}
