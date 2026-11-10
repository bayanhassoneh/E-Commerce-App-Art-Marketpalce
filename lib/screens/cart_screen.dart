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
  void initStat() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().fetchCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44.0),
        child: CupertinoNavigationBar(
          middle: Text(
            'cart',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                      return CartCard(post: cartProvider.cartItems[index]);
                    },
                  ),
          ),

          // TextButton(
          //  onPressed: ,

          // child: Text('checkout')),
          Container(
            height: 80,
            width: double.infinity,

            // color: Colors.white,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total price:\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 196, 93, 24),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // SizedBox(width: 70),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 10,
                      ),
                      backgroundColor: Color.fromARGB(234, 88, 46, 241),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Text(
                      'Checkout',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    onPressed: () {
                      print('Button Pressed!');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MainBottomNavigationBar(currentIndex: 1),
    );
  }
}
