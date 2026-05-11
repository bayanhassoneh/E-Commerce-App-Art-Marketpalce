import 'package:art_marketplace/screens.dart/cart_screen.dart';
import 'package:art_marketplace/screens.dart/product_screen.dart';
import 'package:art_marketplace/screens.dart/profile_screen.dart';
import 'package:art_marketplace/screens.dart/set_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_wrapper.dart'; //لاحقا
import 'screens.dart/sign_in_screen.dart';
import 'screens.dart/home_screen.dart';
import 'screens.dart/sign_up_screen.dart';
//مبدئياااااااااااااااااا

// void main() {
//   debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
//   runApp(MyApp());
// }
void main() {
  // تأكدي إنك عملتي Initialize لسوبابيز هون
  // await Supabase.initialize(
  //   url: 'YOUR_SUPABASE_URL',
  //   anonKey: 'YOUR_ANON_KEY',
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(title: 'home'),

        ///there is a problem here!!!!!!!!!!!!!!!!!!!!!!!!!!
        '/SignIn': (context) => SignInScreen(),
        '/SignUp': (context) => SignUpScreen(),
        '/Wrappr': (context) => AuthWrapper(),
        '/Profile': (context) => ProfileScreen(
          title: "profile",
        ), //what this title that requiered?????????????????????????
        '/Cart': (context) => CartScreen(title: 'cart'),
        '/Product': (context) => ProductScreen(title: 'product'),
        '/SetPassword': (context) => SetPasswordScreen(title: "set password"),
      },

      debugShowCheckedModeBanner: false,
      title: 'PayPaint ',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),

      home:
          const SignInScreen(), ////////////compare seriously!>>>>>>>>>>>>>>>>>>>>>>>>>>>
    );
  }
}
