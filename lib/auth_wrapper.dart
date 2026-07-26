import 'package:art_marketplace/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/CompleteProfileScreen.dart';
import 'core/navigation.dart';
import 'dart:async';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final SupabaseClient _supabase = Supabase.instance.client;
  User? _user;
  bool isLoading = true;
  bool? _needsUsername;
  StreamSubscription<AuthState>? _authSubscription;
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  @override
  void dispose() {
    _authSubscription?.cancel(); // حماية الذاكرة ومنع الـ Memory Leaks
    super.dispose();
  }

  Future<void> _checkAuth() async {
    // 1. الفحص الأولي عند فتح التطبيق مباشرة (حالة الكاش)
    final session = _supabase.auth.currentSession;
    _user = session?.user;

    if (_user != null) {
      await _fetchProfileStatus(_user!.id);
    } else {
      setState(() {
        isLoading = false;
      });
    }

    // 2. الاستماع لأي تغيير في حالة تسجيل الدخول (مثل الضغط على زر جوجل أو تسجيل الخروج)
    _authSubscription = _supabase.auth.onAuthStateChange.listen((data) async {
      if (!mounted) return;

      // هندلة استعادة كلمة المرور
      if (data.event == AuthChangeEvent.passwordRecovery) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => const SetPasswordScreen(title: 'set password'),
          ),
        );
        return;
      }

      // تحديث بيانات المستخدم الحالي
      _user = data.session?.user;

      if (_user != null) {
        setState(() {
          isLoading = true;
        });
        // جلب حالة البروفايل بدون تعطيل الـ Stream الرئيسي
        await _fetchProfileStatus(_user!.id);
      } else {
        // في حال تسجيل الخروج، تصفير الحالات فوراً
        setState(() {
          _user = null;
          _needsUsername = null;
          isLoading = false;
        });
      }
    });
  }

  // دالة منفصلة ومحمية بالكامل لجلب حالة الـ username
  Future<void> _fetchProfileStatus(String userId) async {
    try {
      final profile = await _supabase
          .from('profiles')
          .select('user_name')
          .eq('id', userId)
          .maybeSingle(); // يرجع null بكل هدوء إذا كان السجل غير موجود بعد

      if (profile == null) {
        // إذا كان التريجر لم ينشئ السجل بعد أو السجل غير موجود -> حتماً يحتاج يوزر نيم
        _needsUsername = true;
      } else {
        // إذا السجل موجود، نتأكد هل الحقل الخاص باليوزر نيم فارغ أم لا
        final String? username = profile['user_name'];
        _needsUsername = (username == null || username.trim().isEmpty);
      }
    } catch (e) {
      print("Error fetching profile inside wrapper: $e");
      // في حال حدوث أي خطأ بالاتصال، نضعه true كحماية لكي لا يعلق التطبيق
      _needsUsername = true;
    }

    if (mounted) {
      setState(() {
        isLoading = false; // إنهاء مؤشر التحميل بعد التأكد من كل شيء
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_user != null) {
      if (_needsUsername == true) {
        return const CompleteProfileScreen();
      }
      return const HomePage(title: 'home');
    } else {
      return const SignInScreen();
    }
  }
}
