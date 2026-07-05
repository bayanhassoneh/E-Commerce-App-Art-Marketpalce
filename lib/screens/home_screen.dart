import 'package:flutter/material.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'cart_screen.dart';
import 'package:art_marketplace/screens/profile_screen.dart';
import 'package:art_marketplace/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44.0), // الارتفاع القياسي لآيفون
        child: CupertinoNavigationBar(
          middle: Text(
            'PayPaint',
            style: TextStyle(
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: <Color>[
                    const Color.fromARGB(255, 0, 0, 255),
                    const Color.fromARGB(255, 202, 167, 240),
                  ],
                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
            // textAlign: TextAlign.center,
          ),
          automaticallyImplyLeading: false,
        ),
      ),

      body: IndexedStack(
        index: _currentIndex,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ///back sooooooooooooooooooooooooooooooon
              ],
            ),
          ),
          const CartScreen(title: 'cart'),

          // const MessagesScreen(),
          ProfileScreen(
            title: 'profile',
            profileUserId: context.read<AuthProvider>().currentUserId ?? "",
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
