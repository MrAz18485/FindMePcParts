import 'package:flutter/material.dart';
import '../util/app_text_styles.dart';
import '../routes/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 4;

  final List<Widget> _screens = [
    const PlaceholderWidget(title: 'Community'),
    const PlaceholderWidget(title: 'Guides'),
    const PlaceholderWidget(title: 'Builder'),
    const PlaceholderWidget(title: 'Sales'),
    const SettingsPageWithNav(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
    );
  }
}

class SettingsPageWithNav extends StatelessWidget {
  const SettingsPageWithNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SettingsScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        backgroundColor: Theme.of(context).colorScheme.surface,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          // Optional: Implement navigation
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Guides'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Builder'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Sales'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String title;

  const PlaceholderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: AppTextStyles.headline),
    );
  }
}
