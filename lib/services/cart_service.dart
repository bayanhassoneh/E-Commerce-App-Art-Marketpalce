import 'package:art_marketplace/models/post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:art_marketplace/models/cartItemModel.dart';
import 'package:isar/isar.dart';

class CartService {
  late Isar isar;
  CartService(this.isar);
  final SupabaseClient _supabase =
      Supabase.instance.client; //لازم امررها ككونستراكتور عشان التيست لاحقا
  /////////////////////////////////////////////////////////////////////////////

  Future<void> addToCart({required Post item, required String userid}) async {
    await _supabase.from('cart_items').insert({
      'user_id': userid,
      'artwork_id': item.id,
    });
  }

  Future<void> removeFromCart({
    required Post item,
    required String userid,
  }) async {
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
        .eq('user_id', userid)
        .order('created_at', ascending: false); //من الاحدث للاقدم

    return response.map((item) {
      final posts = item['artworks'] as Map<String, dynamic>;
      return Post.fromMap(posts);
    }).toList();
  }

  Future<void> saveLocalItems(List<Post> cartItems) async {
    final localItems = cartItems
        .map((post) => Cartitemmodel.fromPost(post))
        .toList();
    await isar.writeTxn(() async {
      await isar.cartitemmodels.clear();
      await isar.cartitemmodels.putAll(localItems);
    });
  }

  Future<void> removeFromCache(Post item) async {
    final localItem = Cartitemmodel.fromPost(item);
    await isar.writeTxn(() async {
      await isar.cartitemmodels.delete(localItem.isarId);
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
