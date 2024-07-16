import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop/models/cart_model.dart';
import 'package:sweet_shop/widgets/prevOrderdetailsCard.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<OrderMOdel> inCart = [];
  double sum = 0.0;
  bool isLoading = false;
  User? user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      user = currentUser;
      loadcart();
    }
  }

  loadcart() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<OrderMOdel> temp = await OrderMOdel.getOrders(user!.uid);
      print(temp);
      setState(() {
        inCart = OrderMOdel.sortOrdersByDate(temp);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OrderScreen'),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: inCart.length,
                  itemBuilder: (context, index) => PrevOrderDetailsCard(
                        onOrderComplete: () {},
                        order: inCart[index],
                        adminSide: false,
                      )))
        ],
      ),
    );
  }
}
