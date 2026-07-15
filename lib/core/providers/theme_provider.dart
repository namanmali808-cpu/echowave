import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.dark;
});

final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(themeModeProvider) == ThemeMode.dark;
});

final toggleThemeProvider = Provider<void Function()>((ref) {
  return () {
    ref.read(themeModeProvider.notifier).update((state) {
      return state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  };
});
