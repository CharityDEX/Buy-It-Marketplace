import 'package:dio/dio.dart';

Interceptor versionInterceptor(Dio dio) {
  return InterceptorsWrapper(onRequest: (options, handler) async {
    options.data['version'] = '1.0.0';
    handler.next(options);
  });
}
