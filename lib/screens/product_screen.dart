import 'package:flutter/material.dart';
import 'package:art_marketplace/models/post.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:art_marketplace/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isLiked = false;
  bool added = false;

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as Post;
    final cartProvider = context.watch<CartProvider>();
    bool added = cartProvider.isIncart(post);
    final date = DateTime.parse(post.createdAt);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44.0),
        child: CupertinoNavigationBar(
          middle: Text(
            'post',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(post.imageUrl, fit: BoxFit.cover),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '\$${post.price}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  SizedBox(width: 140),
                  Align(
                    alignment: Alignment.center,
                    child: OutlinedButton(
                      onPressed: () {
                        added
                            ? cartProvider.removeFromCart(post)
                            : cartProvider.addToCart(post);
                      },
                      child: added
                          ? Row(
                              children: [
                                Text(
                                  "Added",
                                  style: TextStyle(color: Colors.green),
                                ),
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 14,
                                ),
                              ],
                            )
                          : Text(
                              'Add to cart',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 39, 39, 39),
                              ),
                            ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              Text(
                post.title,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),
              Text(post.description, style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),

              Text(
                'by ${post.profile?.username} ',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 39, 39, 39),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('dd MMM yyyy, hh:mm a').format(date),
                style: TextStyle(
                  color: const Color.fromARGB(255, 149, 150, 150),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
