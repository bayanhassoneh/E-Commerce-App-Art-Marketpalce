import 'package:flutter/material.dart';
import 'package:art_marketplace/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    await _authService.initGoogle();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }

  Future<void> googleSignIn() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.googleSignIn();
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signIn(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.sendPasswordResetEmail(email);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePassword(String newPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.updatePassword(newPassword);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signUp(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<bool> needsUsername() async {
  //   return await _authService.needsUsername();
  // }
  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }

  void disposeService() {
    _authService.dispose();
  }
}
