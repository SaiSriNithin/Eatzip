import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop/admin/imageselection.dart';
import 'package:sweet_shop/models/categories.dart';
import 'package:sweet_shop/models/sweet_model.dart';
import 'package:uuid/uuid.dart';

class AddSweet extends StatefulWidget {
  const AddSweet({super.key});

  @override
  State<AddSweet> createState() => _AddSweetState();
}

class _AddSweetState extends State<AddSweet> {
  List<Categories> addCat = [];
  Categories? _selectedItem;
  Uint8List? _image;
  final TextEditingController sweetController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  bool? _availability;
  final Uuid uuid = const Uuid();
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  loadCategories() async {
    setState(() {
      isloading = true;
    });
    List<Categories> temp = await Categories.loadFromFirestore();
    setState(() {
      addCat = temp;
      isloading = false;
    });
  }
  // loadCategories() async {
  //   List<Categories> temp =
  //       await Categories.loadListFromLocalStorage('category1');
  //   setState(() {
  //     addCat = temp;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.white,
        title: Text('Add Sweet'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: DropdownButtonFormField<Categories>(
                      menuMaxHeight: 500,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      hint: Text('Select a category'),
                      value: _selectedItem,
                      items: addCat.map((Categories category) {
                        return DropdownMenuItem<Categories>(
                          value: category,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (Categories? newValue) {
                        setState(
                          () {
                            _selectedItem = newValue;
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: sweetController,
                    decoration: InputDecoration(
                      labelText: "Enter the Sweet Name",
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: "Enter the Sweet Price",
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Availability',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                  SizedBox(
                    height: 15,
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
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: isloading
                        ? null
                        : () async {
                            setState(() {
                              isloading = true;
                            });
                            // Check if a category is selected
                            if (_selectedItem == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Please select a category')),
                              );
                              setState(() {
                                isloading = false;
                              });
                              return;
                            }

                            // Check if the sweet name and price are provided
                            if (sweetController.text.isEmpty ||
                                priceController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Please provide sweet name and price')),
                              );
                              setState(() {
                                isloading = false;
                              });
                              return;
                            }

                            // Check if an image is selected
                            if (_image == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Please select an image')),
                              );
                              setState(() {
                                isloading = false;
                              });
                              return;
                            }

                            // Create a new sweet object
                            Sweet newSweet = Sweet(
                              name: sweetController.text,
                              price: double.parse(priceController.text),
                              image: base64Encode(_image!),
                              id: uuid.v4(),
                              avalibility: _availability!,
                            );

                            // Add the new sweet to the selected category
                            await Categories.addSweetToCategory(
                                _selectedItem!.id, newSweet);

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Sweet added successfully')),
                            );

                            // Clear the form fields
                            sweetController.clear();
                            priceController.clear();
                            setState(() {
                              _image = null;
                              isloading = false;
                            });
                          },
                    child: Text('Submit'),
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: addCat.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.network(
                          addCat[index].image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(addCat[index].name),
                        subtitle: Text(
                            addCat[index].categorysweets.length.toString()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          if (isloading)
            ModalBarrier(
              color: Colors.black.withOpacity(0.5),
              dismissible: false,
            ),
          if (isloading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
