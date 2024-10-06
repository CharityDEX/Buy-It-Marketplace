import 'package:eat_it/fetcher/fetcher.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'leaderboard.g.dart';

class LeaderboardResponce {
  List<LeaderItems>? leaderItems;

  LeaderboardResponce({this.leaderItems});

  LeaderboardResponce.fromJson(Map<String, dynamic> json) {
    if (json['leaderItems'] != null) {
      leaderItems = <LeaderItems>[];
      json['leaderItems'].forEach((v) {
        leaderItems!.add(LeaderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (leaderItems != null) {
      data['leaderItems'] = leaderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaderItems {
  String? name;
  int? points;
  String? photo;

  LeaderItems({this.name, this.points, this.photo});

  LeaderItems.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    points = json['points'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['points'] = points;
    data['photo'] = photo;
    return data;
  }
}

@riverpod
class FetchedLeaderboard extends _$FetchedLeaderboard {
  @override
  Future<LeaderboardResponce?> build() {
    ref.keepAlive();
    return Future(() => null);
  }

  Future<LeaderboardResponce?> _fetchLeaderboard(int count) async {
    try {
      var response = await appFetcher
          .request(ref: ref, chain: 'get-leader', body: {'count': count});
      if (response == null) throw Exception();
      return LeaderboardResponce.fromJson(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<LeaderboardResponce?> fetchLeaderboard(int count) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        var product = await _fetchLeaderboard(count);
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
