import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract final class AppColors {
  static const ink = Color(0xFF211F19);
  static const muted = Color(0xFF8A806B);
  static const forest = Color(0xFF207A45);
  static const leaf = Color(0xFF78A891);
  static const lime = Color(0xFFE1EDD6);
  static const gold = Color(0xFFFFCA39);
  static const cream = Color(0xFFFAF7F0);
  static const paper = Color(0xFFFFFFFF);
  static const line = Color(0xFFE9DCC3);
  static const danger = Color(0xFFB43F43);
  static const night = Color(0xFF111E19);
  static const nightSurface = Color(0xFF1B2D25);
  static const nightLine = Color(0xFF344A3E);
  static const nightMuted = Color(0xFFB4C5B9);
}

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final foreground = dark ? const Color(0xFFF0F5EC) : AppColors.ink;
    final muted = dark ? AppColors.nightMuted : AppColors.muted;
    final surface = dark ? AppColors.nightSurface : AppColors.paper;
    final line = dark ? AppColors.nightLine : AppColors.line;
    final primary = dark ? AppColors.lime : AppColors.forest;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.forest,
      brightness: brightness,
      primary: primary,
      onPrimary: dark ? AppColors.ink : Colors.white,
      primaryContainer: dark
          ? const Color(0xFF2B4435)
          : const Color(0xFFDCF2E5),
      onPrimaryContainer: foreground,
      secondary: dark ? AppColors.gold : const Color(0xFF795A10),
      secondaryContainer: dark
          ? const Color(0xFF443A23)
          : const Color(0xFFFFF0C3),
      onSecondaryContainer: dark
          ? const Color(0xFFFFE6A3)
          : const Color(0xFF705311),
      surface: surface,
      onSurface: foreground,
      onSurfaceVariant: muted,
      outlineVariant: line,
      error: dark ? const Color(0xFFFFB4AB) : AppColors.danger,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Tajawal',
    );
    final text = base.textTheme
        .apply(bodyColor: foreground, displayColor: foreground)
        .copyWith(
          displaySmall: TextStyle(
            fontFamily: 'Tajawal',
            color: foreground,
            fontSize: 36,
            height: 1.4,
            fontWeight: FontWeight.w800,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Tajawal',
            color: foreground,
            fontSize: 28,
            height: 1.4,
            fontWeight: FontWeight.w800,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Tajawal',
            color: foreground,
            fontSize: 21,
            height: 1.4,
            fontWeight: FontWeight.w700,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Tajawal',
            color: foreground,
            fontSize: 17,
            height: 1.5,
            fontWeight: FontWeight.w700,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Tajawal',
            color: foreground,
            fontSize: 16,
            height: 1.65,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Tajawal',
            color: muted,
            fontSize: 14,
            height: 1.6,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Tajawal',
            color: foreground,
            fontSize: 15,
            height: 1.4,
            fontWeight: FontWeight.w700,
          ),
        );
    final outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: line),
    );
    final buttonText = text.labelLarge!;
    return base.copyWith(
      colorScheme: scheme,
      textTheme: text,
      scaffoldBackgroundColor: dark ? AppColors.night : AppColors.cream,
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? AppColors.night : AppColors.cream,
        foregroundColor: foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
        systemOverlayStyle: dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: line),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        labelStyle: text.bodyMedium,
        hintStyle: text.bodyMedium,
        prefixIconColor: muted,
        suffixIconColor: muted,
        border: outline,
        enabledBorder: outline,
        focusedBorder: outline.copyWith(
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          minimumSize: const Size(48, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: buttonText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          textStyle: buttonText,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(48, 52),
          textStyle: buttonText,
          side: BorderSide(color: line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: buttonText,
          minimumSize: const Size(48, 48),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: scheme.primaryContainer,
        labelStyle: text.labelLarge,
        side: BorderSide(color: line),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: scheme.primaryContainer,
        elevation: 0,
        height: 76,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => buttonText.copyWith(
            fontSize: 13,
            color: states.contains(WidgetState.selected) ? primary : muted,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: scheme.onPrimary,
        elevation: 2,
        extendedTextStyle: buttonText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: dark ? AppColors.lime : AppColors.ink,
        contentTextStyle: text.bodyMedium!.copyWith(
          color: dark ? AppColors.ink : Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerColor: line,
    );
  }
}
