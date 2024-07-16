import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sweet_shop/models/sweet_model.dart';
import 'package:sweet_shop/admin/imageselection.dart';

class EditSweetDetails extends StatefulWidget {
  final Sweet sweet;

  const EditSweetDetails({required this.sweet, super.key});

  @override
  State<EditSweetDetails> createState() => _EditSweetDetailsState();
}

class _EditSweetDetailsState extends State<EditSweetDetails> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  bool? _availability;
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.sweet.name);
    priceController =
        TextEditingController(text: widget.sweet.price.toString());
    _availability = widget.sweet.avalibility;
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void saveSweet() async {
    String imageUrl = widget.sweet.image;
    if (_image != null) {
      final storageRef =
          FirebaseStorage.instance.ref().child('sweets/${widget.sweet.id}.jpg');
      if (imageUrl.isNotEmpty) {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }
      await storageRef.putData(_image!);
      imageUrl = await storageRef.getDownloadURL();
    }
    setState(() {
      widget.sweet.name = nameController.text;
      widget.sweet.price = double.parse(priceController.text);
      widget.sweet.avalibility = _availability!;
      widget.sweet.image = imageUrl;
    });
    Navigator.pop(context, widget.sweet);
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
      appBar: AppBar(
        title: Text('Edit Sweet Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Sweet Name',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Sweet Price',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Availability',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  RadioListTile<bool>(
                    title: const Text('Available'),
                    value: true,
                    groupValue: _availability,
                    onChanged: (bool? value) {
                      setState(() {
                        _availability = value;
                      });
                    },
                  ),
                  RadioListTile<bool>(
                    title: const Text('Not Available'),
                    value: false,
                    groupValue: _availability,
                    onChanged: (bool? value) {
                      setState(() {
                        _availability = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 15),
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
                      ? Image.memory(
                          _image!,
                          fit: BoxFit.cover,
                        )
                      : Image.network(widget.sweet.image, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: saveSweet,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
