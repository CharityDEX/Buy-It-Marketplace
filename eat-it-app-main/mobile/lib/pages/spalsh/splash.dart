import 'package:dio/dio.dart';
import 'package:eat_it/app_router.dart';
import 'package:eat_it/async_storage/storage_keys.dart';
import 'package:eat_it/fetcher/fetcher.dart';
import 'package:eat_it/fetcher/interceptors/auth.dart';
import 'package:eat_it/providers/local_storage_provider/local_storage_provider.dart';
import 'package:eat_it/widgets/page_wrapper/page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  @override
  ConsumerState<Splash> createState() => SplashState();
}

Future<bool> isAuth(WidgetRef ref) async {
  try {
    var response =
        await appFetcher.request(ref: ref, chain: 'get-me', body: {});

    if (response?.statusCode == 200) {
      return true;
    }

    return false;
  } on TokenError {
    return false;
  } on DioError catch (e) {
    if (e.response?.statusCode == 401) {
      return false;
    }

    rethrow;
  } catch (e) {
    rethrow;
  }
}

class SplashState extends ConsumerState<Splash> {
  Future<void> checkAuth() async {
    RouteNames routeName;

    bool result = await InternetConnectionChecker().hasConnection;
    if (!result) {
      if (mounted) {
        context.goNamed(RouteNames.noConnection.name);
      }
      return;
    }

    try {
      var response = await isAuth(ref);

      if (response) {
        routeName = RouteNames.profile;
      } else {
        var isOnboarded = ref
                .read(localStorageProvider)
                .getBool(StorageKeys.isOnboarded.name) ??
            false;

        routeName = isOnboarded ? RouteNames.welcome : RouteNames.onboarding;
      }
    } catch (e) {
      routeName = RouteNames.noConnection;
    }

    if (mounted) {
      context.goNamed(routeName.name);
    }
  }

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWrapper(
        child: Center(
          child: Image.asset('assets/icons/logo.png', width: 140, height: 140),
        ),
      ),
    );
  }
}
