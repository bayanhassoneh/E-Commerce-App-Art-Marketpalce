import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:art_marketplace/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:art_marketplace/providers/post_provider.dart';
import 'package:art_marketplace/screens/create_post_screen.dart';
import 'package:art_marketplace/widgets/app_drawer.dart';
import 'package:art_marketplace/providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  final String profileUserId;
  const ProfileScreen({
    super.key,
    required this.title,
    required this.profileUserId,
  });

  final String title;

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
          leading: Text(provider.profile?.username ?? ''),
        ),
      ),

      drawer: isMyProfile ? const AppDrawer() : null,
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      profile != null && profile.profilePicture.isNotEmpty
                      ? NetworkImage(profile.profilePicture)
                      : const AssetImage('assets/default_avatar.png')
                            as ImageProvider,
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Text(
                      "${provider.followersCount}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('followers'),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Text(
                      "${provider.followingCount}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('following'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(profile?.bio ?? ''),
            const SizedBox(height: 15),
            isMyProfile
                ? ElevatedButton(
                    onPressed: () {},
                    //back
                    child: const Text(" edite profile"),
                  )
                : ElevatedButton(
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
                                      child: Text("Unfollow"),
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
                        ? const Text("following")
                        : const Text("follow"),
                  ),
            SizedBox(height: 10),
            const Divider(height: 40, thickness: 1),
            SizedBox(height: 10),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 1),
              ),
              onPressed: () async {
                final provider = context.read<PostProvider>();
                await provider.pickImage();
                if (provider.selectedImage != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreatePostScreen()),
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
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(post.imageUrl, fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
