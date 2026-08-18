import 'package:flutter/material.dart';
import 'package:art_marketplace/models/post.dart';
import 'package:intl/intl.dart';
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
     final date = DateTime.parse(post.createdAt);
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
                  Text("Added",style: TextStyle(color: Colors.green),),
           Icon( 
          Icons.check, color: Colors.green,size: 14, ), 
             ],)
                : Text('Add to cart', style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 39, 39, 39),
                        ),),
              ),
              SizedBox(height: 10),
              Text('by ${post.profile?.username} ', style: TextStyle(
                          fontSize: 17,
                          color: Color.fromARGB(255, 39, 39, 39),
                        ),),
              SizedBox(height: 10),

              Row(
                children: [
                  Text(
                    '${post.price}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  SizedBox(width: 7),
                  Text(post.title,  style: TextStyle(
                      fontSize: 16,fontWeight: FontWeight.bold),),
                ],
              ),
              SizedBox(height: 10),
              Text(post.description),
              SizedBox(height: 10),
              Text(DateFormat('dd MMM yyyy, hh:mm a').format(date)),
            ],
          ),
        ),
      ),
    );
  }
}
