import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateProvider used for explicitly updating state and rebuilding widgets for FutureProvider.
final futureUpdaterProvider = StateProvider<int>(
      (ref) => 0,
);