import 'dart:io';
import 'package:flutter/material.dart';

class CustomImageFieldDetails extends StatelessWidget {
  final List<String> imagePaths;

  const CustomImageFieldDetails({
    required this.imagePaths,
    Key? key,
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
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: imagePaths.map((path) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.file(
                      File(path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
