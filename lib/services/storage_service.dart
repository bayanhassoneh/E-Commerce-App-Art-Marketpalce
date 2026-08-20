import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class storageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> uploadPost(File image) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg'; //اسم فريد
    await _supabase.storage.from('posts').upload(fileName, image);
    final imageUrl = _supabase.storage.from('posts').getPublicUrl(fileName);
    return imageUrl;
  }

  Future<String> uploadProfileImage(File image) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    await _supabase.storage.from('avatars').upload(fileName, image);
    final imageUrl = _supabase.storage.from('avatars').getPublicUrl(fileName);
    return imageUrl;
  }

  Future<void> deleteProfileImage(String imageUrl) async {
    final url = imageUrl.split('/').last;
    await _supabase.storage.from('avatars').remove([url]);
  }
}
