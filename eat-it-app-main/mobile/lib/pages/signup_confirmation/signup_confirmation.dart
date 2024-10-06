import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/app_router.dart';
import 'package:eat_it/models/app_error.dart';
import 'package:eat_it/providers/signup/signup.dart';
import 'package:eat_it/widgets/auth_widgets/auth_code_verify/auth_code_verify.dart';
import 'package:eat_it/widgets/auth_widgets/auth_form/auth_form.dart';
import 'package:eat_it/widgets/auth_widgets/auth_form_wrapper/auth_form_wrapper.dart';
import 'package:eat_it/widgets/auth_widgets/auth_redirect_link/have_account.dart';
import 'package:eat_it/widgets/error_card/error_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupConfirmation extends ConsumerStatefulWidget {
  const SignupConfirmation({super.key});

  @override
  ConsumerState<SignupConfirmation> createState() => SignupConfirmationState();
}

class SignupConfirmationState extends ConsumerState<SignupConfirmation> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  AppError? confirmationError;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final response =
        await ref.read(signupProvider.notifier).confirm(code: controller.text);

    if (response != null &&
        response.stage == SignupStage.success &&
        context.mounted) {
      context.goNamed(RouteNames.profile.name);
    } else {
      controller.text = '';
      Future.delayed(const Duration(milliseconds: 150)).then((data) {
        setState(() {
          confirmationError = response?.appError ?? defaultError;
        });
      });
    }
  }

  Widget? buildErrorCard() => Opacity(
        opacity: confirmationError == null ? 0 : 1,
        child: ErrorCard(
          title: confirmationError?.title ?? '',
          message: confirmationError?.message ?? '',
        ),
      );

  Widget buildForm({bool loading = false, bool error = false}) {
    return AuthForm(
      withBack: true,
      formKey: formKey,
      title: 'signup-confirmation.title'.tr(),
      subtitle: 'signup-confirmation.subtitle'.tr(),
      loading: loading,
      submitText: 'signup-confirmation.submit'.tr(),
      onSubmit: onSubmit,
      footer: const HaveAccount(),
      error: buildErrorCard(),
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: AuthCodeVerify(
            controller: controller,
            isError: confirmationError != null,
            onTap: () => setState(() => confirmationError = null),
            onCompleteCode: (completedCode) {},
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var signupState = ref.watch(signupProvider);
    return AuthFormWrapper(
      child: signupState.when(
        data: (data) => buildForm(),
        error: (err, stack) => buildForm(error: true),
        loading: () => buildForm(loading: true),
      ),
    );
  }
}
