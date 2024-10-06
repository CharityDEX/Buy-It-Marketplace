import 'package:eat_it/app_router.dart';
import 'package:eat_it/models/basket_elem/basket_elem.dart';
import 'package:eat_it/models/product.dart';
import 'package:eat_it/providers/basket_storage/basket_storage.dart';
import 'package:eat_it/providers/scanned_product/scanned_product.dart';
import 'package:eat_it/widgets/product/product_detailed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class MoreInfo extends ConsumerWidget {
  const MoreInfo({super.key});

  void onClear(BuildContext context, WidgetRef ref) {
    ref.read(scannedProductProvider.notifier).clearProduct();
    context.goNamed(RouteNames.scanner.name);
  }

  void onAddBasket(BuildContext context, WidgetRef ref, Product product) {
    ref.read(basketStorageProvider.notifier).addProduct(BasketItem(
          id: const Uuid().v4(),
          foodName: product.productName,
          foodType: product.productCategory,
          barcode: product.barcode,
          points: product.score.round(),
        ));
    context.goNamed(RouteNames.basket.name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProduct = ref.watch(scannedProductProvider);

    return Hero(
      tag: 'scanned_product',
      placeholderBuilder: (
        BuildContext context,
        Size heroSize,
        Widget child,
      ) {
        return Container(
          width: heroSize.width,
          height: heroSize.height,
          color: Colors.white,
        );
      },
      child: SafeArea(
        child: asyncProduct.when(
            data: (product) {
              if (product == null) {
                context.goNamed(RouteNames.scanner.name);
                return Container();
              }

              return ProductDetailed(
                product: product,
                onAddBasket: () => onAddBasket(context, ref, product),
                onNextScan: () => onClear(context, ref),
              );
            },
            error: (err, stack) => Container(),
            loading: () => const SpinKitFadingCircle(
                  color: Colors.white,
                  size: 36,
                )),
      ),
    );
  }
}
