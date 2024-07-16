import 'package:flutter/material.dart';
import 'package:sweet_shop/admin/editsweet.dart';
import 'package:sweet_shop/models/categories.dart';
import 'package:sweet_shop/models/sweet_model.dart';

class EditSweetScreen extends StatefulWidget {
  const EditSweetScreen({super.key});

  @override
  State<EditSweetScreen> createState() => _EditSweetScreenState();
}

class _EditSweetScreenState extends State<EditSweetScreen> {
  List<Categories> categoriesList = [];
  Categories? _selectedCategory;
  List<Sweet> sweetsList = [];
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
      categoriesList = temp;
      isloading = false;
    });
  }
  // loadCategories() async {
  //   List<Categories> temp =
  //       await Categories.loadListFromLocalStorage('category1');
  //   setState(() {
  //     categoriesList = temp;
  //   });
  // }

  void navigateToEditSweet(Sweet sweet) async {
    final updatedSweet = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSweetDetails(sweet: sweet),
      ),
    );
    if (updatedSweet != null) {
      setState(() {
        int index = sweetsList.indexWhere((s) => s.id == updatedSweet.id);
        sweetsList[index] = updatedSweet;

        // Update the selected category's sweets list
        _selectedCategory!.categorysweets = sweetsList;

        // Save the updated categories list to local storage
        //  Categories.saveListToLocalStorage(categoriesList, 'category1');
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
        title: Text('Edit Sweet'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<Categories>(
                  menuMaxHeight: 500,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  hint: Text('Select a category'),
                  value: _selectedCategory,
                  items: categoriesList.map((Categories category) {
                    return DropdownMenuItem<Categories>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (Categories? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                      sweetsList = newValue?.categorysweets ?? [];
                    });
                  },
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: sweetsList.length,
                    itemBuilder: (context, index) {
                      final sweet = sweetsList[index];
                      return Card(
                        color: Colors.white,
                        elevation: 2.0,
                        shadowColor: Colors.black,
                        surfaceTintColor: Colors.white,
                        child: ListTile(
                          title: Text(sweet.name),
                          subtitle: Text('Price: ₹${sweet.price}'),
                          // ignore: unnecessary_null_comparison
                          leading: Image.network(
                            sweet.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Error handling widget, e.g., show a placeholder or error message
                              return Icon(Icons
                                  .error); // Replace with your error handling UI
                            },
                          ),

                          trailing: Icon(Icons.edit),
                          onTap: () => navigateToEditSweet(sweet),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
