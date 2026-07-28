import 'package:flutter/material.dart';
import 'package:art_marketplace/models/post.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(post.imageUrl, height: 180, fit: BoxFit.cover),
              SizedBox(height: 10),
              IconButton(
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
                icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    added = !added;
                  });
                },
                child: added? Row(
                  children: [
                  Text("Added"),
           Icon( 
          Icons.check, color: Colors.green ), 
             ],)
                : Text('Add to cart'),
              ),
              SizedBox(height: 10),
              Text('by ${post.profile?.username} '),
              SizedBox(height: 10),

              Row(
                children: [
                  Text(
                    '${post.price}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  SizedBox(width: 7),
                  Text(post.title),
                ],
              ),
              SizedBox(height: 10),
              Text(post.description),
              SizedBox(height: 10),
              Text('${post.createdAt}'),
            ],
          ),
        ),
      ),
    );
  }
}
