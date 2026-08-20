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
        .select('*, profiles(user_name)') //بستخدم '''triple quotes
        .eq('user_id', profileUserId);
    return data.map((item) => Post.fromMap(item)).toList();
  }

  Future<void> updateProfilePicture({
    required String profileId,
    required String imageUrl,
  }) async {
    await _supabase
        .from('profiles')
        .update({'cover_url': imageUrl})
        .eq('id', profileId);
  }

  Future<void> updateProfile({
    required String profileId,
    required String username,
    required String bio,
    required String location,
    required String socialLinke,
  }) async {
    await _supabase
        .from('profiles')
        .upsert({
          'user_name': username,
          'bio': bio,
          'location': location,
          'social_link': socialLinke,
        })
        .eq('id', profileId);
  }

  //هوم سيرفس
}
