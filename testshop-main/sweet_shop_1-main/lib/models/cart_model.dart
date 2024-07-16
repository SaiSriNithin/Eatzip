// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'sweet_model.dart';

class Cart {
  int quantity;
  final Sweet sweetcart;
  int weight;

  Cart({
    required this.quantity,
    required this.sweetcart,
    required this.weight,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quantity': quantity,
      'sweetcart': sweetcart.toMap(),
      'weight': weight,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      quantity: map['quantity'] as int,
      sweetcart: Sweet.fromMap(map['sweetcart'] as Map<String, dynamic>),
      weight: map['weight'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) =>
      Cart.fromMap(json.decode(source) as Map<String, dynamic>);

  static Future<List<Cart>> loadListFromFirestore(String userId) async {
    print("Hiiiiiiiiii");
    var snapshot =
        await FirebaseFirestore.instance.collection('carts').doc(userId).get();

    if (snapshot.exists && snapshot.data() != null) {
      var data = snapshot.data() as Map<String, dynamic>;
      var cartItems = data['cartItems'] as List<dynamic>;
      return cartItems.map((item) => Cart.fromMap(item)).toList();
    } else {
      return [];
    }
  }

  static Future<void> saveListToFirestore(Cart newItem, String userId) async {
    var cartItemsRef =
        FirebaseFirestore.instance.collection('carts').doc(userId);
    print(userId);
    await cartItemsRef.update({
      "cartItems": FieldValue.arrayUnion([newItem.toMap()]),
    });
  }

  static Future<void> updateCartItemsFirestore(
      List<Cart> newItemList, String userId) async {
    var cartItemsRef =
        FirebaseFirestore.instance.collection('carts').doc(userId);
    print(userId);
    // Convert each Cart object to a map
    var itemListAsMaps = newItemList.map((item) => item.toMap()).toList();
    await cartItemsRef.update({"cartItems": itemListAsMaps});
  }

  static Future<bool> addToBuyMow(List<Cart> cartItems, String userId) async {
    try {
      print("hhhhhhhhhhhiiiiiiiiiiiiiii");

      String todayDate = DateTime.now().toIso8601String();
      var orderRef = FirebaseFirestore.instance.collection('orders');

      var user = FirebaseFirestore.instance.collection('users').doc(userId);

      DocumentSnapshot userSnapshot = await user.get();
      if (userSnapshot.exists) {
        var userData = userSnapshot.data() as Map<String, dynamic>;
        print(userData);
        for (var cartItem in cartItems) {
          OrderMOdel order = OrderMOdel(
              uid: userId,
              customerName: userData['displayName'],
              phoneNo: userData['phoneNumber'],
              address: userData['address'],
              quantity: cartItem.quantity,
              sweetcart: cartItem.sweetcart,
              weight: cartItem.weight,
              date: todayDate,
              status: "Not delivered");

          await orderRef.add(order.toMap());
        }
      }
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(userId)
          .update({"cartItems": []});

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

class OrderMOdel {
  String? id;
  String customerName;
  String uid;
  String phoneNo;
  String address;
  int quantity;
  final Sweet sweetcart;
  int weight;
  String date;
  String status;
  OrderMOdel({
    this.id,
    required this.customerName,
    required this.uid,
    required this.phoneNo,
    required this.address,
    required this.quantity,
    required this.sweetcart,
    required this.weight,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'customerName': customerName,
      'uid': uid,
      'phoneNo': phoneNo,
      'address': address,
      'quantity': quantity,
      'sweetcart': sweetcart.toMap(),
      'weight': weight,
      'date': date,
      'status': status,
    };
  }

  factory OrderMOdel.fromMap(Map<String, dynamic> map) {
    return OrderMOdel(
      id: map['id'] as String,
      customerName: map['customerName'] as String,
      uid: map['uid'] as String,
      phoneNo: map['phoneNo'] as String,
      address: map['address'] as String,
      quantity: map['quantity'] as int,
      sweetcart: Sweet.fromMap(map['sweetcart'] as Map<String, dynamic>),
      weight: map['weight'] as int,
      date: map['date'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderMOdel.fromJson(String source) =>
      OrderMOdel.fromMap(json.decode(source) as Map<String, dynamic>);

  static Future<List<OrderMOdel>> getOrders(String userId) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('uid', isEqualTo: userId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Set the id to doc.id
        return OrderMOdel.fromMap(data);
      }).toList();
    } else {
      return [];
    }
  }

  static Future<List<OrderMOdel>> getAllPendingOrders() async {
    print("7989833031");
    var snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: "Not delivered")
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Set the id to doc.id
        return OrderMOdel.fromMap(data);
      }).toList();
    } else {
      return [];
    }
  }

  static Future<List<OrderMOdel>> getAllCompletedOrders() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('status', isNotEqualTo: "Not delivered")
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Set the id to doc.id
        return OrderMOdel.fromMap(data);
      }).toList();
    } else {
      return [];
    }
  }

  static Future<bool> markOrderComplete(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': 'Delivered'});

      return true;
    } catch (e) {
      print("Error updating order: $e");
      return false;
    }
  }

  static List<OrderMOdel> sortOrdersByDate(List<OrderMOdel> orders) {
    orders.sort((a, b) => b.date.compareTo(a.date));
    return orders;
  }
}
