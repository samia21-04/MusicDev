import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/session_provider.dart';
import 'screens/home_screen.dart';
import 'screens/focus_session_screen.dart';
import 'screens/soundscape_builder_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SessionProvider(),
      child: const MyApp(),
    ),
  );
}

// ── Color Palette ─────────────────────────────────────────
// Use these constants anywhere in the app for consistency
class AppColors {
  static const background   = Color(0xFF1A1014); // near black with warm tint
  static const surface      = Color(0xFF2A1A1F); // dark maroon surface
  static const card         = Color(0xFF321820); // slightly lighter card bg
  static const maroon       = Color(0xFF7B2D3E); // primary maroon
  static const maroonLight  = Color(0xFF9E3D52); // lighter maroon for accents
  static const maroonDark   = Color(0xFF5C1F2E); // deeper maroon for borders
  static const cream        = Color(0xFFF5ECD7); // primary cream text
  static const creamMuted   = Color(0xFFBFAD99); // muted cream for subtitles
  static const creamFaint   = Color(0xFF6B5E52); // very muted for hints
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adaptive Focus Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.maroon,
          secondary: AppColors.maroonLight,
          surface: AppColors.surface,
          onPrimary: AppColors.cream,
          onSecondary: AppColors.cream,
          onSurface: AppColors.cream,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.cream,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.cream,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        cardTheme: CardTheme(
          color: AppColors.card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.maroonDark, width: 0.5),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.maroon,
            foregroundColor: AppColors.cream,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.cream,
            side: const BorderSide(color: AppColors.maroon),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: AppColors.maroon,
          inactiveTrackColor: AppColors.maroonDark,
          thumbColor: AppColors.cream,
          overlayColor: Color(0x227B2D3E),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? AppColors.cream
                  : AppColors.creamFaint),
          trackColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? AppColors.maroon
                  : AppColors.surface),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          labelStyle: const TextStyle(color: AppColors.creamMuted),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.maroonDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.maroonDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.maroon, width: 1.5),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.cream,
          unselectedItemColor: AppColors.creamFaint,
          selectedIconTheme: IconThemeData(color: AppColors.cream),
          unselectedIconTheme: IconThemeData(color: AppColors.creamFaint),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(color: AppColors.cream, fontWeight: FontWeight.w600),
          headlineMedium: TextStyle(color: AppColors.cream, fontWeight: FontWeight.w500),
          titleLarge: TextStyle(color: AppColors.cream, fontWeight: FontWeight.w500),
          titleMedium: TextStyle(color: AppColors.cream),
          bodyLarge: TextStyle(color: AppColors.cream),
          bodyMedium: TextStyle(color: AppColors.creamMuted),
          bodySmall: TextStyle(color: AppColors.creamFaint),
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FocusSessionScreen(),
    const SoundscapeBuilderScreen(),
    const AnalyticsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.timer_outlined), activeIcon: Icon(Icons.timer), label: 'Focus'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note_outlined), activeIcon: Icon(Icons.music_note), label: 'Sounds'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}