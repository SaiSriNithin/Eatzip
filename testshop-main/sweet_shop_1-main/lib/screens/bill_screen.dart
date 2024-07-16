import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop/models/cart_model.dart';
import 'package:sweet_shop/screens/myorders.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  List<Cart> inCart = [];
  double sum = 0.0;
  bool isLoading = false;
  bool orderPlacing = false;
  User? user;
  String? userAddress;
  String? userPhoneNumber;

  bool isOrdered = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        user = currentUser;
      });
      // Fetch additional user details from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      setState(() {
        userAddress = userDoc['address'];
        userPhoneNumber = userDoc['phoneNumber'];
      });
      // Load cart after user details are set
      await loadcart();
    }
  }

  Future<void> loadcart() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Cart> temp = await Cart.loadListFromFirestore(user!.uid);
      setState(() {
        inCart = temp;
        calculateTotalPrice(inCart);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading cart items: $e');
    }
  }

  void calculateTotalPrice(List<Cart> cartItems) {
    sum = cartItems.fold(
      0,
      (total, cartItem) =>
          total +
          ((cartItem.sweetcart.price) *
              (cartItem.quantity) *
              (cartItem.weight / 250)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    inCart[index].sweetcart.image,
                                    fit: BoxFit.cover,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      inCart[index].sweetcart.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      '₹${inCart[index].sweetcart.price * inCart[index].quantity * (inCart[index].weight / 250)}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${inCart[index].quantity * inCart[index].weight / 1000} Kg',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        orderPlacing = true;
                      });
                      bool x = await Cart.addToBuyMow(inCart, user!.uid);
                      if (x) {
                        setState(() {
                          orderPlacing = true;
                        });
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Myorders(inCartt: inCart)),
                          (route) => false,
                        );
                      }
                    },
                    child: orderPlacing
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : const Text('Place Order'),
                  ),
                ),
              ],
            ),
    );
  }
}
