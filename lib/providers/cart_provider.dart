import 'package:art_marketplace/models/cartItemModel.dart';
import 'package:art_marketplace/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:art_marketplace/models/post.dart';
import 'package:art_marketplace/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _service;
  final AuthProvider _authProvider;
  CartProvider(this._service, {AuthProvider? authProvider})
    : _authProvider = authProvider ?? AuthProvider();
  //{}=optional/named parameter
  //البرايفيت فاريابل بقدرش اعمل عليه اكسس جوات الاوبشنال , فبتختلف طريقة كتابته و استقباله
  //_service > positional parameter

  List<Post> cartItems = [];
  List<Cartitemmodel> localItems = [];
  String errorMessage = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> addToCart(Post item) async {
    if (_authProvider.currentUserId == null) {
      cartItems = [];
      errorMessage = 'Please log in to view your cart.';
      _isLoading = false;
      notifyListeners();
      return;
    }
    if (!isIncart(item)) {
      try {
        await _service.addToCart(
          item: item,
          userid: _authProvider.currentUserId!,
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
    if (_authProvider.currentUserId == null) {
      cartItems = [];
      errorMessage = 'Please log in to view your cart.';
      _isLoading = false;
      notifyListeners();
      return;
    }
    try {
      await _service.removeFromCart(
        item: item,
        userid: _authProvider.currentUserId!,
      );
      cartItems.removeWhere((element) => element.id == item.id);
      try {
        await _service.removeFromCache(item);
      } catch (e) {
        errorMessage = 'Failed to remove from Cache:$e';
      }
    } on Exception catch (e) {
      errorMessage = 'failed to remove the item: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchCartItems() async {
    if (_authProvider.currentUserId == null) {
      cartItems = [];
      errorMessage = 'Please log in to view your cart.';
      _isLoading = false;
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      cartItems = await _service.fetchCartItems(
        userid: _authProvider.currentUserId!,
      );
      try {
        await _service.saveLocalItems(cartItems);
      } catch (e) {
        print(e);
      }
    } on Exception catch (e) {
      try {
        cartItems = await _service.readLocalItems();
        errorMessage = 'an error accrued: $e';
      } on Exception catch (e) {
        errorMessage = 'Failed to load latest updates: $e';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isIncart(Post item) {
    return cartItems.any((cartItem) => cartItem.id == item.id);
  }

  double get totalPrice {
    return cartItems.fold(0.0, (total, item) => total + item.price);
  }
}
