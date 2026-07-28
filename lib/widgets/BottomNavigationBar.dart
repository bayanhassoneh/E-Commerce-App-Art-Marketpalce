import 'package:flutter/material.dart';
import 'package:art_marketplace/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class MainBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const MainBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Color.fromARGB(255, 49, 49, 192),
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;

          case 1:
            Navigator.pushReplacementNamed(context, '/Cart');
            break;

          case 2:
            Navigator.pushReplacementNamed(
              context,
              '/Profile',
              arguments: context.read<AuthProvider>().currentUserId,
            );

            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
