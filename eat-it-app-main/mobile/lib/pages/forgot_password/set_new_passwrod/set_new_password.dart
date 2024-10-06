import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/app_router.dart';
import 'package:eat_it/models/app_error.dart';
import 'package:eat_it/providers/restore_password/restore_password.dart';
import 'package:eat_it/regExp/reg_exp.dart';
import 'package:eat_it/utils/pair.dart';
import 'package:eat_it/utils/validation.dart';
import 'package:eat_it/widgets/auth_widgets/auth_form/auth_form.dart';
import 'package:eat_it/widgets/auth_widgets/auth_form_wrapper/auth_form_wrapper.dart';
import 'package:eat_it/widgets/auth_widgets/auth_input_wrapper/auth_input_wrapper.dart';
import 'package:eat_it/widgets/auth_widgets/auth_redirect_link/dont_have_account.dart';
import 'package:eat_it/widgets/auth_widgets/password_input/password_input.dart';
import 'package:eat_it/widgets/error_card/error_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SetNewPassword extends ConsumerStatefulWidget {
  const SetNewPassword({super.key});

  @override
  ConsumerState<SetNewPassword> createState() => SetNewPasswordState();
}

enum Inputs { password, repeatPassword }

class SetNewPasswordState extends ConsumerState<SetNewPassword> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController password = TextEditingController();
  final TextEditingController repeatPassword = TextEditingController();
  late List<FormInputValidator> validators;

  AppError? appError;
  Inputs? inputWithError;

  void setInputError(
      AppError error, Inputs input, TextEditingController controller) {
    setState(() {
      appError = error;
      inputWithError = input;
    });
    controller.addListener(clearError);
  }

  void clearError() {
    setState(() {
      appError = null;
      inputWithError = null;
    });
    password.removeListener(clearError);
    repeatPassword.removeListener(clearError);
  }

  SetNewPasswordState() {
    validators = [
      FormInputValidator(
          getValue: () => password.text,
          onError: (error) => setInputError(error, Inputs.password, password),
          validation: (value) {
            if (!passwordRegex.hasMatch(value)) {
              return AppError(
                title: 'signup.errors.invalid-password.title'.tr(),
                message: 'signup.errors.invalid-password.message'.tr(),
              );
            }

            return null;
          }),
      FormInputValidator(
          getValue: () => repeatPassword.text,
          onError: (error) =>
              setInputError(error, Inputs.repeatPassword, repeatPassword),
          validation: (value) {
            if (value != password.text) {
              return AppError(
                title: 'signup.errors.password-mismatch.title'.tr(),
                message: 'signup.errors.password-mismatch.message'.tr(),
              );
            }

            return null;
          }),
    ];
  }

  @override
  void dispose() {
    password.dispose();
    repeatPassword.dispose();
    super.dispose();
  }

  void onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final validationResult = validators
        .map((validator) => Pair(validator, validator.validate()))
        .where((element) => element.second != null);

    if (validationResult.isNotEmpty && validationResult.first.second != null) {
      validationResult.first.first.onError(validationResult.first.second!);
      return;
    }

    final response = await ref
        .read(restorePasswordProvider.notifier)
        .setNewPassword(password: password.text);

    if (response != null &&
        response.stage == RestorePasswordStage.success &&
        context.mounted) {
      context.goNamed(RouteNames.profile.name);
    } else {
      setState(() => appError = response?.error ?? defaultError);
    }
  }

  Widget? buildErrorCard() => Opacity(
        opacity: appError == null ? 0 : 1,
        child: ErrorCard(
          title: appError?.title ?? '',
          message: appError?.message ?? '',
        ),
      );

  Widget buildForm({bool loading = false, bool error = false}) {
    return AuthForm(
      formKey: formKey,
      title: 'restore-password.restore.title'.tr(),
      loading: loading,
      submitText: 'restore-password.restore.submit'.tr(),
      onSubmit: onSubmit,
      footer: const DontHaveAccount(),
      error: buildErrorCard(),
      children: [
        AuthInputWrapper(
          child: PasswordInput(
            controller: password,
            isError: inputWithError == Inputs.password,
          ),
        ),
        AuthInputWrapper(
          child: PasswordInput(
            controller: repeatPassword,
            repeatPassword: true,
            isError: inputWithError == Inputs.repeatPassword,
          ),
        ),
        const Spacer(),
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
