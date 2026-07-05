import 'package:art_marketplace/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';

//
class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> saveUsername() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final username = _usernameController.text.trim();
    //trim يشيل المسافات
    // setState(() {
    //   _isLoading = true;
    // });
    try {
      //  final userId = Supabase.instance.client.auth.currentUser!.id;
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final userId = user.id;

      await Supabase.instance.client
          .from('profiles')
          .update({'user_name': username})
          .eq('id', userId);

      // if (!mounted) return;
      // إذا الصفحة انقفلت أثناء العملية لا تكمل
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } //context>>start point, '\'>>aoth_wrapper(destination), (route) => false>>remove all previous routes
      //هيك افضل عشان ادير الذاكره وما يضل الرابر بالخلفيه وما يحدثش التعديل اللي صار بالداتا بيز
      // Navigator.pushReplacementNamed(context, '/home');
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        // 23505 هو رمز الخطأ لوجود تعارض في المفتاح الأساسي (Primary Key Violation) أو فريد (Unique Constraint Violation)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username already exists')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unexpected error: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);
    // return Scaffold(
    //   resizeToAvoidBottomInset: false,
    //   appBar: AppBar(
    //     title: const Text('Complete Your Profile'),
    //     automaticallyImplyLeading: false,
    //   ),
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44.0), // الارتفاع القياسي لآيفون
        child: CupertinoNavigationBar(
          middle: Text(
            'Complete Your Profile',
            style: TextStyle(color: CupertinoColors.inactiveGray, fontSize: 20),
            // textAlign: TextAlign.center,
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Please choose a username to complete your profile.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: CustomTextFeild(
                hint: "username",
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Username is required';
                  }
                  if (value.length < 4) {
                    return "Username is too short";
                  }
                  if (value.length > 20) {
                    return "Username is too long";
                  }
                  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                    return "Only letters, numbers and _ allowed";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Continue",
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        saveUsername();
                      }
                    },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
