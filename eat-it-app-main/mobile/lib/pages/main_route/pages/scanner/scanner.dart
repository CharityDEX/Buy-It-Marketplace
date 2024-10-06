import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/app_router.dart';
import 'package:eat_it/fetcher/errors/base_request_error.dart';
import 'package:eat_it/models/basket_elem/basket_elem.dart';
import 'package:eat_it/models/product.dart';
import 'package:eat_it/providers/basket_storage/basket_storage.dart';
import 'package:eat_it/providers/scanned_product/scanned_product.dart';
import 'package:eat_it/widgets/error_card/error_card.dart';
import 'package:eat_it/widgets/error_screen_wrapper/error_screen_wrapper.dart';
import 'package:eat_it/widgets/page_wrapper/page_wrapper.dart';
import 'package:eat_it/widgets/permissions/permission_container.dart';
import 'package:eat_it/widgets/product/product_modal.dart';
import 'package:eat_it/widgets/static_scanner_placeholder/static_scanner_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class Scanner extends ConsumerStatefulWidget {
  const Scanner({super.key});

  @override
  ConsumerState<Scanner> createState() => _ScannerState();
}

class _ScannerState extends ConsumerState<Scanner> {
  String code = '';

  void onDetectBarCode(WidgetRef ref, barcode) {
    if (barcode.rawValue != null && code == '') {
      setState(() {
        code = barcode.rawValue!;
      });
      ref.read(scannedProductProvider.notifier).getProduct(barcode.rawValue);
    }
  }

  void onClear() {
    setState(() {
      code = '';
    });
    ref.read(scannedProductProvider.notifier).clearProduct();
  }

  void onAddbasket(Product product) {
    ref.read(basketStorageProvider.notifier).addProduct(BasketItem(
          id: const Uuid().v4(),
          foodName: product.productName,
          foodType: product.productCategory,
          barcode: product.barcode,
          points: product.score.round(),
        ));
    context.goNamed(RouteNames.basket.name);
  }

  Widget getScannerWidget(isLoading) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Spacer(),
        StaticScannerPlaceholder(isLoading: isLoading),
        const Spacer(flex: 2),
        Opacity(
          opacity: 0,
          child: ErrorCard(
            onClose: onClear,
            title: tr('scanner.error.title'),
            message: tr('scanner.error.message'),
          ),
        )
      ],
    );
  }

  Widget getErrorWidget(Object err) {
    Widget errorCard = ErrorCard(
      onClose: onClear,
      title: tr('scanner.error.title'),
      message: tr('scanner.error.message'),
    );

    if (err is BaseRequestError) {
      errorCard = ErrorCard(
        onClose: onClear,
        title: err.error.title.isEmpty ? tr('scanner.error.title') : err.error.title,
        message: err.error.message.isEmpty ? tr('scanner.error.message') : err.error.message,
      );
    }

    return Stack(children: [
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Spacer(),
          const StaticScannerPlaceholder(isLoading: false),
          const Spacer(flex: 2),
          errorCard,
        ],
      ),
      Positioned.fill(child: GestureDetector(onTap: onClear)),
    ]);
  }

  Widget getProductModal(Product product) {
    return Hero(
      tag: 'scanned_product',
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Spacer(),
          Expanded(
            flex: 15,
            child: ProductModal(
              product: product,
              onNextScan: onClear,
              onAddBasket: () => onAddbasket(product),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncProduct = ref.watch(scannedProductProvider);

    return ErrorScreenWrapper(
      child: PermissionContainer(
        message: "permissions.camera".tr(),
        permission: Permission.camera,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            MobileScanner(
              allowDuplicates: true,
              onDetect: (barcode, args) => onDetectBarCode(ref, barcode),
            ),
            PageWrapper(
              child: asyncProduct.when(
                  data: (product) {
                    if (product == null) {
                      return getScannerWidget(false);
                    }

                    return getProductModal(product);
                  },
                  error: (err, stack) => getErrorWidget(err),
                  loading: () => getScannerWidget(true)),
            )
          ],
        ),
      ),
    );
  }
}
