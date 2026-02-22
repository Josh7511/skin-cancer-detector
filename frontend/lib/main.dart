import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/history_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/app_shell.dart';
import 'theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the persisted theme before building the widget tree
  // to prevent a visible theme flash on startup.
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(SkinCancerDetectorApp(themeProvider: themeProvider));
}

/// Root widget for the Skin Cancer Detector application.
///
/// Sets up [Provider] instances for theme, authentication, and history
/// state management, and applies the light/dark theme based on user
/// preference.
class SkinCancerDetectorApp extends StatelessWidget {
  /// Creates the root [SkinCancerDetectorApp] widget.
  const SkinCancerDetectorApp({super.key, required this.themeProvider});

  /// The pre-loaded [ThemeProvider] instance.
  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..signIn(),
        ),
        ChangeNotifierProvider(
          create: (_) => HistoryProvider()..loadHistory(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Skin Cancer Detector',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AppShell(),
          );
        },
      ),
    );
  }
}
