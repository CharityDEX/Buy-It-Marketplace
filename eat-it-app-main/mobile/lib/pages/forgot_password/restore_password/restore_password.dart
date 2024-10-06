import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/app_router.dart';
import 'package:eat_it/models/app_error.dart';
import 'package:eat_it/providers/restore_password/restore_password.dart';
import 'package:eat_it/regExp/reg_exp.dart';
import 'package:eat_it/widgets/auth_widgets/auth_form/auth_form.dart';
import 'package:eat_it/widgets/auth_widgets/auth_form_wrapper/auth_form_wrapper.dart';
import 'package:eat_it/widgets/auth_widgets/auth_input_wrapper/auth_input_wrapper.dart';
import 'package:eat_it/widgets/auth_widgets/auth_redirect_link/dont_have_account.dart';
import 'package:eat_it/widgets/error_card/error_card.dart';
import 'package:eat_it/widgets/input/form_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class RestorePassword extends ConsumerStatefulWidget {
  const RestorePassword({super.key});

  @override
  ConsumerState<RestorePassword> createState() => RestorePasswordState();
}

class RestorePasswordState extends ConsumerState<RestorePassword> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController login = TextEditingController();

  AppError? formError;

  RestorePasswordState() {
    login.addListener(() {
      if (formError != null) {
        setState(() {
          formError = null;
        });
      }
    });
  }

  void onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!loginRegex.hasMatch(login.text.trim())) {
      setState(() {
        formError = AppError(
          title: 'restore-password.start.errors.invalid-login.title'.tr(),
          message: 'restore-password.start.errors.invalid-login.message'.tr(),
        );
      });
      return;
    }

    final response = await ref
        .read(restorePasswordProvider.notifier)
        .restorePassword(login: login.text.trim());

    if (response?.stage == RestorePasswordStage.verifyCode && context.mounted) {
      context.pushNamed(RouteNames.restorePasswordConfirmation.name);
    } else {
      setState(() {
        formError = response?.error ?? defaultError;
      });
    }
  }

  Widget? buildErrorCard() => Opacity(
        opacity: formError == null ? 0 : 1,
        child: ErrorCard(
          title: formError?.title ?? '',
          message: formError?.message ?? '',
        ),
      );

  Widget buildForm({bool loading = false, bool error = false}) {
    return AuthForm(
      withBack: true,
      formKey: formKey,
      title: 'restore-password.start.title'.tr(),
      loading: loading,
      submitText: 'restore-password.start.submit'.tr(),
      onSubmit: onSubmit,
      footer: const DontHaveAccount(),
      error: buildErrorCard(),
      children: [
        AuthInputWrapper(
          child: FormInput(
            isError: formError != null,
            controller: login,
            icon: SvgPicture.asset('assets/editProfile/message.svg'),
            placeholder: 'restore-password.start.login.placeholder'.tr(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var restoreState = ref.watch(restorePasswordProvider);

    return AuthFormWrapper(
      child: restoreState.when(
        data: (data) => buildForm(),
        error: (err, stack) => buildForm(error: true),
        loading: () => buildForm(loading: true),
      ),
    );
  }
}
