import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavVisible = StateProvider.autoDispose<bool>((ref) {
  return true;
});