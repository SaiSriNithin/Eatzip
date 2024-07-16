import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop/models/cart_model.dart';
import 'package:sweet_shop/widgets/prevOrderdetailsCard.dart';

class OrdersScreen extends StatefulWidget {
  final bool isPendingOrders;
  const OrdersScreen({super.key, required this.isPendingOrders});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<OrderMOdel> inCart = [];
  double sum = 0.0;
  bool isLoading = false;
  User? user;

  @override
  void initState() {
    super.initState();
    loadcart();
  }

  // Future<void> getUser() async {
  //   User? currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser != null) {
  //     user = currentUser;
  //     loadcart();
  //   }
  // }

  loadcart() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<OrderMOdel> temp = [];
      if (widget.isPendingOrders) {
        temp = await OrderMOdel.getAllPendingOrders();
      } else {
        temp = await OrderMOdel.getAllCompletedOrders();
      }
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
        title: widget.isPendingOrders
            ? Text('Pending Orders')
            : Text('Compleated Orders'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: inCart.length,
                        itemBuilder: (context, index) => PrevOrderDetailsCard(
                              onOrderComplete: () {
                                setState(() {
                                  inCart.removeAt(index);
                                });
                              },
                              order: inCart[index],
                              adminSide: true,
                            )))
              ],
            ),
    );
  }
}
