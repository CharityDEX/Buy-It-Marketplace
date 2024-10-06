import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/fetcher/errors/base_request_error.dart';
import 'package:eat_it/models/app_error.dart';

class NoConnectionRequestError extends BaseRequestError {
  NoConnectionRequestError() : super(0) {
    error = AppError(
      title: 'error.connection-error-title'.tr(),
      message: 'error.connection-error'.tr(),
    );
  }
}
