import 'package:flutter/material.dart';
import 'package:sweet_shop/models/categories.dart';
import 'package:sweet_shop/admin/editcategory.dart';

class EditCategoryScreen extends StatefulWidget {
  const EditCategoryScreen({super.key});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  List<Categories> categoriesList = [];
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
    List<Categories> temp = await Categories.loadFromFirestore();
    setState(() {
      categoriesList = temp;
      isLoading = false;
    });
  }

  void navigateToEditCategory(Categories category, int index) async {
    final updatedCategory = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCategory(
          category: category,
        ),
      ),
    );
    if (updatedCategory != null) {
      setState(() {
        categoriesList[index] = updatedCategory;
        Categories.saveToFirestore(categoriesList);
      });
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
        title: Text('Edit Category'),
      ),
      body: Stack(
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: categoriesList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.white,
                            elevation: 2.0,
                            shadowColor: Colors.black,
                            surfaceTintColor: Colors.white,
                            child: ListTile(
                              trailing: IconButton(
                                onPressed: () => navigateToEditCategory(
                                    categoriesList[index], index),
                                icon: Icon(
                                  Icons.edit,
                                ),
                              ),
                              leading: Image.network(
                                categoriesList[index].image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(categoriesList[index].name),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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


// import 'package:flutter/material.dart';
// import 'package:sweet_shop/models/categories.dart';

// class EditCategoryscreen extends StatefulWidget {
//   const EditCategoryscreen({super.key});

//   @override
//   State<EditCategoryscreen> createState() => _EditCategoryscreenState();
// }

// class _EditCategoryscreenState extends State<EditCategoryscreen> {
//   List<Categories> addCat = [];
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
//       addCat = temp;
//       isLoading = false;
//     });
//   }

//   editCategory(int index) async {
//     await Categories.deleteCategoryFromFirestore(addCat[index]);

//     setState(() {
//       addCat.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Remove Category'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: addCat.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   trailing: IconButton(
//                     onPressed: () => editCategory(index),
//                     icon: Icon(
//                       Icons.edit,
//                     ),
//                   ),
//                   leading: Image.network(
//                     addCat[index].image,
//                     width: 50,
//                     height: 50,
//                     fit: BoxFit.cover,
//                   ),
//                   title: Text(addCat[index].name),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
