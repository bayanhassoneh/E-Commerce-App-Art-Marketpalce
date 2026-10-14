import 'package:supabase_flutter/supabase_flutter.dart';

class SearchService {
  SupabaseClient _supabase = Supabase.instance.client;
  Future<List<Map<String, dynamic>>> searchArtworks(String query) async {
    return await _supabase.from('artworks').select().ilike('title', '%$query%');
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    return await _supabase
        .from('profiles')
        .select()
        .ilike('user_name', '%$query%');
  }
}
