import 'package:art_marketplace/screens/cart_screen.dart';
import 'package:art_marketplace/screens/product_screen.dart';
import 'package:art_marketplace/screens/profile_screen.dart';
import 'package:art_marketplace/screens/forgot_password_screen.dart';
import 'package:art_marketplace/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
//import 'package:flutter/foundation.dart';
////for DebugDefaultTargetPlatformOverride,could use for compute function(processing heavy stuff)
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_wrapper.dart';
import 'InternetCheckerWrapper.dart';
import 'package:art_marketplace/screens/sign_in_screen.dart';
import 'package:art_marketplace/screens/home_screen.dart';
import 'package:art_marketplace/screens/sign_up_screen.dart';
import 'package:art_marketplace/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:art_marketplace/screens/Completeprofilescreen.dart';
import 'core/navigation.dart';
import 'package:art_marketplace/providers/theme_provider.dart';

// void main() {
//   debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
//   runApp(MyApp());
// }
//i use it to check ios emulater
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //it accure when runapp,but i used await so i should ensure first
  try {
    await Supabase.initialize(
      url: 'https://pjvkgmqbztlgzzacesob.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBqdmtnbXFienRsZ3p6YWNlc29iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUzNDI2MjAsImV4cCI6MjA5MDkxODYyMH0.SLMkP59YXQZYawnyTiyRkwyMPWSROSNisKc_zWDqMsw',
    );
  } catch (e) {
    print("Supabase Initialization Error: $e");
    return;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 246, 255, 175),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 173, 169, 229),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeProvider.themeMode,
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/home': (context) => const HomePage(title: 'home'),
        '/SignIn': (context) => const SignInScreen(),
        '/SignUp': (context) => const SignUpScreen(),
        '/Wrappr': (context) => const AuthWrapper(),
        '/Profile': (context) => ProfileScreen(
          title: "profile",
          profileUserId: context.read<AuthProvider>().currentUserId ?? "",
        ),
        '/Cart': (context) => const CartScreen(title: 'cart'),
        '/Product': (context) => const ProductScreen(title: 'product'),
        '/forgetPassword': (context) =>
            const forgotPasswordScreen(title: "forgot password"),
        '/setpassword': (context) =>
            const SetPasswordScreen(title: "set password"),
        '/CompleteProfile': (context) => const CompleteProfileScreen(),
      },

      debugShowCheckedModeBanner: false,
      title: 'PayPaint ',
      builder: (context, child) {
        return InternetCheckerWrapper(child: child!);
      },
    );
  }
}
