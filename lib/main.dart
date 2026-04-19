import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/update_service.dart';

import 'screens/dashboard_screen.dart';
import 'screens/track_screen.dart';
import 'screens/history_screen.dart';
import 'screens/timer_screen.dart';
import 'screens/library_screen.dart';
import 'screens/onboarding_screen.dart';

import 'state/workout_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UpdateService.init();
  UpdateService.checkForUpdatesBg();
  await WorkoutState.instance.loadState();
  runApp(const TrainovaApp());
}

class TrainovaApp extends StatelessWidget {
  const TrainovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: WorkoutState.instance,
      builder: (context, _) {
        final variant = WorkoutState.instance.themeVariant;

        // Base Dark Theme
        final darkThemeData = ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
          primaryColor: const Color(0xFF39FF14),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF39FF14),
            secondary: Color(0xFF00E5FF),
            surface: Color(0xFF1E1E1E),
          ),
          textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF1E1E1E),
            selectedItemColor: Color(0xFF39FF14),
            unselectedItemColor: Colors.white54,
            type: BottomNavigationBarType.fixed,
            elevation: 8,
          ),
        );

        // AMOLED Black Theme
        final amoledThemeData = ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF000000), // Pure Black Main Scaffold
          primaryColor: const Color(0xFF39FF14),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF39FF14),
            secondary: Color(0xFF00E5FF),
            surface: Color(0xFF0A0A0A), // Deepest Gray Surface
          ),
          textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF0A0A0A),
            selectedItemColor: Color(0xFF39FF14),
            unselectedItemColor: Colors.white54,
            type: BottomNavigationBarType.fixed,
            elevation: 8,
          ),
        );

        // Light Theme
        final lightThemeData = ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFF0F0F0), // Clean light grey
          primaryColor: const Color(0xFF228B22), // Forest Green for readability on light
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF228B22),
            secondary: Color(0xFF008B8B),
            surface: Color(0xFFFFFFFF), // Pure white surfaces
          ),
          textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFFFFFFFF),
            selectedItemColor: Color(0xFF228B22),
            unselectedItemColor: Colors.black54,
            type: BottomNavigationBarType.fixed,
            elevation: 8,
          ),
        );

        ThemeMode mode = ThemeMode.system;
        ThemeData selectedDarkTheme = darkThemeData;

        if (variant == 'Light') {
          mode = ThemeMode.light;
        } else if (variant == 'Dark') {
          mode = ThemeMode.dark;
          selectedDarkTheme = darkThemeData;
        } else if (variant == 'AMOLED Black') {
          mode = ThemeMode.dark;
          selectedDarkTheme = amoledThemeData;
        }

        return MaterialApp(
          title: 'Trainova',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: lightThemeData,
          darkTheme: selectedDarkTheme,
          home: WorkoutState.instance.isFirstLaunch
              ? const OnboardingScreen()
              : const MainNavigation(),
        );
      },
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

  void _navigate(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(onNavigate: _navigate),
      const TrackScreen(),
      const HistoryScreen(),
      const TimerScreen(),
      const LibraryScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 10,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_rounded),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_rounded),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list_rounded),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
