import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop/models/cart_model.dart';
import 'package:sweet_shop/widgets/navbar.dart';

class Myorders extends StatefulWidget {
  final List<Cart> inCartt;
  const Myorders({super.key, required this.inCartt});

  @override
  State<Myorders> createState() => _MyordersState();
}

class _MyordersState extends State<Myorders> {
  double sum = 0.0;
  bool isLoading = false;
  User? user;

  @override
  void initState() {
    super.initState();
  }

  calculateTotalPrice(List<Cart> cartItems) {
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Placed Order Details'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.inCartt.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    leading: ClipOval(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 7,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                '${widget.inCartt[index].sweetcart.image}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                        '${widget.inCartt[index].sweetcart.name}(${widget.inCartt[index].quantity * widget.inCartt[index].weight / 1000} Kgs)'),
                    trailing: Text(
                      '₹${widget.inCartt[index].sweetcart.price * widget.inCartt[index].quantity * (widget.inCartt[index].weight / 250)}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Navbar(),
                    ),
                  );
                },
                child: Text('Go to Homepage'))
          ],
        ),
      ),
    );
  }
}
