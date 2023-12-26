import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/providers/theme.dart';
import 'package:todo/screens/home.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current theme
    final isDarkTheme = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      // Apply theme
      theme: isDarkTheme ?
      ThemeData.dark(
        useMaterial3: true,
      )
          : ThemeData.light(
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
