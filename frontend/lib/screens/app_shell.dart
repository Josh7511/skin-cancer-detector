import 'package:flutter/material.dart';

import '../widgets/theme_toggle.dart';
import 'about_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'upload_screen.dart';

/// The root shell of the application, providing bottom navigation
/// between the four main screens.
///
/// Uses an [IndexedStack] so that each tab preserves its state when
/// the user switches between them.
///
/// Exposes a static [switchTab] method so child screens can
/// programmatically navigate to a different tab (e.g., the Home
/// screen's "Start Scan" button switching to the Upload tab).
class AppShell extends StatefulWidget {
  /// Creates an [AppShell] widget.
  const AppShell({super.key});

  /// Tab indices for programmatic navigation.
  static const int homeTab = 0;
  static const int scanTab = 1;
  static const int historyTab = 2;
  static const int aboutTab = 3;

  /// Switches to the given [tabIndex] from anywhere in the widget tree.
  ///
  /// Requires a [BuildContext] that is a descendant of [AppShell].
  static void switchTab(BuildContext context, int tabIndex) {
    final state = context.findAncestorStateOfType<_AppShellState>();
    state?._setTab(tabIndex);
  }

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    UploadScreen(),
    HistoryScreen(),
    AboutScreen(),
  ];

  static const List<String> _titles = [
    'Home',
    'Scan',
    'History',
    'About',
  ];

  void _setTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(_titles[_currentIndex]),
        actions: const [
          ThemeToggle(),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _setTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner_outlined),
            activeIcon: Icon(Icons.document_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            activeIcon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
