import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/fetcher/errors/base_request_error.dart';
import 'package:eat_it/fetcher/fetcher.dart';
import 'package:eat_it/models/app_error.dart';
import 'package:eat_it/providers/leaderboard/leaderboard.dart';
import 'package:eat_it/providers/user_data/user_data.dart';
import 'package:eat_it/providers/user_photo/user_photo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_user.g.dart';

class UpdateUserResponse {
  String? status;
  AppError? error;

  UpdateUserResponse({this.status, this.error});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    return data;
  }

  UpdateUserResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }
}

class UpdateUserRequestData {
  String? photo;
  String? userName;
  String? userText;

  UpdateUserRequestData({this.photo, this.userName, this.userText});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photo'] = photo;
    data['userName'] = userName;
    data['userText'] = userText;
    return data;
  }

  UpdateUserRequestData.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    userName = json['userName'];
    userText = json['userText'];
  }
}

@riverpod
class UpdateUser extends _$UpdateUser {
  @override
  Future<UpdateUserResponse?> build() {
    return Future(() => null);
  }

  Future<UpdateUserResponse?> _updateUser(
      UpdateUserRequestData userData) async {
    try {
      if (userData == '' || userData == {} || userData == null) {
        return Future(() => null);
      }

      var response =
          await appFetcher.request(ref: ref, chain: 'update-me', body: {
        'userText': userData.userText,
        'userName': userData.userName,
        'photo': userData.photo
      });

      if (response == null || response.data['status'] == false) {
        return Future.error('dio error');
      }

      return Future(() => UpdateUserResponse.fromJson(response.data));
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<UpdateUserResponse?> updateUser(UpdateUserRequestData userData) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        var product = await _updateUser(userData);
        if (product?.status == 'Ok') {
          ref.refresh(fetchedUserDataProvider);
          if (userData.photo != null) {
            ref.refresh(fetchedUserPhotoProvider);
            ref.refresh(fetchedLeaderboardProvider);
          }
        }
        return product;
      } on BaseRequestError catch (e) {
        return UpdateUserResponse(error: e.error);
      } catch (e) {
        return UpdateUserResponse(
          error: AppError(
            title: 'edit-profile.error.title'.tr(),
            message: 'edit-profile.error.message'.tr(),
          ),
        );
      }
    });

    return state.value;
  }
}
