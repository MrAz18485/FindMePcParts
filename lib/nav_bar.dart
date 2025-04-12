import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 2:
        Navigator.pushReplacementNamed(context, '/builder');
        break;
      case 0:
        Navigator.pushReplacementNamed(context, '/community');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/guides');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/sales');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/settings');
        break;        
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,  
       
      onTap: (index) => _onItemTapped(context, index),
      currentIndex: _getCurrentIndex(context),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Community'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Guides'),
        BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Builder'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Sales'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name;
    switch (route) {
      case '/builder':
        return 2;
      case '/community':
        return 0;
      case '/guides':
        return 1;
      case '/sales':
        return 3;
      case '/settings':
        return 4;
      default:
        return 2;
    }
  }
}