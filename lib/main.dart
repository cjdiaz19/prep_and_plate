import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'blocs/recipe_cubit.dart';
import 'blocs/shopping_list_cubit.dart';
import 'screens/home_screen.dart';

// ─── Brand colours (mirrors HTML CSS variables) ──────────────────────────────
const kBgDark = Color(0xFF1A1A1A);
const kBgMid = Color(0xFF2D2D2D);
const kBgCard = Color(0xFF242424);
const kCream = Color(0xFFF5F0E8);
const kCreamDim = Color(0xFFE8DFD0);
const kCreamMuted = Color(0xFFB8AD9E);
const kAccent = Color(0xFFE8845A);
const kAccentDeep = Color(0xFFD4614A);
// Borders: rgba(245,240,232,0.08) ≈ alpha 20; accent border ≈ alpha 77
const kBorderColor = Color(0x14F5F0E8);
const kBorderAccent = Color(0x4DE8845A);

void main() {
  runApp(const PrepAndPlateApp());
}

class PrepAndPlateApp extends StatelessWidget {
  const PrepAndPlateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RecipeCubit()),
        BlocProvider(create: (_) => ShoppingListCubit()),
      ],
      child: MaterialApp(
        title: 'Prep & Plate',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: const HomeScreen(),
      ),
    );
  }

  ThemeData _buildTheme() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: kAccent,
      onPrimary: kBgDark,
      primaryContainer: Color(0xFF3D1A0A),
      onPrimaryContainer: kCream,
      secondary: kCreamMuted,
      onSecondary: kBgDark,
      secondaryContainer: Color(0xFF2D2820),
      onSecondaryContainer: kCream,
      tertiary: Color(0xFFD4C5A9),
      onTertiary: kBgDark,
      tertiaryContainer: Color(0xFF282420),
      onTertiaryContainer: kCream,
      error: Color(0xFFCF6679),
      onError: kBgDark,
      errorContainer: Color(0xFF3D1520),
      onErrorContainer: Color(0xFFFFB4BE),
      surface: kBgDark,
      onSurface: kCream,
      surfaceContainerHighest: Color(0xFF383838),
      surfaceContainerHigh: kBgMid,
      surfaceContainer: Color(0xFF262626),
      surfaceContainerLow: kBgCard,
      surfaceContainerLowest: Color(0xFF141414),
      onSurfaceVariant: kCreamMuted,
      outline: Color(0xFF403830),
      outlineVariant: Color(0xFF262220),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: kCream,
      onInverseSurface: kBgDark,
      inversePrimary: kAccentDeep,
      surfaceTint: kAccent,
    );

    final textTheme = _buildTextTheme();

    return ThemeData(
      colorScheme: colorScheme,
      textTheme: textTheme,
      useMaterial3: true,
      scaffoldBackgroundColor: kBgDark,
      appBarTheme: AppBarTheme(
        backgroundColor: kBgDark,
        foregroundColor: kCream,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: kCream,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: kCreamMuted),
        actionsIconTheme: const IconThemeData(color: kCreamMuted),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: kBgDark,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        elevation: 0,
        indicatorColor: kAccent.withAlpha(38),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: kAccent, size: 22);
          }
          return const IconThemeData(color: kCreamMuted, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.courierPrime(
              color: kAccent,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 1,
            );
          }
          return GoogleFonts.courierPrime(
            color: kCreamMuted,
            fontSize: 11,
            letterSpacing: 1,
          );
        }),
      ),
      cardTheme: const CardTheme(
        color: kBgCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          side: BorderSide(color: kBorderColor),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kBgMid,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: kBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: kBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: kBorderAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFCF6679)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFCF6679), width: 1.5),
        ),
        labelStyle: GoogleFonts.courierPrime(
            color: kCreamMuted, fontSize: 13, letterSpacing: 0.5),
        hintStyle: GoogleFonts.courierPrime(
            color: kCreamMuted.withAlpha(128), fontSize: 13),
        errorStyle: GoogleFonts.courierPrime(
            color: Color(0xFFCF6679), fontSize: 11),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: kAccent,
          foregroundColor: kBgDark,
          textStyle: GoogleFonts.courierPrime(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: kAccent,
          side: const BorderSide(color: kBorderAccent),
          textStyle: GoogleFonts.courierPrime(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kAccent,
          textStyle: GoogleFonts.courierPrime(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: kAccent,
        foregroundColor: kBgDark,
        elevation: 4,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return kAccent;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(kBgDark),
        side: const BorderSide(color: kCreamMuted, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: kAccent,
        inactiveTrackColor: kBgMid,
        thumbColor: kAccent,
        overlayColor: kAccent.withAlpha(30),
        valueIndicatorColor: kAccent,
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorTextStyle:
            GoogleFonts.courierPrime(color: kBgDark, fontWeight: FontWeight.w700),
      ),
      dividerTheme: const DividerThemeData(
        color: kBorderColor,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: kCreamMuted),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: kBgMid,
        contentTextStyle: GoogleFonts.courierPrime(color: kCream, fontSize: 13),
        actionTextStyle: GoogleFonts.courierPrime(
            color: kAccent, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: kBgCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: kBorderColor),
        ),
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: kCream,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: GoogleFonts.courierPrime(color: kCreamMuted, fontSize: 13),
      ),
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStateProperty.all(kBgMid),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return const BorderSide(color: kBorderAccent, width: 1.5);
          }
          return const BorderSide(color: kBorderColor);
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        textStyle: WidgetStateProperty.all(
          GoogleFonts.courierPrime(color: kCream, fontSize: 13),
        ),
        hintStyle: WidgetStateProperty.all(
          GoogleFonts.courierPrime(color: kCreamMuted, fontSize: 13),
        ),
      ),
      badgeTheme: const BadgeThemeData(
        backgroundColor: kAccent,
        textColor: kBgDark,
        smallSize: 8,
        largeSize: 18,
      ),
    );
  }

  TextTheme _buildTextTheme() {
    TextStyle serif(double size, FontWeight weight,
        {Color color = kCream, bool italic = false}) =>
        GoogleFonts.playfairDisplay(
          fontSize: size,
          fontWeight: weight,
          color: color,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          height: 1.2,
        );

    TextStyle mono(double size, FontWeight weight, {Color color = kCream}) =>
        GoogleFonts.courierPrime(
          fontSize: size,
          fontWeight: weight,
          color: color,
          height: 1.5,
        );

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
      bodySmall: mono(12, FontWeight.w400, color: kCreamMuted),
      labelLarge: mono(13, FontWeight.w700),
      labelMedium: mono(11, FontWeight.w400, color: kCreamMuted),
      labelSmall: mono(10, FontWeight.w400, color: kCreamMuted),
    );
  }
}
