import 'package:flutter/widgets.dart';

import 'package:go_router/go_router.dart';

import 'package:eat_it/pages/forgot_password/restore_password/restore_password.dart';
import 'package:eat_it/pages/forgot_password/restore_password_confirmation/restore_password_confirmation.dart';
import 'package:eat_it/pages/forgot_password/set_new_passwrod/set_new_password.dart';
import 'package:eat_it/pages/login/login.dart';
import 'package:eat_it/pages/main_route/main_route.dart';
import 'package:eat_it/pages/main_route/pages/basket/basket.dart';
import 'package:eat_it/pages/main_route/pages/confirmation/confirmation.dart';
import 'package:eat_it/pages/main_route/pages/edit_profile/edit_profile.dart';
import 'package:eat_it/pages/main_route/pages/no_connection/no_connection.dart';
import 'package:eat_it/pages/main_route/pages/profile/profile.dart';
import 'package:eat_it/pages/main_route/pages/scanner/more_info.dart';
import 'package:eat_it/pages/main_route/pages/scanner/scanner.dart';
import 'package:eat_it/pages/onboarding/onboarding.dart';
import 'package:eat_it/pages/privacy_policy/privacy_policy.dart';
import 'package:eat_it/pages/signup/signup.dart';
import 'package:eat_it/pages/signup_confirmation/signup_confirmation.dart';
import 'package:eat_it/pages/spalsh/splash.dart';
import 'package:eat_it/pages/terms_of_service/terms_of_service.dart';
import 'package:eat_it/pages/welcome/welcome.dart';

enum RouteNames {
  profile,
  scanner,
  moreInfo,
  basket,
  onboarding,
  welcome,
  buyConfirmation,
  editProfile,
  login,
  signup,
  signupConfirmation,
  restorePassword,
  restorePasswordConfirmation,
  setNewPassword,
  splash,
  noConnection,
  termsOfService,
  privacyPolicy,
  storePagePlaceholder
}

final GlobalKey<NavigatorState> navigator = GlobalKey();

GoRouter getAppRouter() {
  return GoRouter(
    navigatorKey: navigator,
    routes: [
      ShellRoute(
          builder: (context, state, child) => MainRoute(page: child),
          routes: [
            GoRoute(
              name: RouteNames.profile.name,
              path: '/profile',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const Profile(),
              ),
            ),
            GoRoute(
              name: RouteNames.scanner.name,
              path: '/scanner',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const Scanner(),
              ),
            ),
            GoRoute(
              name: RouteNames.moreInfo.name,
              path: '/scanner/more-info',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const MoreInfo(),
              ),
            ),
            GoRoute(
              name: RouteNames.basket.name,
              path: '/basket',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const BasketPage(),
              ),
            ),
            GoRoute(
              name: RouteNames.buyConfirmation.name,
              path: '/basket/confirmation',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const BuyConfirmation(),
              ),
            ),
            GoRoute(
              name: RouteNames.editProfile.name,
              path: '/edit-profile',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const EditProfile(),
              ),
            ),
            // GoRoute(
            //   name: RouteNames.storePagePlaceholder.name,
            //   path: '/store-placeholder',
            //   pageBuilder: (context, state) => NoTransitionPage(
            //     key: state.pageKey,
            //     child: const StorePlaceholderPage(),
            //   ),
            // ),
          ]),
      GoRoute(
        name: RouteNames.onboarding.name,
        path: '/onboarding',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const Onboarding()),
      ),
      GoRoute(
          name: RouteNames.welcome.name,
          path: '/welcome',
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const Welcome())),
      GoRoute(
        name: RouteNames.login.name,
        path: '/login',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const Login()),
      ),
      GoRoute(
        name: RouteNames.signup.name,
        path: '/signup',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const Signup()),
      ),
      GoRoute(
        name: RouteNames.signupConfirmation.name,
        path: '/signup/confirmation',
        pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey, child: const SignupConfirmation()),
      ),
      GoRoute(
        name: RouteNames.restorePassword.name,
        path: '/restore-password/restore',
        pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey, child: const RestorePassword()),
      ),
      GoRoute(
        name: RouteNames.restorePasswordConfirmation.name,
        path: '/restore-password/confirmation',
        pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey, child: const RestorePasswordConfirmation()),
      ),
      GoRoute(
        name: RouteNames.setNewPassword.name,
        path: '/restore-password/passwords',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const SetNewPassword()),
      ),
      GoRoute(
        name: RouteNames.splash.name,
        path: '/splash',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const Splash()),
      ),
      GoRoute(
        name: RouteNames.noConnection.name,
        path: '/no-connection',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const NoConnection()),
      ),
      GoRoute(
        name: RouteNames.privacyPolicy.name,
        path: '/privacy-policy',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const PrivacyPolicy()),
      ),
      GoRoute(
        name: RouteNames.termsOfService.name,
        path: '/terms-of-service',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const TermsOfService()),
      )
    ],
    initialLocation: '/splash',
  );
}
