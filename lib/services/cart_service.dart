import 'package:art_marketplace/models/post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:art_marketplace/models/cartItemModel.dart';
import 'package:isar/isar.dart';

class cartservice {
  late Isar isar;
  cartservice(this.isar);
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

  Future<void> saveLocalItems(List<Post> cartItems) async {
    final localItems = cartItems
        .map((post) => Cartitemmodel.fromPost(post))
        .toList();
    await isar.writeTxn(() async {
      await isar.cartitemmodels.putAll(localItems);
    });
  }

  Future<List<Post>> readLocalItems() async {
    final localItems = await isar.cartitemmodels.where().findAll();
    final cartItems = localItems
        .map((post) => Post.fromCartItem(post))
        .toList();
    return cartItems;
  }
}
