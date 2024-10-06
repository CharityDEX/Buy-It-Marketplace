import 'package:eat_it/app_router.dart';
import 'package:eat_it/providers/bottom_nav_visible/bottom_nav_visible.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomTabRoute {
  final String route;
  final RouteNames name;
  final IconData icon;

  final Function(BuildContext, WidgetRef)? onRoute;

  const BottomTabRoute({
    required this.route,
    required this.name,
    required this.icon,
    this.onRoute,
  });
}

class AppBottomTabNavogator extends ConsumerStatefulWidget {
  const AppBottomTabNavogator(
      {super.key,
      required this.currentIndex,
      required this.onItemTapped,
      required this.items});

  final int currentIndex;
  final Function onItemTapped;
  final List<BottomTabRoute> items;

  @override
  ConsumerState<AppBottomTabNavogator> createState() =>
      _AppBottomTabNavogatorState();
}

class _AppBottomTabNavogatorState extends ConsumerState<AppBottomTabNavogator> {
  BottomNavigationBarItem renderBottomBarItem(icon, isCurrent, context) {
    return BottomNavigationBarItem(
        icon: Container(
            width: 64.fontSize,
            height: 64.fontSize,
            decoration: BoxDecoration(
                color:
                    isCurrent ? Theme.of(context).primaryColor : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(50))),
            child: Icon(
              icon,
              size: 30.fontSize,
            )),
        label: '');
  }

  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    ref.listen(bottomNavVisible, ((previous, next) {
      setState(() {
        _visible = next;
      });
    }));

    return Visibility(
      visible: _visible,
      child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: BottomNavigationBar(
              elevation: 0,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              backgroundColor: Colors.white,
              items: widget.items
                  .asMap()
                  .entries
                  .map((entry) => renderBottomBarItem(entry.value.icon,
                      widget.currentIndex == entry.key, context))
                  .toList(),
              currentIndex: widget.currentIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: const Color(0xFF333333),
              onTap: (index) => widget.onItemTapped(index, context),
            ),
          )),
    );
  }
}
