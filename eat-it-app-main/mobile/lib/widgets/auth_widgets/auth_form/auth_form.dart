import 'package:eat_it/themes/app_theme.dart';
import 'package:eat_it/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class AuthForm extends ConsumerWidget {
  final GlobalKey formKey;
  final String title;
  final String? subtitle;

  final bool loading;

  final List<Widget> children;
  final Widget footer;
  final Widget? error;

  final String submitText;
  final Function() onSubmit;

  final bool withBack;

  const AuthForm({
    super.key,
    required this.formKey,
    required this.title,
    required this.children,
    required this.footer,
    required this.submitText,
    required this.onSubmit,
    this.error,
    this.withBack = false,
    this.loading = false,
    this.subtitle,
  });

  Widget buildSpinner() => Container(
        child: loading
            ? Stack(children: [
                Positioned.fill(child: Container(color: Colors.white38)),
                const SpinKitCircle(color: secondaryColor, size: 70),
              ])
            : null,
      );

  Widget buildBackButton(BuildContext context) => Positioned(
        left: 16,
        top: 16,
        child: IconButton(
            onPressed: () {
              if (context.canPop()) context.pop();
            },
            icon: const Icon(Icons.chevron_left_outlined, size: 32)),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(children: [
      Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              const Spacer(flex: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  title.toLowerCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: Colors.black),
                ),
              ),
              Container(
                child: subtitle != null
                    ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          subtitle ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.black),
                        ),
                      )
                    : null,
              ),
              const Spacer(flex: 2),
              ...children,
              const Spacer(flex: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                margin: const EdgeInsets.only(top: 12),
                child: Button(
                    text: submitText,
                    onPressed: () => onSubmit(),
                    mode: ButtonThemeMode.accountActions),
              ),
              const Spacer(flex: 6),
              const SizedBox(height: 12),
              error != null ? Container(child: error) : Container(),
              footer,
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      Container(child: withBack ? buildBackButton(context) : null),
      buildSpinner()
    ]);
  }
}
