import 'package:eat_it/app_router.dart';
import 'package:eat_it/async_storage/storage_keys.dart';
import 'package:eat_it/fetcher/fetcher.dart';
import 'package:eat_it/providers/basket_storage/basket_storage.dart';
import 'package:eat_it/providers/leaderboard/leaderboard.dart';
import 'package:eat_it/providers/local_storage_provider/local_storage_provider.dart';
import 'package:eat_it/providers/user_data/user_data.dart';
import 'package:eat_it/providers/user_photo/user_photo.dart';
import 'package:eat_it/providers/user_position/user_position.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logout.g.dart';

@riverpod
class Logout extends _$Logout {
  @override
  Future<bool?> build() async {
    return Future(() => null);
  }

  void logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await appFetcher.request(ref: ref, chain: 'logout', body: {});

      ref.read(localStorageProvider).remove(StorageKeys.accessToken.name);
      ref.read(localStorageProvider).remove(StorageKeys.refreshToken.name);

      ref.read(fetchedUserDataProvider.notifier).clear();
      ref.read(fetchedLeaderboardProvider.notifier).clear();
      ref.read(fetchedUserPhotoProvider.notifier).clear();
      ref.read(userPositionProvider.notifier).clear();
      ref.read(basketStorageProvider.notifier).clearBasket();

      if (navigator.currentContext?.mounted == true) {
        navigator.currentContext?.goNamed(RouteNames.welcome.name);
      }

      return true;
    });
  }
}
