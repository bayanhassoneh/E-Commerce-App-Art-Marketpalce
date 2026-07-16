import 'package:flutter/material.dart';
import 'package:art_marketplace/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _selectedMonth;
  int? _selectedDay;
  int? _selectedYear;
  String? _selectedLocation;
  bool _isLoading = false;
  String? get currentUserId => Supabase.instance.client.auth.currentUser?.id;
  String? get selectedMonth => _selectedMonth;
  int? get selectedDay => _selectedDay;
  int? get selectedYear => _selectedYear;
  String? get selectedLocation => _selectedLocation;
  bool get isLoading => _isLoading;

  final List<String> monthsList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

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
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);
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

  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_selectedMonth == null ||
          _selectedDay == null ||
          _selectedYear == null) {
        throw Exception("Please select your complete birthday.");
      }
      if (_selectedLocation == null) {
        throw Exception("Please select your location.");
      }
      int monthNumber = monthsList.indexOf(_selectedMonth!) + 1;
      DateTime birthday = DateTime(_selectedYear!, monthNumber, _selectedDay!);
      String location = _selectedLocation!;
      await _authService.signUp(
        email: email,
        password: password,
        username: username,
        birthday: birthday,
        location: location,
      );
      return true;
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateMonth(String? month) {
    _selectedMonth = month;
    notifyListeners(); // هذا السطر هو البديل السحري لـ setState، يقوم بإعلام الواجهات لتحديث نفسها
  }

  void updateDay(int? day) {
    _selectedDay = day;
    notifyListeners();
  }

  void updateYear(int? year) {
    _selectedYear = year;
    notifyListeners();
  }

  void updateLocation(String? location) {
    _selectedLocation = location;
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
