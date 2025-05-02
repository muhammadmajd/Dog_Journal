// test/app/theme/theme_provider_test.dart
import 'package:dog/app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeProvider', () {
    test('initial theme is system', () {
      final provider = ThemeProvider();
      expect(provider.themeMode, ThemeMode.system);
    });

    test('toggleTheme changes to dark when light', () {
      final provider = ThemeProvider();
      provider.toggleTheme(true);
      expect(provider.themeMode, ThemeMode.dark);
    });

    test('toggleTheme changes to light when dark', () {
      final provider = ThemeProvider();
      provider.toggleTheme(false);
      expect(provider.themeMode, ThemeMode.light);
    });
  });
}