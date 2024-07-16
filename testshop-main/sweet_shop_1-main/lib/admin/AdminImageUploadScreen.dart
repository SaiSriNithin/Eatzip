import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop/admin/imageselection.dart';

class AdminImageUploadScreen extends StatefulWidget {
  const AdminImageUploadScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _AdminImageUploadScreenState createState() => _AdminImageUploadScreenState();
}

class _AdminImageUploadScreenState extends State<AdminImageUploadScreen> {
  List<String> imgList = [];
  bool isLoading = false;
  Uint8List? _image;

  Future<void> uploadImage(image) async {
    if (image != null) {
      setState(() {
        isLoading = true;
      });

      try {
        Uint8List imageData = await image;
        String fileName =
            'carousel/${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
        TaskSnapshot uploadTask = await storageRef.putData(imageData);

        String downloadUrl = await uploadTask.ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('carousel_images')
            .add({'url': downloadUrl});

        setState(() {
          imgList.add(downloadUrl);
          isLoading = false;
          image = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Todays special added successfully'),
          ),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        debugPrint('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.white,
        title: Text('Admin Image Upload'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () async {
                      Uint8List? dummy = await showImagePickerOption(context);
                      setState(() {
                        _image = dummy;
                      });
                    },
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: _image != null
                          ? Image(
                              image: MemoryImage(_image!),
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/fileadd.jpg',
                              scale: 1.8,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            uploadImage(_image);
                            _image = null;
                          },
                    child: Text('Upload Image'),
                  ),
                ],
              ),
            ),
    );
  }
}
