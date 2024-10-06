import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/app_router.dart';
import 'package:eat_it/models/app_error.dart';
import 'package:eat_it/providers/login/login.dart';
import 'package:eat_it/regExp/reg_exp.dart';
import 'package:eat_it/utils/pair.dart';
import 'package:eat_it/utils/validation.dart';
import 'package:eat_it/widgets/auth_widgets/auth_form/auth_form.dart';
import 'package:eat_it/widgets/auth_widgets/auth_form_wrapper/auth_form_wrapper.dart';
import 'package:eat_it/widgets/auth_widgets/auth_redirect_link/dont_have_account.dart';
import 'package:eat_it/widgets/auth_widgets/auth_input_wrapper/auth_input_wrapper.dart';
import 'package:eat_it/widgets/error_card/error_card.dart';
import 'package:eat_it/widgets/forgot_password/forgot_password.dart';
import 'package:eat_it/widgets/input/form_input.dart';
import 'package:eat_it/widgets/auth_widgets/password_input/password_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => LoginState();
}

enum Inputs { login, password }

class LoginState extends ConsumerState<Login> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController login = TextEditingController();
  final TextEditingController password = TextEditingController();

  AppError? formError;
  Inputs? inputWithError;

  late List<FormInputValidator> validators;

  LoginState() {
    validators = [
      FormInputValidator(
        getValue: () => login.text.trim(),
        onError: (error) => setInputError(error, Inputs.login, login),
        validation: (value) {
          if (!loginRegex.hasMatch(value) && value.length > 50) {
            return AppError(
              title: 'login.errors.invalid-login.title'.tr(),
              message: 'login.errors.invalid-login.message'.tr(),
            );
          }

          return null;
        },
      ),
      FormInputValidator(
          getValue: () => password.text,
          onError: (error) => setInputError(error, Inputs.password, password),
          validation: (value) {
            if (!passwordRegex.hasMatch(value)) {
              return AppError(
                title: 'login.errors.invalid-password.title'.tr(),
                message: 'login.errors.invalid-password.message'.tr(),
              );
            }

            return null;
          }),
    ];
  }

  void clearError() {
    setState(() {
      formError = null;
      inputWithError = null;
    });
    login.removeListener(clearError);
    password.removeListener(clearError);
  }

  @override
  void dispose() {
    login.dispose();
    password.dispose();
    super.dispose();
  }

  void setInputError(
      AppError error, Inputs input, TextEditingController controller) {
    setState(() {
      formError = error;
      inputWithError = input;
    });
    controller.addListener(clearError);
  }

  void onSubmit(BuildContext context, WidgetRef ref) async {
    FocusManager.instance.primaryFocus?.unfocus();

    final validationResult = validators
        .map((validator) => Pair(validator, validator.validate()))
        .where((element) => element.second != null);

    if (validationResult.isNotEmpty && validationResult.first.second != null) {
      validationResult.first.first.onError(validationResult.first.second!);
      return;
    }

    final authState = await ref
        .read(loginProvider.notifier)
        .login(login.text.trim(), password.text);

    if (authState != null && authState.success && context.mounted) {
      context.goNamed(RouteNames.profile.name);
    } else {
      setState(() => formError = authState?.error ?? defaultError);
    }
  }

  Widget buildErrorWidget() => Opacity(
        opacity: formError == null ? 0 : 1,
        child: ErrorCard(
          title: formError?.title ?? '',
          message: formError?.message ?? '',
        ),
      );

  Widget buildForm({bool loading = false, bool error = false}) {
    return AuthForm(
        formKey: formKey,
        title: 'login.title'.tr(),
        footer: const DontHaveAccount(),
        submitText: "login.submit".tr(),
        loading: loading,
        error: buildErrorWidget(),
        onSubmit: () => onSubmit(context, ref),
        children: [
          AuthInputWrapper(
            child: FormInput(
              isError: inputWithError == Inputs.login,
              controller: login,
              icon: SvgPicture.asset('assets/editProfile/message.svg'),
              placeholder: "login.email-placeholder".tr(),
            ),
          ),
          AuthInputWrapper(
              child: PasswordInput(
            controller: password,
            isError: inputWithError == Inputs.password,
          )),
          Container(
              alignment: AlignmentDirectional.centerEnd,
              child: const ForgotPassword()),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    var asyncAuth = ref.watch(loginProvider);

    return AuthFormWrapper(
      child: asyncAuth.when(
        data: (data) => buildForm(),
        error: (err, stack) => buildForm(error: true),
        loading: () => buildForm(loading: true),
      ),
    );
  }
}
