import 'dart:convert';

import 'package:eat_it/async_storage/storage_keys.dart';
import 'package:eat_it/models/basket_elem/basket_elem.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'basket_storage.g.dart';

final asyncLocalStorage = SharedPreferences.getInstance();

@riverpod
class BasketStorage extends _$BasketStorage {
  Future<void> saveBasketStorage(List<BasketItem> products) async {
    final localStorage = await asyncLocalStorage;
    localStorage.setString(StorageKeys.basketItems.name, json.encode(products));
  }

  Future<List<BasketItem>> readBasketStorage() async {
    final localStorage = await asyncLocalStorage;

    final jsonItems = localStorage.getString(StorageKeys.basketItems.name);
    if (jsonItems != null) {
      final products = json.decode(jsonItems);

      final basket = List<BasketItem>.from(
          products.map((item) => BasketItem.fromJson(item)),
          growable: true);

      return basket;
    }

    return List<BasketItem>.empty(growable: true);
  }

  @override
  Future<List<BasketItem>> build() async => readBasketStorage();

  Future<void> addProduct(BasketItem product) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final basket = await readBasketStorage();
      basket.add(product);
      saveBasketStorage(basket);
      return basket;
    });
  }

  Future<void> removeProduct(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final basket = await readBasketStorage();
      basket.removeWhere((element) => element.id == id);
      saveBasketStorage(basket);
      return basket;
    });
  }

  Future<void> clearBasket() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      saveBasketStorage([]);
      return List<BasketItem>.empty();
    });
  }
}

@riverpod
int basketPoints(BasketPointsRef ref) {
  final basket = ref.watch(basketStorageProvider);
  if (basket.asData != null) {
    return basket.asData!.value
        .fold(0, (sum, element) => sum + (element.points ?? 0));
  }
  return 0;
}
