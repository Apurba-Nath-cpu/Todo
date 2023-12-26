import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateProvider to provide current theme information
final themeProvider = StateProvider<bool>(
      (ref) => false,
);