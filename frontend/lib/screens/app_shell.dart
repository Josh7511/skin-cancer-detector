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
class AppShell extends StatefulWidget {
  /// Creates an [AppShell] widget.
  const AppShell({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        onTap: (index) => setState(() => _currentIndex = index),
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
