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
              value: context.watch<ThemeProvider>().themeMode == ThemeMode.dark,
              onChanged: (value) {
                context.read<ThemeProvider>().toggleTheme(value);
              },
            ),
            title: Text('application mood'),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("logout"),
                    content: Text("Do you want to logout?"),

                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),

                      TextButton(
                        onPressed: () async {
                          await context.read<AuthProvider>().signOut();
                          if (context.mounted) {
                            Navigator.pop(context);
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
