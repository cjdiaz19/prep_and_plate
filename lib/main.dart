import 'package:flutter/material.dart';
import 'state/app_state.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PrepAndPlateApp());
}

class PrepAndPlateApp extends StatefulWidget {
  const PrepAndPlateApp({super.key});

  @override
  State<PrepAndPlateApp> createState() => _PrepAndPlateAppState();
}

class _PrepAndPlateAppState extends State<PrepAndPlateApp> {
  final _appState = AppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      state: _appState,
      child: MaterialApp(
        title: 'Prep & Plate',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(Brightness.light),
        darkTheme: _buildTheme(Brightness.dark),
        home: const HomeScreen(),
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4CAF50),
      brightness: brightness,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
    );
  }
}
