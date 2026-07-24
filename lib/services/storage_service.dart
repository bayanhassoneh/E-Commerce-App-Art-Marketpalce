import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class storageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> uploadImage(File image) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    await _supabase.storage.from('posts').upload(fileName, image);

    final imageUrl = _supabase.storage.from('posts').getPublicUrl(fileName);

    return imageUrl;
  }
}
