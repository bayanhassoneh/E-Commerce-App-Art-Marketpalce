import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:art_marketplace/widgets/BottomNavigationBar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44.0), // الارتفاع القياسي لآيفون
        child: CupertinoNavigationBar(
          // transitionBetweenRoutes: false,
          // heroTag: 'profileNavBar',
          middle: Text(
            'cart',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: const Color.fromARGB(115, 5, 5, 5),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [],
          ),
        ),
      ),
      bottomNavigationBar: MainBottomNavigationBar(currentIndex: 2),
    );
  }
}
