import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/app_router.dart';
import 'package:eat_it/models/app_error.dart';
import 'package:eat_it/providers/restore_password/restore_password.dart';
import 'package:eat_it/widgets/auth_widgets/auth_code_verify/auth_code_verify.dart';
import 'package:eat_it/widgets/auth_widgets/auth_form/auth_form.dart';
import 'package:eat_it/widgets/auth_widgets/auth_form_wrapper/auth_form_wrapper.dart';
import 'package:eat_it/widgets/auth_widgets/auth_redirect_link/dont_have_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/error_card/error_card.dart';

class RestorePasswordConfirmation extends ConsumerStatefulWidget {
  const RestorePasswordConfirmation({super.key});

  @override
  ConsumerState<RestorePasswordConfirmation> createState() =>
      RestorePasswordConfirmationState();
}

class RestorePasswordConfirmationState
    extends ConsumerState<RestorePasswordConfirmation> {
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

    final response = await ref
        .read(restorePasswordProvider.notifier)
        .confirm(code: controller.text);

    if (response != null &&
        response.stage == RestorePasswordStage.setNewPassword &&
        context.mounted) {
      context.pushNamed(RouteNames.setNewPassword.name);
    } else {
      controller.text = '';
      Future.delayed(const Duration(milliseconds: 150)).then((data) {
        setState(() {
          confirmationError = response?.error ?? defaultError;
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
      title: 'restore-password.confirmation.title'.tr(),
      subtitle: 'restore-password.confirmation.subtitle'.tr(),
      loading: loading,
      submitText: 'restore-password.confirmation.submit'.tr(),
      onSubmit: onSubmit,
      footer: const DontHaveAccount(),
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
