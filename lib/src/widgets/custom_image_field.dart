import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomImageField extends StatelessWidget {
  final Function(ImageSource) onImageSourceSelected;
  final List<String> imagePaths;
  final Function(String) onRemoveImage;

  const CustomImageField({
    Key? key,
    required this.onImageSourceSelected,
    required this.imagePaths,
    required this.onRemoveImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Text(
              'Fotos do Veículo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    onImageSourceSelected(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.photo_library),
                  iconSize: 40,
                  color: Colors.blue,
                ),
                const Text('Galeria'),
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    onImageSourceSelected(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera_alt),
                  iconSize: 40,
                  color: Colors.blue,
                ),
                Text('Câmera'),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Wrap(
            children: imagePaths
                .map(
                  (imagePath) => Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.file(
                      File(imagePath),
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        onRemoveImage(imagePath);
                      },
                    ),
                  ),
                ],
              ),
            )
                .toList(),
          ),
        ),
      ],
    );
  }
}
