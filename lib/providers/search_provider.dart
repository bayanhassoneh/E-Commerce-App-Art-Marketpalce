import 'package:art_marketplace/models/app_user.dart';
import 'package:art_marketplace/models/post.dart';
import 'package:art_marketplace/services/search_service.dart';
import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  List<Post>? artworksFutur;
  List<AppUser>? usresFuture;
  SearchService _searchService = SearchService();
  void performsearch(String value) {
    final query = value.trim();
    if (query.isEmpty) {
      return;
    }
    searchArtworks(query);
    searchUsers(query);
  }

  Future<void> searchArtworks(String query) async {
    artworksFutur = await _searchService.searchArtworks(query);
    notifyListeners();
  }

  Future<void> searchUsers(String query) async {
    usresFuture = await _searchService.searchUsers(query);
    notifyListeners();
  }
}
