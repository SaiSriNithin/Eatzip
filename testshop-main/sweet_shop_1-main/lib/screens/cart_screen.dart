import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop/models/cart_model.dart';
import 'package:sweet_shop/screens/bill_screen.dart';
import 'package:sweet_shop/screens/profile_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> inCart = [];
  User? user;
  String userphno = "";
  String address = "";

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      user = currentUser;
      loadCart();
    }

    ;

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    if (userSnapshot.exists) {
      var userData = userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        userphno = userData['phoneNumber'];
        address = userData['address'];
      });
    }
  }

  Future<void> loadCart() async {
    if (user != null) {
      List<Cart> temp = await Cart.loadListFromFirestore(user!.uid);

      setState(() {
        inCart = temp;
      });
    }
  }

  Future<void> saveCart() async {
    print(user);
    if (user != null) {
      await Cart.updateCartItemsFirestore(inCart, user!.uid);
    }
  }

  void increment(int index) async {
    setState(() {
      inCart[index].quantity++;
    });
    await saveCart();
  }

  void decrement(int index) async {
    setState(() {
      if (inCart[index].quantity > 1) {
        inCart[index].quantity--;
      } else {
        inCart.removeAt(index);
      }
    });
    await saveCart();
  }

  Future<void> _showPhoneNumberDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No address or phone number"),
          content:
              Text("Do you want to update your phone number and address ?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            onPressed: () {
              if (address != "" && userphno != "") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BillScreen()),
                );
              } else {
                _showPhoneNumberDialog();
              }
            },
            child: Text(
              'Buy Now',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: inCart.length,
              itemBuilder: (context, index) => SizedBox(
                height: MediaQuery.of(context).size.height / 5.7,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(inCart[index].sweetcart.image),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    inCart[index].sweetcart.name,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '₹${inCart[index].sweetcart.price * inCart[index].quantity * (inCart[index].weight / 250)}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '${inCart[index].quantity * inCart[index].weight / 1000} Kg',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            decrement(index);
                                          },
                                          icon: Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                          ),
                                        ),
                                        Text(inCart[index].quantity.toString()),
                                        IconButton(
                                          onPressed: () {
                                            increment(index);
                                          },
                                          icon: Icon(
                                            Icons.add_circle,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
