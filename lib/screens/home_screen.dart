import 'package:flutter/material.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'cart_screen.dart';
import 'package:art_marketplace/screens/profile_screen.dart';
import 'package:art_marketplace/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:art_marketplace/providers/post_provider.dart';
import 'package:art_marketplace/widgets/post_card.dart';
import 'package:art_marketplace/widgets/BottomNavigationBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().fetchFeedPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44.0), // الارتفاع القياسي لآيفون
        child: CupertinoNavigationBar(
          middle: Align(
            alignment: AlignmentDirectional.topCenter,
            child: ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: <Color>[
                    Color.fromARGB(255, 2, 2, 255), // الأزرق القوي
                    Color.fromARGB(255, 179, 132, 233), // البنفسجي
                  ],
                  begin: Alignment.centerLeft, // بيبدأ الأزرق من اليسار
                  end: Alignment.centerRight, // بينتهي البنفسجي على اليمين
                ).createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                );
                // السطر اللي فوق بضمن إنه الـ 0 و 0 هي أول النص، والجرادينت بيمشي على قد عرض النص بالظبط
              },
              child: const Text(
                'PayPaint',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors
                      .white, // ضروري يكون أبيض عشان الشيدر يطبع الألوان عليه صح
                ),
              ),
            ),
          ),

          automaticallyImplyLeading: false,
        ),
      ),

      body: Consumer<PostProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.posts.isEmpty) {
            return const Center(child: Text("No posts yet"));
          }

          return ListView.builder(
            itemCount: provider.posts.length,
            itemBuilder: (context, index) {
              final artwork = provider.posts[index];

              return PostCard(post: artwork);
            },
          );
        },
      ),

      bottomNavigationBar: MainBottomNavigationBar(currentIndex: 0),
    );
  }
}
