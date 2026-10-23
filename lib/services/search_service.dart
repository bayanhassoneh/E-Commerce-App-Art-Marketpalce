import 'package:art_marketplace/models/app_user.dart';
import 'package:art_marketplace/models/post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchService {
  SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Post>> searchArtworks(String query) async {
    final respons = await _supabase
        .from('artworks')
        .select()
        .ilike('title', '%$query%');
    return respons.map((post) => Post.fromMap(post)).toList();
  }

  Future<List<AppUser>> searchUsers(String query) async {
    final respons = await _supabase
        .from('profiles')
        .select()
        .ilike('user_name', '%$query%');
    return respons.map((user) => AppUser.fromMap(user)).toList();
  }
}
