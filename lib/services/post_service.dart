import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:art_marketplace/models/post.dart';

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

  Future<List<Post>> fetchFeedPosts() async {
    final response = await _supabase
        .from('artworks')
        .select(''' 
    *,
    profiles(
    user_name,
    cover_url
    )
    ''')
        .order('created_at', ascending: false)
        .limit(25);
    return response.map((post) => Post.fromMap(post)).toList();
  }
}
