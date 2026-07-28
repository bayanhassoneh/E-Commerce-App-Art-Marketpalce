import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:art_marketplace/models/app_user.dart';
import 'package:art_marketplace/models/post.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AppUser> fetchUserProfile({required String profileUserId}) async {
    final data = await _supabase
        .from('profiles')
        .select()
        .eq('id', profileUserId)
        .single();
    return AppUser.fromMap(data);
  }

  Future<List<Post>> fetchUserArtworks({required String profileUserId}) async {
    final List<dynamic> data = await _supabase
        .from('artworks')
        .select()
        .eq('user_id', profileUserId);
    return data.map((item) => Post.fromMap(item)).toList();
  }

  //هوم سيرفس
}
