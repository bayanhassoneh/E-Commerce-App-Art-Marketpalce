import 'package:art_marketplace/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:art_marketplace/models/post.dart';
import 'package:provider/provider.dart';

class CartCard extends StatelessWidget {
  final Post post;
  const CartCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/Product', arguments: post);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        //لقص اللي بطلع عن زوايا الريديوس
        elevation: 0,
        //بروز الكارد عن السطح
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),

        //horizontal: 12,جوانب
        //verticalفوق وتحت
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Image.network(
                  post.imageUrl,
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      post.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "\$${post.price}",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<CartProvider>().removeFromCart(post);
                },
                child: Icon(Icons.cancel, color: Colors.redAccent, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
