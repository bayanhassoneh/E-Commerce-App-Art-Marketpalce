import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:art_marketplace/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:art_marketplace/models/app_user.dart';
import 'package:art_marketplace/models/artworks.dart';

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
  final supabase = Supabase.instance.client;

  Future<AppUser> _fetchUserProfile() async {
    final data = await supabase
        .from('profiles')
        .select()
        .eq('id', widget.profileUserId)
        .single();
    return AppUser.fromMap(data);
  }

  Future<List<Artwork>> _fetchUserArtworks() async {
    final List<dynamic> data = await supabase
        .from('artworks')
        .select()
        .eq('artist_id', widget.profileUserId);
    return data.map((item) => Artwork.fromMap(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final String? currentUserId = authProvider.currentUserId;
    final bool isMyProfile = currentUserId == widget.profileUserId;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44.0), // الارتفاع القياسي لآيفون
        child: CupertinoNavigationBar(leading: Text('profile')),
      ),

      body: FutureBuilder<AppUser>(
        future: _fetchUserProfile(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('an error occurred: ${snapshot.error}'));
          }
          final user = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: user.profilePicture.isNotEmpty
                          ? NetworkImage(user.profilePicture)
                          : const AssetImage('assets/default_avatar.png')
                                as ImageProvider,
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(user.followers.toString()),
                        Text('followers'),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(user.following.toString()),
                        Text('following'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(user.bio),
                const SizedBox(height: 15),
                isMyProfile
                    ? ElevatedButton(
                        onPressed: () {},
                        child: const Text(" edite profile"),
                      )
                    : ElevatedButton(
                        onPressed: () {},
                        child: const Text("follow"),
                      ),
                SizedBox(height: 10),
                const Divider(height: 40, thickness: 1),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
