import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final futureSharedPreferences = SharedPreferences.getInstance();

Interceptor localeInterceptor(Dio dio) {
  return InterceptorsWrapper(onRequest: (options, handler) async {
    final sharedPreferences = await futureSharedPreferences;
    options.data['locale'] = sharedPreferences.getString('locale');
    handler.next(options);
  });
}
