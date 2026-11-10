import 'package:art_marketplace/models/cartItemModel.dart';
import 'package:art_marketplace/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:art_marketplace/models/post.dart';
import 'package:art_marketplace/services/cart_service.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class CartProvider extends ChangeNotifier {
  List<Post> cartItems = [];
  List<Cartitemmodel> localItems = [];
  final cartservice _service = cartservice();
  AuthProvider _authProvider = AuthProvider();
  String errorMessage = '';
  late Isar isar;
  Future<void> addToCart(Post item) async {
    if (!isIncart(item)) {
      try {
        await _service.addToCart(
          item: item,
          userid: _authProvider.currentUserId,
        );
        cartItems.add(item);
      } on Exception catch (e) {
        errorMessage = 'failed to add the item: $e';
      } finally {
        notifyListeners();
      }
    }
  }

  Future<void> removeFromCart(Post item) async {
    try {
      await _service.removeFromCart(
        item: item,
        userid: _authProvider.currentUserId,
      );
      cartItems.remove(item);
    } on Exception catch (e) {
      errorMessage = 'failed to remove the item: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchCartItems() async {
    try {
      cartItems = await _service.fetchCartItems(
        userid: _authProvider.currentUserId!,
      );
    } on Exception catch (e) {
      errorMessage = 'failed to load the items: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> saveLocalItems() async {
    localItems = cartItems.map((post) => Cartitemmodel.fromPost(post)).toList();
    await isar.writeTxn(() async {
      await isar.cartitemmodels.putAll(localItems);
    });
  }

  Future<void> readLocalItems() async {
    localItems = await isar.cartitemmodels.where().findAll();
    cartItems = localItems.map((post) => Post.fromCartItem(post)).toList();
  }

  Future<void> initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([CartitemmodelSchema], directory: dir.path);
  }

  bool isIncart(Post item) {
    return cartItems.any((cartItem) => cartItem.id == item.id);
  }

  double get totalPrice {
    return cartItems.fold(0.0, (total, item) => total + item.price);
  }
}
