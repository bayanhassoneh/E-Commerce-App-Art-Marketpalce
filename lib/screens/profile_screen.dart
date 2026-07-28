import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:art_marketplace/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:art_marketplace/providers/post_provider.dart';
import 'package:art_marketplace/screens/create_post_screen.dart';
import 'package:art_marketplace/widgets/app_drawer.dart';
import 'package:art_marketplace/providers/profile_provider.dart';
import 'package:art_marketplace/widgets/BottomNavigationBar.dart';

class ProfileScreen extends StatefulWidget {
  final String profileUserId;

  const ProfileScreen({super.key, required this.profileUserId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProfileProvider>().refresh(widget.profileUserId);
    });
  }

  final supabase = Supabase.instance.client;
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>(); //?
    final provider = context.watch<ProfileProvider>();
    final String? currentUserId = authProvider.currentUserId;
    final bool isMyProfile = currentUserId == widget.profileUserId;
    final profile = provider.profile;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44.0), // الارتفاع القياسي لآيفون
        child: CupertinoNavigationBar(
          //transitionBetweenRoutes: false,
          // heroTag: 'profileNavBar',
          middle: Text(
            provider.profile?.username ?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: const Color.fromARGB(115, 5, 5, 5),
            ),
          ),
        ),
      ),

      drawer: isMyProfile ? const AppDrawer() : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        profile != null && profile.profilePicture.isNotEmpty
                        ? NetworkImage(profile.profilePicture)
                        : const AssetImage('assets/images/default_avatar.png'),
                  ),
                  SizedBox(width: 30),
                  Column(
                    children: [
                      Text(
                        "${provider.followersCount}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('followers', style: TextStyle(fontSize: 17)),
                    ],
                  ),
                  SizedBox(width: 40),
                  Column(
                    children: [
                      Text(
                        "${provider.followingCount}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('following', style: TextStyle(fontSize: 17)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(profile?.bio ?? ''),
              Text(profile?.socialLink ?? ''),
              const SizedBox(height: 15),
              isMyProfile
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/EditProfile',
                          arguments: profile,
                        );
                      },
                      //back
                      child: const Text(
                        " edite profile",
                        style: TextStyle(
                          color: Color.fromARGB(255, 31, 31, 31),
                        ),
                      ),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: provider.isFollowing
                          ? () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Unfollow?"),
                                    content: Text(
                                      "Do you want to remove this follow?",
                                    ),

                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel"),
                                      ),

                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<ProfileProvider>()
                                              .unfollow(profile!.id);

                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Unfollow",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              31,
                                              31,
                                              31,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          : () {
                              context.read<ProfileProvider>().toggleFollow(
                                provider.profile!.id,
                              );
                            },
                      child: provider.isFollowing
                          ? const Text(
                              "following",
                              style: TextStyle(
                                color: Color.fromARGB(255, 31, 31, 31),
                              ),
                            )
                          : const Text(
                              "follow",
                              style: TextStyle(
                                color: Color.fromARGB(255, 96, 58, 234),
                              ),
                            ),
                    ),
              SizedBox(height: 5),
              const Divider(height: 40, thickness: 1),
              SizedBox(height: 5),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color.fromARGB(255, 156, 153, 173),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () async {
                  final provider = context.read<PostProvider>();
                  await provider.pickImage();
                  if (provider.selectedImage != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreatePostScreen(),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Icon(Icons.add, size: 30, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      "Add post",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),

              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // لمنع تعارض السكرول
                itemCount: provider.artworks.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, //عدد الشبكه
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final post = provider.artworks[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/product', arguments: post);
                    },
                    child: ClipRRect(
                      child: Image.network(post.imageUrl, fit: BoxFit.cover),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: MainBottomNavigationBar(currentIndex: 2),
    );
  }
}
