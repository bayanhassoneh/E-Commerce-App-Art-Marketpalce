import 'package:supabase_flutter/supabase_flutter.dart';

class FollowService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> followUser(String follower_id, String following_id) async {
    await _supabase.from('follows').insert({
      "follower_id": follower_id,
      "following_id": following_id,
    });
  }

  Future<int> getFollowersCount(String profileUserId) async {
    final response = await _supabase
        .from('follows')
        .select()
        .eq('following_id', profileUserId);

    return response.length;
  }

  Future<int> getFollowingCount(String profileUserId) async {
    final respons = await _supabase
        .from('follows')
        .select()
        .eq("following_id", profileUserId);
    return respons.length;
  }

  Future<bool> checkFollowing(String profileUserId) async {
    final currentUserId = _supabase.auth.currentUser!.id;

    final response = await _supabase
        .from('follows')
        .select()
        .eq('follower_id', currentUserId)
        .eq('following_id', profileUserId);

    return response.isNotEmpty;
  }

  Future<void> unfollow(String profileUserId) async {
    final currentUserId = _supabase.auth.currentUser!.id;
    await _supabase
        .from('follows')
        .delete()
        .eq("follower_id", currentUserId)
        .eq('following_id', profileUserId);
  }
}
