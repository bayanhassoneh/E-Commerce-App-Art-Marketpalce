import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  final SharedPreferencesAsync sharedPreferencesAsync =
      SharedPreferencesAsync();
  Future<void> toggleTheme(bool isDark) async {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await sharedPreferencesAsync.setBool('isdark', isDark);
    //بعمل set كل مره لنفس ال key 'isdark'
    //هي shared preferences بين التطبيق والجهاز , بتحفظ قيمة ال key محليا عالجهاز
  }

  Future<void> loadTheme() async {
    final isDark = await sharedPreferencesAsync.getBool('isdark') ?? false;
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
