import 'package:flutter/material.dart';
import 'package:art_marketplace/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:art_marketplace/providers/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),

          ListTile(
            leading: Switch(
              //ممكن اذا بدي الكبسة تكون بعرض الشاشه استخدم switchListTile
              activeThumbColor: Colors.blueAccent,
              inactiveThumbColor: Colors.blueGrey,
              activeTrackColor: Colors.blueGrey,
              inactiveTrackColor: Colors.grey,
              value: context.watch<ThemeProvider>().themeMode == ThemeMode.dark,
              onChanged: (value) {
                context.read<ThemeProvider>().toggleTheme(value);
              },
            ),
            title: Text('application mood'),
            // onTap: () {}, لانه نفس وظيفة الاون شينج
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              showDialog(
                context: context,
                //كونتيكست الويدجيت اللي اتسدعت الدايالوج
                builder: (context) {
                  //Dialog's context
                  return AlertDialog(
                    title: Text("logout"),
                    content: Text("Do you want to logout?"),

                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          //الكونتكست اللي داخل البيلدر اي تاع الداايالوج نفسها
                        },
                        child: Text("Cancel"),
                      ),

                      TextButton(
                        onPressed: () async {
                          await context.read<AuthProvider>().signOut();
                          if (context.mounted) {
                            Navigator.pop(context);
                            //بنتأكد إن الصفحة/الـ Widget لسه موجودة، وبس إذا موجودة بنعمل pop.
                          }
                        },
                        child: Text("logout"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
