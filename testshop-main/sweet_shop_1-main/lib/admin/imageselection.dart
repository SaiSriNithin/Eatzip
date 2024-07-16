import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> showImagePickerOption(BuildContext context) {
  Completer<Uint8List?> completer = Completer<Uint8List?>();

  showModalBottomSheet(
      backgroundColor: Colors.blue[100],
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      Uint8List? _image = await _pickImageFromGallery(context);
                      completer.complete(_image);
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 70,
                          ),
                          Text("Gallery")
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      Uint8List? _image = await _pickImageFromCamera(context);
                      completer.complete(_image);
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 70,
                          ),
                          Text("Camera")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
  return completer.future;
}

//Gallery
Future<Uint8List?> _pickImageFromGallery(BuildContext context) async {
  final returnImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  if (returnImage == null) return null;

  //File selectedIMage = File(returnImage.path);
  Uint8List _image = await File(returnImage.path).readAsBytes();

  Navigator.of(context).pop(); // Close the modal sheet

  return _image;
}

//Camera
Future<Uint8List?> _pickImageFromCamera(BuildContext context) async {
  final returnImage = await ImagePicker().pickImage(source: ImageSource.camera);
  if (returnImage == null) return null;

  //File selectedIMage = File(returnImage.path);
  Uint8List _image = File(returnImage.path).readAsBytesSync();

  Navigator.of(context).pop();
  return _image;
}
