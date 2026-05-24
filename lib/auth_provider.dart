import 'package:flutter/material.dart';
import 'package:art_marketplace/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    await _authService.initGoogle();
  }

  Future<void> signIn() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signIn();
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }

  void disposeService() {
    _authService.dispose();
  }
}
