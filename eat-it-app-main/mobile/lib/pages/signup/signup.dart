import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/app_router.dart';
import 'package:eat_it/models/app_error.dart';
import 'package:eat_it/providers/signup/signup.dart';
import 'package:eat_it/regExp/reg_exp.dart';
import 'package:eat_it/themes/app_theme.dart';
import 'package:eat_it/utils/pair.dart';
import 'package:eat_it/utils/validation.dart';
import 'package:eat_it/widgets/app_checkbox/app_checkbox.dart';
import 'package:eat_it/widgets/auth_widgets/auth_form/auth_form.dart';
import 'package:eat_it/widgets/auth_widgets/auth_form_wrapper/auth_form_wrapper.dart';
import 'package:eat_it/widgets/auth_widgets/auth_redirect_link/have_account.dart';
import 'package:eat_it/widgets/auth_widgets/auth_input_wrapper/auth_input_wrapper.dart';
import 'package:eat_it/widgets/error_card/error_card.dart';
import 'package:eat_it/widgets/input/form_input.dart';
import 'package:eat_it/widgets/auth_widgets/password_input/password_input.dart';
import 'package:eat_it/widgets/term_links/term_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class Signup extends ConsumerStatefulWidget {
  const Signup({super.key});

  @override
  ConsumerState<Signup> createState() => SignupState();
}

enum Inputs { email, username, password, repeatPassword, agree }

class SignupState extends ConsumerState<Signup> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController repeatPassword = TextEditingController();

  bool agree = false;
  AppError? formError;
  Inputs? inputWithError;

  late List<FormInputValidator> validators;

  void setInputError(
      AppError error, Inputs input, TextEditingController controller) {
    setState(() {
      formError = error;
      inputWithError = input;
    });
    controller.addListener(clearError);
  }

  void toggleAgree() {
    setState(() {
      agree = !agree;
      if (inputWithError == Inputs.agree) {
        formError = null;
        inputWithError = null;
      }
    });
  }

  SignupState() {
    validators = [
      FormInputValidator(
        getValue: () => email.text.trim(),
        onError: (error) => setInputError(error, Inputs.email, email),
        validation: (value) {
          if (!emailRegex.hasMatch(value) || value.length > 50) {
            return AppError(
              title: 'signup.errors.invalid-email.title'.tr(),
              message: 'signup.errors.invalid-email.message'.tr(),
            );
          }

          return null;
        },
      ),
      FormInputValidator(
        getValue: () => username.text.trim(),
        onError: (error) => setInputError(error, Inputs.username, username),
        validation: (value) {
          if (value.isEmpty ||
              value.length > 50 ||
              !usernameRegex.hasMatch(value)) {
            return AppError(
              title: 'signup.errors.invalid-username.title'.tr(),
              message: 'signup.errors.invalid-username.message'.tr(),
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
      FormInputValidator<bool>(
          getValue: () => agree,
          onError: (error) => setState(() {
                formError = error;
                inputWithError = Inputs.agree;
              }),
          validation: (value) {
            if (value == false) {
              return AppError(
                title: 'signup.errors.invalid-agree.title'.tr(),
                message: 'signup.errors.invalid-agree.message'.tr(),
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
    email.removeListener(clearError);
    username.removeListener(clearError);
    password.removeListener(clearError);
    repeatPassword.removeListener(clearError);
  }

  @override
  void dispose() {
    email.dispose();
    username.dispose();
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

    final response = await ref.read(signupProvider.notifier).signup(
          email: email.text.trim(),
          username: username.text.trim(),
          password: password.text,
        );

    if (response != null) {
      if (response.stage == SignupStage.confirmation && context.mounted) {
        context.pushNamed(RouteNames.signupConfirmation.name);
      } else {
        setState(() => formError = response.appError);
      }
    } else {
      setState(() => formError = defaultError);
    }
  }

  Widget buildSpinner(bool loading) {
    return Container(
      child: loading
          ? Stack(children: [
              Positioned.fill(child: Container(color: Colors.white38)),
              const SpinKitCircle(
                color: secondaryColor,
                size: 70,
              ),
            ])
          : null,
    );
  }

  Widget buildCheckbox() => Container(
      margin: const EdgeInsets.only(top: 20),
      child: AppCheckbox(
        value: agree,
        isError: inputWithError == Inputs.agree,
        onChanged: (newValue) => toggleAgree(),
        label: TermLinks(
          color: inputWithError == Inputs.agree ? dangerColor : Colors.black,
        ),
      ));

  Widget? buildErrorCard() => Opacity(
        opacity: formError == null ? 0 : 1,
        child: ErrorCard(
          title: formError?.title ?? '',
          message: formError?.message ?? '',
        ),
      );

  Widget buildForm(BuildContext context, WidgetRef ref,
      {bool loading = false, bool error = false}) {
    return AuthForm(
      formKey: formKey,
      title: 'signup.title'.tr(),
      loading: loading,
      submitText: 'signup.submit'.tr(),
      onSubmit: onSubmit,
      footer: const HaveAccount(),
      error: buildErrorCard(),
      children: [
        AuthInputWrapper(
          child: FormInput(
            isError: inputWithError == Inputs.email,
            controller: email,
            validator: (value) => '',
            icon: SvgPicture.asset('assets/editProfile/message.svg'),
            placeholder: "signup.email.placeholder".tr(),
          ),
        ),
        AuthInputWrapper(
          child: FormInput(
            isError: inputWithError == Inputs.username,
            controller: username,
            validator: (value) => '',
            icon: SvgPicture.asset('assets/icons/user.svg'),
            placeholder: "signup.username.placeholder".tr(),
          ),
        ),
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
        buildCheckbox(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var signupState = ref.watch(signupProvider);

    return AuthFormWrapper(
      child: signupState.when(
        data: (data) => buildForm(context, ref),
        error: (err, stack) => buildForm(context, ref, error: true),
        loading: () => buildForm(context, ref, loading: true),
      ),
    );
  }
}
