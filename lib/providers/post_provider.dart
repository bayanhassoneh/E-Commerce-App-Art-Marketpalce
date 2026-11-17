import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:art_marketplace/services/image_picker_service.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:art_marketplace/services/storage_service.dart';
import 'package:art_marketplace/services/post_service.dart';
import 'package:art_marketplace/models/post.dart';

class PostProvider extends ChangeNotifier {
  final imagePickerService _imagePickerService = imagePickerService();
  final storageService _storageService = storageService();
  final PostService _postService = PostService();
  File? _selectedImage;
  bool _isLoading = false;
  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;
  List<Post> posts = [];
  Post? post;

  Future<void> pickImage() async {
    File? imageFile = await _imagePickerService.pickImage();
    if (imageFile != null) {
      _selectedImage = imageFile;
      notifyListeners();
    }
  }

  Future<bool> createPost(
    String description,
    String title,
    double price,
  ) async {
    _isLoading = true;
    notifyListeners();

    if (_selectedImage == null) return false;

    try {
      final imageUrl = await _storageService.uploadPost(_selectedImage!);

      await _postService.createpost(
        imageUrl: imageUrl,
        title: title,
        price: price,
        description: description,
      );

      return true;
    } on Exception catch (e) {
      print("Error creating post: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFeedPosts() async {
    try {
      _isLoading = true;
      notifyListeners();

      posts = await _postService.fetchFeedPosts();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initPost(Post initpost) async {
    post = initpost;
    notifyListeners();
    if (initpost.profile == null) {
      await getPostInfo(initpost.id);
    }
  }

  Future<void> getPostInfo(String id) async {
    try {
      _isLoading = true;
      notifyListeners();
      post = await _postService.getPostInfo(id);
    } catch (e) {
      print('error acurred:$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
