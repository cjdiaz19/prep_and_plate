import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Builds the single app-wide [ThemeData].
abstract final class AppTheme {
  static ThemeData build() {
    const cs = _colorScheme;
    return ThemeData(
      colorScheme: cs,
      textTheme: _textTheme(),
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bgDark,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgDark,
        foregroundColor: AppColors.cream,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: AppColors.cream,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: AppColors.creamMuted),
        actionsIconTheme: const IconThemeData(color: AppColors.creamMuted),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.bgDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: AppColors.accent.withAlpha(38),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.accent, size: 22);
          }
          return const IconThemeData(color: AppColors.creamMuted, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final base = GoogleFonts.courierPrime(fontSize: 11, letterSpacing: 1);
          if (states.contains(WidgetState.selected)) {
            return base.copyWith(
                color: AppColors.accent, fontWeight: FontWeight.w700);
          }
          return base.copyWith(color: AppColors.creamMuted);
        }),
      ),
      cardTheme: const CardTheme(
        color: AppColors.bgCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          side: BorderSide(color: AppColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgMid,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide:
              const BorderSide(color: AppColors.borderAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide:
              const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: GoogleFonts.courierPrime(
            color: AppColors.creamMuted, fontSize: 13, letterSpacing: 0.5),
        hintStyle: GoogleFonts.courierPrime(
            color: AppColors.creamMuted.withAlpha(128), fontSize: 13),
        errorStyle:
            GoogleFonts.courierPrime(color: AppColors.error, fontSize: 11),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.bgDark,
          textStyle: GoogleFonts.courierPrime(
              fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: const BorderSide(color: AppColors.borderAccent),
          textStyle: GoogleFonts.courierPrime(
              fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: GoogleFonts.courierPrime(
              fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.bgDark,
        elevation: 4,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.accent;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.bgDark),
        side: const BorderSide(color: AppColors.creamMuted, width: 1.5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.accent,
        inactiveTrackColor: AppColors.bgMid,
        thumbColor: AppColors.accent,
        overlayColor: AppColors.accent.withAlpha(30),
        valueIndicatorColor: AppColors.accent,
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorTextStyle: GoogleFonts.courierPrime(
            color: AppColors.bgDark, fontWeight: FontWeight.w700),
      ),
      dividerTheme: const DividerThemeData(
          color: AppColors.border, thickness: 1, space: 1),
      iconTheme: const IconThemeData(color: AppColors.creamMuted),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.bgMid,
        contentTextStyle:
            GoogleFonts.courierPrime(color: AppColors.cream, fontSize: 13),
        actionTextStyle: GoogleFonts.courierPrime(
            color: AppColors.accent, fontWeight: FontWeight.w700),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.bgCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
        titleTextStyle: GoogleFonts.playfairDisplay(
            color: AppColors.cream, fontSize: 20, fontWeight: FontWeight.w700),
        contentTextStyle: GoogleFonts.courierPrime(
            color: AppColors.creamMuted, fontSize: 13),
      ),
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStateProperty.all(AppColors.bgMid),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return const BorderSide(color: AppColors.borderAccent, width: 1.5);
          }
          return const BorderSide(color: AppColors.border);
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        textStyle: WidgetStateProperty.all(
            GoogleFonts.courierPrime(color: AppColors.cream, fontSize: 13)),
        hintStyle: WidgetStateProperty.all(GoogleFonts.courierPrime(
            color: AppColors.creamMuted, fontSize: 13)),
      ),
      badgeTheme: const BadgeThemeData(
        backgroundColor: AppColors.accent,
        textColor: AppColors.bgDark,
        smallSize: 8,
        largeSize: 18,
      ),
    );
  }

  // ── Color scheme ───────────────────────────────────────────────────────────
  static const _colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.accent,
    onPrimary: AppColors.bgDark,
    primaryContainer: Color(0xFF3D1A0A),
    onPrimaryContainer: AppColors.cream,
    secondary: AppColors.creamMuted,
    onSecondary: AppColors.bgDark,
    secondaryContainer: Color(0xFF2D2820),
    onSecondaryContainer: AppColors.cream,
    tertiary: Color(0xFFD4C5A9),
    onTertiary: AppColors.bgDark,
    tertiaryContainer: Color(0xFF282420),
    onTertiaryContainer: AppColors.cream,
    error: AppColors.error,
    onError: AppColors.bgDark,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: Color(0xFFFFB4BE),
    surface: AppColors.bgDark,
    onSurface: AppColors.cream,
    surfaceContainerHighest: Color(0xFF383838),
    surfaceContainerHigh: AppColors.bgMid,
    surfaceContainer: Color(0xFF262626),
    surfaceContainerLow: AppColors.bgCard,
    surfaceContainerLowest: Color(0xFF141414),
    onSurfaceVariant: AppColors.creamMuted,
    outline: Color(0xFF403830),
    outlineVariant: Color(0xFF262220),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.cream,
    onInverseSurface: AppColors.bgDark,
    inversePrimary: AppColors.accentDeep,
    surfaceTint: AppColors.accent,
  );

  // ── Text theme ─────────────────────────────────────────────────────────────
  static TextTheme _textTheme() {
    TextStyle serif(double size, FontWeight weight,
            {Color color = AppColors.cream, bool italic = false}) =>
        GoogleFonts.playfairDisplay(
          fontSize: size,
          fontWeight: weight,
          color: color,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          height: 1.2,
        );

    TextStyle mono(double size, FontWeight weight,
            {Color color = AppColors.cream}) =>
        GoogleFonts.courierPrime(
            fontSize: size, fontWeight: weight, color: color, height: 1.5);

    return TextTheme(
      displayLarge: serif(57, FontWeight.w900),
      displayMedium: serif(45, FontWeight.w700),
      displaySmall: serif(36, FontWeight.w700),
      headlineLarge: serif(32, FontWeight.w700),
      headlineMedium: serif(28, FontWeight.w700),
      headlineSmall: serif(24, FontWeight.w700),
      titleLarge: serif(22, FontWeight.w700),
      titleMedium: serif(18, FontWeight.w600),
      titleSmall: serif(15, FontWeight.w600),
      bodyLarge: mono(15, FontWeight.w400),
      bodyMedium: mono(13, FontWeight.w400),
      bodySmall: mono(12, FontWeight.w400, color: AppColors.creamMuted),
      labelLarge: mono(13, FontWeight.w700),
      labelMedium: mono(11, FontWeight.w400, color: AppColors.creamMuted),
      labelSmall: mono(10, FontWeight.w400, color: AppColors.creamMuted),
    );
  }
}
