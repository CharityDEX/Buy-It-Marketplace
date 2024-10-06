import 'package:eat_it/fetcher/fetcher.dart';
import 'package:eat_it/providers/leaderboard/leaderboard.dart';
import 'package:eat_it/providers/user_data/user_data.dart';
import 'package:eat_it/providers/user_position/user_position.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sended_product.g.dart';

class SendProductResponce {
  bool? status;
  int? code;

  SendProductResponce({this.status, this.code});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['status'] = status;
    return data;
  }

  SendProductResponce.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
  }
}

@riverpod
class SendedBasket extends _$SendedBasket {
  @override
  Future<SendProductResponce?> build() {
    return Future(() => null);
  }

  Future<SendProductResponce?> _fetchBasket(purchases) async {
    try {
      if (purchases == '' || purchases == {} || purchases == null) {
        return Future(() => null);
      }

      var response = await appFetcher.request(
          ref: ref, chain: 'set-purchase', body: purchases);

      if (response == null || response.data['status'] == false) {
        return Future.error('dio error');
      }

      return Future(() => SendProductResponce.fromJson(response.data));
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<SendProductResponce?> sendBasket(dynamic purchases) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      var product = await _fetchBasket(purchases);
      if (product != null && product.status == true) {
        ref.refresh(userPositionProvider);
        ref.refresh(fetchedUserDataProvider);
        ref.refresh(fetchedLeaderboardProvider);
      }
      return product;
    });
    return state.value;
  }
}
