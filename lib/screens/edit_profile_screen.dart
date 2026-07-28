import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:art_marketplace/widgets/seconed_text_field.dart';
import 'package:art_marketplace/models/app_user.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _socialLinkeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  @override
  void dispose() {
    _bioController.dispose();
    _socialLinkeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ModalRoute.of(context)!.settings.arguments as AppUser;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44.0), // الارتفاع القياسي لآيفون
        child: CupertinoNavigationBar(
          middle: Text(
            "Edit profile",
            style: TextStyle(color: CupertinoColors.inactiveGray, fontSize: 20),
            // textAlign: TextAlign.center,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(height: 20),
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: <Color>[
                          Color.fromARGB(255, 102, 108, 211), // الأزرق القوي
                          Color.fromARGB(255, 137, 132, 143), // البنفسجي
                        ],
                        begin: Alignment.centerLeft, // بيبدأ الأزرق من اليسار
                        end:
                            Alignment.centerRight, // بينتهي البنفسجي على اليمين
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      );
                      // السطر اللي فوق بضمن إنه الـ 0 و 0 هي أول النص، والجرادينت بيمشي على قد عرض النص بالظبط
                    },
                    child: const Text(
                      'updat your info',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors
                            .white, // ضروري يكون أبيض عشان الشيدر يطبع الألوان عليه صح
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: profile.profilePicture.isNotEmpty
                      ? NetworkImage(profile.profilePicture)
                      : const AssetImage('assets/images/default_avatar.png'),
                ),
                Text(
                  'Edit your  picture ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),

                const Divider(height: 40, thickness: 1),

                Text(
                  'username',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 10),
                SeconedTextField(
                  hint: 'username',
                  controller: _usernameController,
                ),

                const Divider(height: 40, thickness: 1),

                Text(
                  'bio',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 10),
                SeconedTextField(hint: 'bio', controller: _bioController),
                // SizedBox(height: 10),
                const Divider(height: 40, thickness: 1),

                Text(
                  'location',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 10),
                SeconedTextField(
                  hint: 'location',
                  controller: _locationController,
                ),
                const Divider(height: 40, thickness: 1),

                Text(
                  'links',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 10),
                SeconedTextField(
                  hint: 'add link for conatct',
                  controller: _socialLinkeController,
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
