import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageController extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  File? get selectedImage => _selectedImage;

  Future<void> pickImage(ImageSource source, String plateVehicle) async {
    final pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      final directory = await getApplicationSupportDirectory();
      final path = directory.path;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$plateVehicle-$timestamp.png';
      final savedImage = await File(pickedFile.path).copy('$path/$fileName');

      _selectedImage = savedImage;

      notifyListeners();
    }
  }
}