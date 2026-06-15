import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSubscription;
  static const List<String> scopes = ['email', 'profile', 'openid'];
  Future<void> initGoogle() async {
    print("initGoogle called");
    await _googleSignIn.initialize(
      // clientId:
      //     '894617253593-h42g2i51hmnjsc2u7nq6m63j5umajr1a.apps.googleusercontent.com',
      serverClientId:
          '894617253593-h42g2i51hmnjsc2u7nq6m63j5umajr1a.apps.googleusercontent.com',
    );
    // _authSubscription = _googleSignIn.authenticationEvents.listen(
    //   _handleAuthEvent,
    //   onError: (error) => print('Google Auth Error: $error'),
    // );

    // محاولة دخول صامتة إذا كان المستخدم مسجل مسبقاً
    // await _googleSignIn.attemptLightweightAuthentication();
  }

  Future<void> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate(
        scopeHint: scopes,
      );
      if (googleUser == null) {
        print('Google Sign In cancelled by user');
        return;
      }

      print('Google Sign In Success for: ${googleUser.email}');
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      // final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        print('No ID Token');
        return;
      }
      var auth = await googleUser.authorizationClient.authorizationForScopes(
        scopes,
      );
      auth ??= await googleUser.authorizationClient.authorizeScopes(scopes);
      final accessToken = auth.accessToken;

      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      print('Signed in successfully!');
      // } else {
      //   // fallback للمنصات الأخرى
      //   await _googleSignIn.signIn();
      // } برجع لاحقا اذا بدي ادعم الويب
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  // Future<void> _handleAuthEvent(GoogleSignInAuthenticationEvent event) async {
  //   print('EVENT ARRIVED');
  //   switch (event) {
  //     case GoogleSignInAuthenticationEventSignIn():
  //       print('Google Sign In Event');
  //       final user = event.user;
  //       print(user.email);
  //       // var auth = await user.authorizationClient.authorizationForScopes(
  //       //   scopes,
  //       // );
  //       // auth ??= await user.authorizationClient.authorizeScopes(scopes);
  //       // final idToken = user.authentication.idToken;
  //       // final accessToken = auth.accessToken;

  //       final googleAuth = await user.authentication;
  //       final idToken = googleAuth.idToken;
  //       // final accessToken = googleAuth.accessToken;

  //       if (idToken == null) {
  //         print('No ID Token');
  //         return;
  //       }
  //       var auth = await user.authorizationClient.authorizationForScopes(
  //         scopes,
  //       );
  //       auth ??= await user.authorizationClient.authorizeScopes(scopes);
  //       final accessToken = auth.accessToken;

  //       await _supabase.auth.signInWithIdToken(
  //         provider: OAuthProvider.google,
  //         idToken: idToken,
  //         accessToken: accessToken,
  //       );
  //       print('Signed in successfully!');
  //       break;

  //     case GoogleSignInAuthenticationEventSignOut():
  //       break;
  //   }
  // }

  Future<void> signUp(String email, String password) async {
    try {
      await _supabase.auth.signUp(email: email, password: password);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final result = await _supabase
        .from('profiles')
        .select()
        .eq('email', email)
        .maybeSingle();

    if (result == null) {
      throw 'No account found with this email';
    }
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    await _googleSignIn.signOut();
  }

  void dispose() {
    _authSubscription?.cancel();
  }
}
