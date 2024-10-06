import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:eat_it/app_router.dart';
import 'package:eat_it/providers/scanned_product/scanned_product.dart';
import 'package:eat_it/widgets/app_bottom_tab_navigator/app_bottom_tab_navigator.dart';

class MainRoute extends ConsumerWidget {
  final Widget page;
  MainRoute({super.key, required this.page});

  final routes = [
    const BottomTabRoute(
        route: '/profile',
        name: RouteNames.profile,
        icon: Icons.person_outline),
    BottomTabRoute(
        route: '/scanner',
        name: RouteNames.scanner,
        icon: Icons.camera_outlined,
        onRoute: (context, ref) {
          ref.read(scannedProductProvider.notifier).clearProduct();
        }),
    const BottomTabRoute(
        route: '/basket',
        name: RouteNames.basket,
        icon: Icons.shopping_cart_outlined),
    // const BottomTabRoute(
    //     route: '/store-placeholder',
    //     name: RouteNames.storePagePlaceholder,
    //     icon: Icons.shopping_bag_outlined),
  ];

  int calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    final routeIndex =
        routes.indexWhere((element) => location.startsWith(element.route));

    if (routeIndex == -1) {
      return 0;
    }
    return routeIndex;
  }

  void onItemTapped(int index, BuildContext context, WidgetRef ref) {
    GoRouter.of(context).goNamed(routes[index].name.name);
    if (routes[index].onRoute != null) {
      routes[index].onRoute!(context, ref);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = calculateSelectedIndex(context);
    return Scaffold(
      body: page,
      extendBody: true,
      bottomNavigationBar: AppBottomTabNavogator(
          currentIndex: currentIndex,
          onItemTapped: (index, c) => onItemTapped(index, c, ref),
          items: routes),
    );
  }
}
