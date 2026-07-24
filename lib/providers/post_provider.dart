import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:art_marketplace/services/image_picker_service.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:art_marketplace/services/storage_service.dart';
import 'package:art_marketplace/services/post_service.dart';

class PostProvider extends ChangeNotifier {
  final imagePickerService _imagePickerService = imagePickerService();
  final storageService _storageService = storageService();
  final PostService _postService = PostService();
  File? _selectedImage;
  bool _isLoading = false;
  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;
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

    final imageUrl = await _storageService.uploadImage(_selectedImage!);

    await _postService.createpost(
      imageUrl: imageUrl,
      title: title,
      price: price,
      description: description,
    );

    return true;
  }
}
