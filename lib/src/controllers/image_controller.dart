import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Controller for managing image selection and storage.
///
/// Allows selection of an image from the device's gallery or camera using
/// [ImagePicker]. The selected image can be accessed via [selectedImage].
/// Images are saved to the application's support directory with a filename
/// derived from [plateVehicle] and a timestamp to ensure uniqueness.
///
/// Provides functionality to pick an image based on the [source] parameter
/// (gallery or camera), save it locally, and update [selectedImage].
class ImageController extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  /// Returns the currently selected image file.
  File? get selectedImage => _selectedImage;

  /// Picks an image from [source] (gallery or camera) and saves it locally
  /// with a filename constructed from [plateVehicle] and a timestamp.
  ///
  /// Updates [selectedImage] with the saved image file and notifies listeners.
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