import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop/admin/imageselection.dart';
import 'package:sweet_shop/models/categories.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditCategory extends StatefulWidget {
  final Categories category;

  const EditCategory({required this.category, super.key});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  late TextEditingController categoryController;
  Uint8List? _image;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    categoryController = TextEditingController(text: widget.category.name);
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  Future<void> saveCategory() async {
    setState(() {
      isLoading = true;
    });

    String imageUrl = widget.category.image;

    if (_image != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('categories/${widget.category.id}.jpg');
      if (imageUrl.isNotEmpty) {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }
      await storageRef.putData(_image!);
      imageUrl = await storageRef.getDownloadURL();
    }

    final updatedCategory = Categories(
      id: widget.category.id,
      name: categoryController.text.trim(),
      image: imageUrl,
      categorysweets: widget.category.categorysweets,
    );

    await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.category.id)
        .update(updatedCategory.toMap());

    setState(() {
      isLoading = false;
    });

    Navigator.pop(context, updatedCategory);
  }

  Future<void> pickImage() async {
    Uint8List? selectedImage = await showImagePickerOption(context);
    setState(() {
      _image = selectedImage;
    });
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
        title: Text('Edit Category'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: "Enter the Category Name",
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              SizedBox(height: 50),
              InkWell(
                onTap: pickImage,
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
                      : Image.network(
                          widget.category.image,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveCategory,
                child: Text('Save Changes'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
