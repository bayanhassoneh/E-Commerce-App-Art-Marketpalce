import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:art_marketplace/providers/auth_provider.dart';
import 'package:provider/provider.dart';
class ProfileScreen extends StatefulWidget {
  final String profileUserId;
  const ProfileScreen({super.key, required this.title,required this.profileUserId});

  final String title;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //final bool isMyProfile = currentUserId == profileUserId;
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final String? currentUserId = authProvider.currentUserId;
  final bool isMyProfile = currentUserId == widget.profileUserId;

    return Scaffold(
       appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44.0), // الارتفاع القياسي لآيفون
        child: CupertinoNavigationBar(
          leading : Text(
            'profile',),
            ),),
      body: Column(children: [

      ],),
    );
  }
}
