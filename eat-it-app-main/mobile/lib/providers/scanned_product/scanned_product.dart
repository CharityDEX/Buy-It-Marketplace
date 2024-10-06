import 'package:eat_it/fetcher/fetcher.dart';
import 'package:eat_it/models/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scanned_product.g.dart';

@riverpod
class ScannedProduct extends _$ScannedProduct {
  @override
  Future<Product?> build() {
    return Future(() => null);
  }

  Future<Product?> _fetchProduct(barcode) async {
    if (barcode == '') {
      return Future(() => null);
    }

    var response = await appFetcher
        .request(ref: ref, chain: 'get-product', body: {'code': barcode});

    if (response == null || response.data['product'] == null) {
      return Future.error(Error());
    }

    return Future(() => Product.fromJson(response.data['product']));
  }

  Future<void> getProduct(String barcode) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      var product = await _fetchProduct(barcode);
      return product;
    });
  }

  Future<void> clearProduct() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return Future(() => null);
    });
  }
}
