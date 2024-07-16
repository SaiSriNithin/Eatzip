// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:sweet_shop/models/sweet_model.dart';

class Categories {
  final String id;
  final String name;
  final String image;
  List<Sweet> categorysweets;
  Categories({
    required this.id,
    required this.name,
    required this.image,
    required this.categorysweets,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'image': image,
      'categorysweets': categorysweets.map((x) => x.toMap()).toList(),
    };
  }

  Future<Categories> createNewCategoryFirestore(
      String categoryName, Uint8List categoryImage) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('categories/$categoryName.jpg');
      await storageRef.putData(categoryImage);
      final imageUrl = await storageRef.getDownloadURL();

      var createdDoc =
          await FirebaseFirestore.instance.collection('categories').add({
        'name': categoryName,
        'image': imageUrl,
        'categorysweets': [],
      });

      return Categories(
          id: createdDoc.id,
          name: categoryName,
          image: imageUrl,
          categorysweets: categorysweets);
    } catch (e) {
      debugPrint("Error creating new category: $e");
      rethrow; // Optionally rethrow the error if you want it to propagate
    }
  }

  static Future<void> saveToFirestore(List<Categories> categories) async {
    try {
      final batch = FirebaseFirestore.instance.batch();

      for (var category in categories) {
        final docRef = FirebaseFirestore.instance
            .collection('categories')
            .doc(category.id);
        batch.set(docRef, category.toMap());
      }

      await batch.commit();
      debugPrint("Categories successfully saved to Firestore.");
    } catch (e) {
      debugPrint("Error saving categories to Firestore: $e");
      rethrow;
    }
  }

  static Future<List<Categories>> loadFromFirestore() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Categories(
          id: doc.id,
          name: data['name'],
          image: data['image'],
          categorysweets: List<Sweet>.from(
            (data['categorysweets'] as List<dynamic>).map<Sweet>(
              (x) => Sweet.fromMap(x as Map<String, dynamic>),
            ),
          ),
        );
      }).toList();
    } catch (e) {
      debugPrint("Error loading categories from Firestore: $e");
      rethrow;
    }
  }

  static Future<void> addSweetToCategory(String id, Sweet newsweet) async {
    try {
      final querySnapshot =
          FirebaseFirestore.instance.collection('categories').doc(id);
      final storageRef = FirebaseStorage.instance.ref().child('sweets/$id.jpg');
      await storageRef.putData(base64Decode(newsweet.image));
      final imageUrl = await storageRef.getDownloadURL();
      await querySnapshot.update({
        'categorysweets': FieldValue.arrayUnion([
          {
            'id': newsweet.id,
            'name': newsweet.name,
            'price': newsweet.price,
            'image': imageUrl,
            'avalibility': true,
          }
        ])
      });
    } catch (e) {
      debugPrint("Error adding sweet to category: $e");
    }
  }

  static Future<void> deleteCategoryFromFirestore(Categories cat) async {
    try {
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(cat.id)
          .delete()
          .then(
            (doc) => debugPrint("Document deleted"),
            onError: (e) => debugPrint("Error deleting document: $e"),
          );

      final storageRef =
          FirebaseStorage.instance.ref().child('categories/${cat.name}.jpg');
      await storageRef.delete();
    } catch (e) {
      debugPrint("Error deleting category: $e");
    }
  }

  static Future<void> deleteSweetForSpecificCategoryFromFirestore(
      Categories cat, String sweetId) async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection("categories").doc(cat.id);
      final doc = await docRef.get();
      if (doc.exists) {
        List<Sweet> sweets = List<Sweet>.from(
          (doc.data()!['categorysweets'] as List<dynamic>).map<Sweet>(
            (x) => Sweet.fromMap(x as Map<String, dynamic>),
          ),
        );

        sweets.removeWhere((sweet) => sweet.id == sweetId);

        await docRef.update({
          'categorysweets': sweets.map((x) => x.toMap()).toList(),
        });

        debugPrint("Sweet removed from category");
      } else {
        debugPrint("Category not found");
      }
    } catch (e) {
      debugPrint("Error removing sweet from category: $e");
    }
  }
}



// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sweet_shop/models/sweet_model.dart';

// // removed final infront of categorysweet for edit_sweetscreen.dart &remove_screen.dart.
// class Categories {
//   final String name;
//   final Uint8List image;
//   List<Sweet> categorysweets;

//   Categories({
//     required this.name,
//     required this.image,
//     List<Sweet>? categorysweets,
//   }) : categorysweets = categorysweets ?? [];

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'name': name,
//       'image': base64Encode(image),
//       'categorysweets': categorysweets.map((x) => x.toMap()).toList(),
//     };
//   }

//   factory Categories.fromMap(Map<String, dynamic> map) {
//     return Categories(
//       name: map['name'] as String,
//       image: base64Decode(map['image'] as String),
//       categorysweets: List<Sweet>.from(
//         (map['categorysweets'] as List<dynamic>).map<Sweet>(
//           (x) => Sweet.fromMap(x as Map<String, dynamic>),
//         ),
//       ),
//     );
//   }

  // static Future<void> saveListToLocalStorage(
  //     List<Categories> list, String key) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final encodedList = list.map((x) => x.toMap()).toList();
  //   prefs.setString(key, jsonEncode(encodedList));
  // }

  // static Future<List<Categories>> loadListFromLocalStorage(String key) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final jsonString = prefs.getString(key);
  //   if (jsonString != null) {
  //     final decodedList = jsonDecode(jsonString) as List<dynamic>;
  //     return decodedList
  //         .map((map) => Categories.fromMap(map as Map<String, dynamic>))
  //         .toList();
  //   }
  //   return [];
//   }

// // instaed of id i have given parameter as name
  // static Future<void> deleteCategoryFromLocalStorage(
  //     String key, String name) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final jsonString = prefs.getString(key);
  //   if (jsonString != null) {
  //     final decodedList = jsonDecode(jsonString) as List<dynamic>;
  //     final updatedList = decodedList
  //         .where((map) => (map as Map<String, dynamic>)['name'] != name)
  //         .toList();
  //     prefs.setString(key, jsonEncode(updatedList));
  //   }
//   }

//   String toJson() => json.encode(toMap());

//   factory Categories.fromJson(String source) =>
//       Categories.fromMap(json.decode(source) as Map<String, dynamic>);
// }





// Categories({
//     required this.name,
//     required this.image,
//     List<Sweet>? categorysweets,
//   }) : categorysweets = categorysweets ?? [];

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'image': base64Encode(image),
//       'categorysweets': categorysweets.map((x) => x.toMap()).toList(),
//     };
//   }

//   factory Categories.fromMap(Map<String, dynamic> map) {
//     return Categories(
//       name: map['name'] as String,
//       image: base64Decode(map['image'] as String),
//       categorysweets: List<Sweet>.from(
//         (map['categorysweets'] as List<dynamic>).map<Sweet>(
//           (x) => Sweet.fromMap(x as Map<String, dynamic>),
//         ),
//       ),
//     );
//   }

  // static Future<void> saveToFirestore(Categories category) async {
  //   final storageRef =
  //       FirebaseStorage.instance.ref().child('categories/${category.name}.jpg');
  //   await storageRef.putData(category.image);
  //   final imageUrl = await storageRef.getDownloadURL();

  //   await FirebaseFirestore.instance.collection('categories').add({
  //     'name': category.name,
  //     'image': imageUrl,
  //     'categorysweets': category.categorysweets.map((x) => x.toMap()).toList(),
  //   });
  // }




  // static Future<List<Categories>> loadFromFirestore() async {
  //   final querySnapshot =
  //       await FirebaseFirestore.instance.collection('categories').get();
  //   return querySnapshot.docs.map((doc) {
  //     final data = doc.data();
  //     final Uint8List imageData = base64Decode(data['image']);
  //     return Categories(
  //       name: data['name'],
  //       image: imageData,
  //       categorysweets: List<Sweet>.from(
  //         (data['categorysweets'] as List<dynamic>).map<Sweet>(
  //           (x) => Sweet.fromMap(x as Map<String, dynamic>),
  //         ),
  //       ),
  //     );
  //   }).toList();
  // }

