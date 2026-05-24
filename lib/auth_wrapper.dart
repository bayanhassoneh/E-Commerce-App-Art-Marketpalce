import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  User? _user;
  bool isLoding = true;
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() {
    final Session = Supabase.instance.client.auth.currentSession;
    setState(() {
      _user = Session?.user;
      isLoding = false;
    });
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        setState(() {
          _user = data.session?.user;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoding) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_user != null) {
      return const HomePage(title: 'home');
    } else {
      return const SignInScreen();
    }
  }
}
