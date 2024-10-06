import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localStorageProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());
