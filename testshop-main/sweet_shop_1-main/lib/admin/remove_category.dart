import 'package:flutter/material.dart';
import 'package:sweet_shop/models/categories.dart';

class RemoveCategory extends StatefulWidget {
  const RemoveCategory({super.key});

  @override
  State<RemoveCategory> createState() => _RemoveCategoryState();
}

class _RemoveCategoryState extends State<RemoveCategory> {
  List<Categories> addCat = [];
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
      addCat = temp;
      isLoading = false;
    });
  }

  deleteFromCategory(int index) async {
    await Categories.deleteCategoryFromFirestore(addCat[index]);

    setState(() {
      addCat.removeAt(index);
    });
  }

  // loadCategories() async {
  //   List<Categories> temp = [];
  //   temp = await Categories.loadListFromLocalStorage('category1');
  //   setState(() {
  //     addCat = temp;
  //   });
  // }

  // deleteFromCategory(int index) async {
  //   setState(() {
  //     addCat.removeAt(index);
  //   });
  //   await Categories.saveListToLocalStorage(addCat, "category1");
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
        title: Text('Remove Category'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: addCat.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  shadowColor: Colors.black,
                  elevation: 2.0,
                  surfaceTintColor: Colors.white,
                  child: ListTile(
                    trailing: IconButton(
                      onPressed: () => deleteFromCategory(index),
                      icon: Icon(
                        Icons.delete,
                      ),
                    ),
                    leading: Image.network(
                      addCat[index].image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(addCat[index].name),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
