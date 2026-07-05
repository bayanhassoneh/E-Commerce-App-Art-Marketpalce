import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.title});

  final String title;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    // appBar: PreferredSize(
    //   preferredSize: const Size.fromHeight(44.0), // الارتفاع القياسي لآيفون
    //   child: CupertinoNavigationBar(
    //     middle: Text(
    //       'PayPaint',)
    // ),),
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(),
    );
  }
}
