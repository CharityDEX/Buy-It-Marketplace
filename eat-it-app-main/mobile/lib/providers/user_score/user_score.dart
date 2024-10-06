import 'package:flutter_riverpod/flutter_riverpod.dart';

final userScore = StateProvider<int>((ref) {
  return 0;
});