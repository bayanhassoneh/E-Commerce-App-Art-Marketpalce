import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:art_marketplace/widgets/BottomNavigationBar.dart';
import 'package:art_marketplace/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:art_marketplace/widgets/cart_card.dart';

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

      body: Column(
        children: [
          Expanded(
            //بتععطي المساحه المتبقيه
            child: cartProvider.cartItems.isEmpty
                ? const Center(
                    child: Text(
                      'cart is empty.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(174, 255, 109, 64),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,

                    //بخلي ال listview تاخد طول محتواها مش اكبر مساحه ممكنه
                    //  physics: NeverScrollableScrollPhysics(),
                    //بتمنع لسكرول لمنع التضارب
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final reversedIndex =
                          cartProvider.cartItems.length - 1 - index;
                      return CartCard(
                        post: cartProvider.cartItems[reversedIndex],
                      );
                    },
                  ),
          ),

          // TextButton(
          //  onPressed: ,

          // child: Text('checkout')),
          Container(
            height: 70,
            width: double.infinity,
            color: const Color.fromARGB(255, 226, 226, 216),
            alignment: Alignment.center,
            child: Text(
              'Total price: ${cartProvider.totalPrice}',
              style: TextStyle(
                fontSize: 20,
                color: const Color.fromARGB(255, 255, 98, 7),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MainBottomNavigationBar(currentIndex: 1),
    );
  }
}
