import 'package:flutter/material.dart';
import 'package:sweet_shop/models/categories.dart';
import 'package:sweet_shop/models/sweet_model.dart';

class RemoveSweet extends StatefulWidget {
  const RemoveSweet({super.key});

  @override
  State<RemoveSweet> createState() => _RemoveSweetState();
}

class _RemoveSweetState extends State<RemoveSweet> {
  List<Categories> addCat = [];
  Categories? _selectedItem;
  List<Sweet> _sweets = [];
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
        title: Text('Remove Sweet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
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
                  setState(() {
                    _selectedItem = newValue;
                    _sweets = newValue?.categorysweets ?? [];
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _sweets.length,
                itemBuilder: (context, index) {
                  final sweet = _sweets[index];
                  return Card(
                    color: Colors.white,
                    elevation: 2.0,
                    shadowColor: Colors.black,
                    surfaceTintColor: Colors.white,
                    child: ListTile(
                      title: Text(sweet.name),
                      subtitle: Text('Price: \$${sweet.price}'),
                      // ignore: unnecessary_null_comparison
                      leading: sweet.image != null
                          ? Image.network(
                              sweet.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : null,
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          removeSweet(_selectedItem!, sweet.id);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void removeSweet(Categories category, String sweetId) async {
    await Categories.deleteSweetForSpecificCategoryFromFirestore(
        category, sweetId);
    setState(() {
      category.categorysweets.removeWhere((sweet) => sweet.id == sweetId);
      _sweets.removeWhere((sweet) => sweet.id == sweetId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sweet removed successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
