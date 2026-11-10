import 'package:art_marketplace/models/post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class cartservice {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> addToCart({required Post item, required userid}) async {
    await _supabase.from('cart_items').insert(item.id).eq("user_id", userid);
  }

  Future<void> removeFromCart({required Post item, required userid}) async {
    await _supabase
        .from('cart_items')
        .delete()
        .eq('artwork_id', item.id)
        .eq('user_id', userid);
  }

  Future<List<Post>> fetchCartItems({required String userid}) async {
    final response = await _supabase
        .from('cart_items')
        .select('''*, artworks(*)''')
        .eq('user_is', userid)
        .order('created_at', ascending: false); //من الاحدث للاقدم
    return response.map((item) => Post.fromMap(item)).toList();
  }
}
