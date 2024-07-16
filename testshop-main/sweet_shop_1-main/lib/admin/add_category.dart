import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sweet_shop/admin/imageselection.dart';
import 'package:sweet_shop/models/categories.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  List<Categories> addcat = [];
  final TextEditingController categoryController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  loadCategories() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Categories> temp = await Categories.loadFromFirestore();
      print(temp);
      setState(() {
        addcat = temp;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading categories: $e');
    }
  }

  saveCategory() async {
    if (categoryController.text.isNotEmpty && _image != null) {
      try {
        Categories categoriesInstance = Categories(
          id: '', // Assuming your model handles id assignment internally
          name: '',
          image: '',
          categorysweets: [],
        );

        Categories newCategory =
            await categoriesInstance.createNewCategoryFirestore(
          categoryController.text.trim(),
          _image!,
        );

        setState(() {
          categoryController.clear();
          _image = null;
          addcat.add(newCategory);
        });
      } catch (e) {
        print('Error saving category: $e');
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
        title: Text('Add Category'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: saveCategory,
                  child: Text('Submit'),
                ),
                SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator()
                    : Expanded(
                        child: ListView.builder(
                          itemCount: addcat.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Image.network(
                                addcat[index].image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(addcat[index].name),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
          if (isLoading)
            ModalBarrier(
              color: Colors.black.withOpacity(0.5),
              dismissible: false,
            ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}


// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:sweet_shop/admin/imageselection.dart';
// import 'package:sweet_shop/models/categories.dart';

// class AddCategory extends StatefulWidget {
//   const AddCategory({super.key});

//   @override
//   State<AddCategory> createState() => _AddCategoryState();
// }

// class _AddCategoryState extends State<AddCategory> {
//   List<Categories> addcat = [];
//   final TextEditingController categoryController = TextEditingController();
//   Uint8List? _image;
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     loadCategories();
//   }

//   loadCategories() async {
//     setState(() {
//       isLoading = true;
//     });
//     List<Categories> temp = await Categories.loadFromFirestore();
//     setState(() {
//       addcat = temp;
//       isLoading = false;
//     });
//   }

//   saveCategory() async {
//     if (categoryController.text.isNotEmpty && _image != null) {
//       Categories categoriesInstance =
//           Categories(id: '', name: '', image: '', categorysweets: []);

// // Call the instance method to create a new category
//       Categories newCategory = await categoriesInstance
//           .createNewCategoryFirestore(categoryController.text.trim(), _image!);

//       setState(() {
//         categoryController.clear();
//         _image = null;
//         addcat.add(newCategory);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Category'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             TextFormField(
//               keyboardType: TextInputType.text,
//               controller: categoryController,
//               decoration: InputDecoration(
//                 labelText: "Enter the Category Name",
//                 fillColor: Color.fromARGB(255, 255, 255, 255),
//                 filled: true,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25.0),
//                 ),
//               ),
//             ),
//             SizedBox(height: 50),
//             InkWell(
//               onTap: () async {
//                 Uint8List? dummy = await showImagePickerOption(context);
//                 setState(() {
//                   _image = dummy;
//                 });
//               },
//               child: Container(
//                 clipBehavior: Clip.hardEdge,
//                 height: MediaQuery.of(context).size.height / 4,
//                 width: MediaQuery.of(context).size.width / 2,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black),
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                 ),
//                 child: _image != null
//                     ? Image(
//                         image: MemoryImage(_image!),
//                         fit: BoxFit.cover,
//                       )
//                     : Image.asset(
//                         'assets/fileadd.jpg',
//                         scale: 1.8,
//                       ),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: saveCategory,
//               child: Text('Submit'),
//             ),
//             SizedBox(height: 20),
//             isLoading
//                 ? CircularProgressIndicator()
//                 : Expanded(
//                     child: ListView.builder(
//                       itemCount: addcat.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           leading: Image.network(
//                             addcat[index].image,
//                             width: 50,
//                             height: 50,
//                             fit: BoxFit.cover,
//                           ),
//                           title: Text(addcat[index].name),
//                         );
//                       },
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:sweet_shop/admin/imageselection.dart';
// import 'package:sweet_shop/models/categories.dart';

// class AddCategory extends StatefulWidget {
//   const AddCategory({super.key});

//   @override
//   State<AddCategory> createState() => _AddCategoryState();
// }

// class _AddCategoryState extends State<AddCategory> {
//   List<Categories> addcat = [];
//   final TextEditingController categoryController = TextEditingController();
//   Uint8List? _image;
//   @override
//   void initState() {
//     super.initState();
//     loadCategories();
//   }

//   loadCategories() async {
//     List<Categories> temp =
//         await Categories.loadListFromLocalStorage('category1');
//     setState(() {
//       addcat = temp;
//     });
//   }

//   saveCategory() async {
//     if (categoryController.text.isNotEmpty && _image != null) {
//       Categories newCategory = Categories(
//         name: categoryController.text,
//         image: _image!,
//       );
//       addcat.add(newCategory);
//       await Categories.saveListToLocalStorage(addcat, 'category1');
//       setState(() {
//         categoryController.clear();
//         _image = null;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Category'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             TextFormField(
//               keyboardType: TextInputType.text,
//               controller: categoryController,
//               decoration: InputDecoration(
//                 labelText: "Enter the Category Name",
//                 fillColor: Color.fromARGB(255, 255, 255, 255),
//                 filled: true,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25.0),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             InkWell(
//               onTap: () async {
//                 Uint8List? dummy = await showImagePickerOption(context);
//                 setState(() {
//                   _image = dummy;
//                 });
//               },
//               child: Container(
//                 clipBehavior: Clip.hardEdge,
//                 height: MediaQuery.of(context).size.height / 4,
//                 width: MediaQuery.of(context).size.width / 2,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black),
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                 ),
//                 child: _image != null
//                     ? Image(
//                         image: MemoryImage(_image!),
//                         fit: BoxFit.cover,
//                       )
//                     : Image.asset(
//                         'assets/fileadd.jpg',
//                         scale: 1.8,
//                       ),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             ElevatedButton(
//               onPressed: saveCategory,
//               child: Text('submit'),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: addcat.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     leading: Image.memory(
//                       addcat[index].image,
//                       width: 50,
//                       height: 50,
//                       fit: BoxFit.cover,
//                     ),
//                     title: Text(addcat[index].name),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
