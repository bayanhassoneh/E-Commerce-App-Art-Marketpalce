import 'package:art_marketplace/models/app_user.dart';
import 'package:flutter/material.dart';

class userSearchCard extends StatelessWidget {
  final AppUser appUser;
  const userSearchCard({super.key, required this.appUser});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/profil', arguments: appUser);
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  appUser.profilePicture,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 4),
              Text(
                appUser.username,
                maxLines: 1,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
