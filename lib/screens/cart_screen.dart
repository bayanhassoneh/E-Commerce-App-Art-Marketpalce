import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:art_marketplace/widgets/BottomNavigationBar.dart';
import 'package:art_marketplace/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:art_marketplace/widgets/post_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44.0),
        child: CupertinoNavigationBar(
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

      body: ListView.builder(
        itemCount: cartProvider.cartItems.length,
        itemBuilder: (context, index) {
          return PostCard(post: cartProvider.cartItems[index]);
        },
      ),
      bottomNavigationBar: MainBottomNavigationBar(currentIndex: 2),
    );
  }
}
