import 'dart:async';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required DateTime birthday,
    required String location,
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw const SocketException(
        "لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة.",
      );
    }

    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      print("User Created: ${response.user}");
      print("Session: ${response.session}");

      if (response.user == null) {
        throw Exception("User creation failed.");
      }

      final String? userId = response.user?.id;
      print("User ID = $userId");
      if (userId != null) {
        await _supabase
            .from('profiles')
            .update({
              'user_name': username.trim(),
              'birthday': birthday.toIso8601String(),
              'location': location,
            })
            .eq('id', userId);

        print("User profile updated successfully.");
      }
    } on AuthException catch (error) {
      if (error.message.contains('already exists') ||
          error.statusCode == '422') {
        throw Exception(
          "This account is already registered. Please try signing in with Google.",
        );
      } else {
        throw Exception(error.message);
      }
    } on SocketException catch (_) {
      throw const SocketException(
        " No internet connection. Please check your network.",
      );
    } catch (error) {
      // 6. أي خطأ آخر غير متوقع (مثل أخطاء الداتابيز)
      print("General Error: $error");
      throw Exception("An unexpected error occurred: $error");
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
