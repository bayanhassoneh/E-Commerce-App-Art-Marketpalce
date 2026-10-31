import 'package:flutter/cupertino.dart';
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
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 96, 33, 243),
            ),
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(20),
            child: const Text(
              'menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),

          ListTile(
            leading: Switch(
              //ممكن اذا بدي الكبسة تكون بعرض الشاشه استخدم switchListTile
              activeThumbColor: const Color.fromARGB(255, 68, 77, 255),
              inactiveThumbColor: const Color.fromARGB(255, 99, 115, 122),
              activeTrackColor: const Color.fromARGB(255, 162, 197, 214),
              inactiveTrackColor: const Color.fromARGB(255, 191, 190, 190),
              value: context.watch<ThemeProvider>().themeMode == ThemeMode.dark,
              onChanged: (value) {
                context.read<ThemeProvider>().toggleTheme(value);
              },
            ),
            title: const Text('Dark mood', style: TextStyle(fontSize: 20)),
            // onTap: () {}, لانه نفس وظيفة الاون شينج
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout", style: TextStyle(fontSize: 20)),
            onTap: () {
              showDialog(
                context: context,
                //كونتيكست الويدجيت اللي اتسدعت الدايالوج
                builder: (context) {
                  //Dialog's context
                  return AlertDialog(
                    alignment: Alignment.center,
                    actionsAlignment: MainAxisAlignment.center,
                    title: const Text("logout", textAlign: TextAlign.center),
                    content: const Text(
                      "Do you want to logout?",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),

                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          //الكونتكست اللي داخل البيلدر اي تاع الداايالوج نفسها
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Color.fromARGB(255, 48, 51, 227),
                            fontSize: 17,
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(
                                color: Colors.grey,
                              ),
                            ),
                          );
                          await context.read<AuthProvider>().signOut();
                          if (context.mounted) {
                            Navigator.pop(context);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/',
                              (Route<dynamic> rout) => false,
                            );
                          }
                        },
                        child: const Text(
                          "logout",
                          style: TextStyle(
                            color: Color.fromARGB(255, 48, 51, 227),
                            fontSize: 17,
                          ),
                        ),
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
