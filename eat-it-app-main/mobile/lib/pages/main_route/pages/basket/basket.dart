import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/models/confirm_purchaese_item.dart';
import 'package:eat_it/providers/basket_storage/basket_storage.dart';
import 'package:eat_it/providers/sended_product/sended_product.dart';
import 'package:eat_it/providers/user_score/user_score.dart';
import 'package:eat_it/themes/app_theme.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:eat_it/widgets/basket_list_elem/basket_list_elem.dart';
import 'package:eat_it/widgets/empty_basket_placeholder/empty_basket_placeholder.dart';
import 'package:eat_it/widgets/error_card/error_card.dart';
import 'package:eat_it/widgets/error_screen_wrapper/error_screen_wrapper.dart';
import 'package:eat_it/widgets/page_wrapper/page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:eat_it/widgets/button/button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class BasketPage extends ConsumerWidget {
  const BasketPage({super.key});

  void confirm(WidgetRef ref, BuildContext context) {
    final asyncProductList =
        ref.read(basketStorageProvider.notifier).readBasketStorage();
    asyncProductList.then((value) {
      List<ConfirmPurchaseItem> purchases = value
          .map((e) => ConfirmPurchaseItem(
                qnty: 1,
                barcode: e.barcode,
                points: e.points,
              ))
          .toList();
      final response = ref
          .read(sendedBasketProvider.notifier)
          .sendBasket({'purchase': purchases});

      response.then((value) {
        if (value?.status == true) {
          Future<void> proccesResponse() async {
            ref
                .read(userScore.notifier)
                .update((state) => ref.read(basketPointsProvider));
            ref.read(basketStorageProvider.notifier).clearBasket();
            if (!context.mounted) return;
            context.go('/basket/confirmation');
          }

          proccesResponse();
        }
      });
    });
  }

  void deleteItem(WidgetRef ref, String id) {
    ref.read(basketStorageProvider.notifier).removeProduct(id);
  }

  void clearStorage(WidgetRef ref) {
    ref.read(basketStorageProvider.notifier).clearBasket();
  }

  void scanMore(BuildContext context) {
    context.go('/scanner');
  }

  Widget renderList(WidgetRef ref, totalPoints) {
    final asyncProductList = ref.watch(basketStorageProvider);

    return asyncProductList.when(
      data: (productList) {
        if (productList.isEmpty) {
          return const Text('');
        }

        return ListView(
          padding: EdgeInsets.symmetric(vertical: 12.fontSize),
          shrinkWrap: true,
          children: [
            buildTotalScoreCard(totalPoints),
            SizedBox(height: 20.fontSize),
            for (var item in productList)
              Column(
                children: [
                  BasketListElem(
                    id: item.id ?? '',
                    foodName: item.foodName ?? '',
                    foodType: item.foodType ?? '',
                    quality: item.points ?? 0,
                    onPressed: (id) => deleteItem(ref, id),
                  ),
                  SizedBox(height: 10.fontSize)
                ],
              )
          ],
        );
      },
      error: (err, stack) => Container(),
      loading: () => const SpinKitThreeBounce(
        color: primaryColor,
        size: 50.0,
      ),
    );
  }

  Widget getErrorWidget() {
    return PageWrapper(
        child: Column(
      children: [
        const Spacer(),
        ErrorCard(
          onClose: () {},
          title: tr('scanner.error.title'),
          message: tr('scanner.error.message'),
        ),
      ],
    ));
  }

  Widget renderSpinner(BuildContext context) {
    return PageWrapper(
      child: Container(
        color: Colors.white,
        child: SpinKitCircle(
          color: Theme.of(context).primaryColor,
          size: 50,
        ),
      ),
    );
  }

  Widget buildDeleteAll(BuildContext context, WidgetRef ref) => FittedBox(
        fit: BoxFit.contain,
        child: ElevatedButton(
          onPressed: () => clearStorage(ref),
          style: ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.symmetric(
                vertical: 6.fontSize, horizontal: 24.fontSize)),
            backgroundColor: const MaterialStatePropertyAll(Color(0xFFEB5757)),
            shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100)))),
          ),
          child: Center(
            child: Text("basketpage.dltBtn".tr(),
                style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
      );

  Widget buildTotalScoreCard(totalPoints) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF70C654),
          image: DecorationImage(
            image: AssetImage('assets/basketPage/Intersect.png'),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 7.fontSize, horizontal: 35.fontSize),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    totalPoints.toString(),
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 48.fontSize,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "basketpage.points".tr(),
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 12.fontSize,
                      fontWeight: FontWeight.w500,
                      height: 1.334,
                      letterSpacing: -0.25,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Image.asset("assets/basketPage/6.png", width: 95.fontSize)
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalPoints = ref.watch(basketPointsProvider);
    final asyncRequest = ref.watch(sendedBasketProvider);
    final asyncProductList = ref.watch(basketStorageProvider);

    if (asyncProductList.value != null && asyncProductList.value!.isEmpty) {
      return const EmptyBasketPagePlaceholder();
    }

    return ErrorScreenWrapper(
        child: Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        PageWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDeleteAll(context, ref),
              // buildTotalScoreCard(totalPoints),
              SizedBox(height: 6.fontSize),
              Expanded(child: renderList(ref, totalPoints)),
              SizedBox(height: 6.fontSize),
              Row(
                children: [
                  Expanded(
                    child: Button(
                      mode: ButtonThemeMode.primary,
                      text: "basketpage.confirmBtm".tr(),
                      horizontalPadding: 8.fontSize,
                      onPressed: () => confirm(ref, context),
                    ),
                  ),
                  SizedBox(width: 16.fontSize),
                  Expanded(
                    child: Button(
                      mode: ButtonThemeMode.secondary,
                      text: "basketpage.scanMore".tr(),
                      onPressed: () => scanMore(context),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        asyncRequest.when(
          data: (data) {
            if (data?.status == false) {
              return Container();
            }

            return Container();
          },
          error: (error, stack) => Container(),
          loading: () => renderSpinner(context),
        )
      ],
    ));
  }
}
