import 'package:supabase_flutter/supabase_flutter.dart';

class PostService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createpost({
    required String imageUrl,
    required String title,
    required double price,
    required String description,
  }) async {
    await _supabase.from('artworks').insert({
      'image_url': imageUrl,
      'title': title,
      'price': price,
      'description': description,
      'user_id': _supabase.auth.currentUser?.id,
    });
  }
}
