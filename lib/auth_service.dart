import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSubscription;
  static const List<String> scopes = ['email', 'profile', 'openid'];
  Future<void> initGoogle() async {
    await _googleSignIn.initialize(
      clientId:
          '894617253593-h42g2i51hmnjsc2u7nq6m63j5umajr1a.apps.googleusercontent.com',
      serverClientId:
          '894617253593-h42g2i51hmnjsc2u7nq6m63j5umajr1a.apps.googleusercontent.com',
    );
    _authSubscription = _googleSignIn.authenticationEvents.listen(
      _handleAuthEvent,
      onError: (error) => print('Google Auth Error: $error'),
    );

    // محاولة دخول صامتة إذا كان المستخدم مسجل مسبقاً
    await _googleSignIn.attemptLightweightAuthentication();
  }

  Future<void> signIn() async {
    try {
      await _googleSignIn.authenticate(scopeHint: scopes);
      // } else {
      //   // fallback للمنصات الأخرى
      //   await _googleSignIn.signIn();
      // } برجع لاحقا اذا بدي ادعم الويب
    } catch (e) {
      print('Sign in error: $e');
    }
  }

  Future<void> _handleAuthEvent(GoogleSignInAuthenticationEvent event) async {
    switch (event) {
      case GoogleSignInAuthenticationEventSignIn():
        final user = event.user;
        print(user.email);
        var auth = await user.authorizationClient.authorizationForScopes(
          scopes,
        );
        auth ??= await user.authorizationClient.authorizeScopes(scopes);
        final idToken = user.authentication.idToken;
        final accessToken = auth.accessToken;

        if (idToken == null) {
          print('No ID Token');
          return;
        }

        await _supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );

        print('Signed in successfully!');
        break;

      case GoogleSignInAuthenticationEventSignOut():
        print('User signed out');
        break;
    }
  }

  ////
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    await _googleSignIn.signOut();
  }

  void dispose() {
    _authSubscription?.cancel();
  }
}
