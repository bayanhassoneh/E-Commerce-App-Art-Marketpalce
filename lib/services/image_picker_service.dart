import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class imagePickerService {
  final ImagePicker _picker = ImagePicker();
  //final SupabaseClient _supabase = Supabase.instance.client;

  Future<File?> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
