// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop/models/cart_model.dart';
import 'package:sweet_shop/models/sweet_model.dart';

class NewSweetToCart extends StatefulWidget {
  final Sweet sweetvar;
  final Function(bool) onCartStatusChanged;

  const NewSweetToCart({
    super.key,
    required this.sweetvar,
    required this.onCartStatusChanged,
  });

  @override
  State<NewSweetToCart> createState() => _NewSweetToCartState();
}

class _NewSweetToCartState extends State<NewSweetToCart> {
  int _selectedWeight = 250;
  bool alreadyInCart = false;
  late Cart cartobj;
  late User? user;
  int quantity = 1;

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
      // await getInCart();
    }
  }

  // Future<void> getInCart() async {
  //   if (user != null) {
  //     List<Cart> temp = await Cart.loadListFromFirestore(user!.uid);
  //     setState(() {
  //       List<Cart> nithin = temp
  //           .where((element) => element.sweetcart.id == widget.sweetvar.id)
  //           .toList();
  //       alreadyInCart = nithin.isNotEmpty;

  //       if (alreadyInCart) {
  //         cartobj = nithin[0];
  //       } else {
  //         cartobj = Cart(
  //           quantity: 1,
  //           weight: 250,
  //           sweetcart: Sweet(
  //             id: widget.sweetvar.id,
  //             image: widget.sweetvar.image,
  //             name: widget.sweetvar.name,
  //             price: widget.sweetvar.price,
  //             avalibility: widget.sweetvar.avalibility,
  //           ),
  //         );
  //       }
  //     });
  //   }
  // }

  void addToCart(Sweet cart) async {
    // Update local state first
    setState(() {
      alreadyInCart = true;
    });
    Cart.saveListToFirestore(
        Cart(quantity: quantity, weight: _selectedWeight, sweetcart: cart),
        user!.uid);
    // getInCart();
    // Notify parent widget
    widget.onCartStatusChanged(true);
  }

  void increment() async {
    setState(() {
      quantity = quantity + 1;
    });
  }

  void decrement() async {
    if (quantity > 1) {
      setState(() {
        quantity = quantity - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(widget.sweetvar.image),
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Text(
                widget.sweetvar.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '₹${widget.sweetvar.price * _selectedWeight * quantity / 250}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Radio<int>(
                    value: 250,
                    groupValue: _selectedWeight,
                    onChanged: (value) {
                      setState(() {
                        _selectedWeight = value!;
                      });
                    },
                  ),
                  const Text('250g'),
                  Radio<int>(
                    value: 500,
                    groupValue: _selectedWeight,
                    onChanged: (value) {
                      setState(() {
                        _selectedWeight = value!;
                      });
                    },
                  ),
                  const Text('500g'),
                  Radio<int>(
                    value: 1000,
                    groupValue: _selectedWeight,
                    onChanged: (value) {
                      setState(() {
                        _selectedWeight = value!;
                      });
                    },
                  ),
                  const Text('1kg'),
                ],
              ),
              Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: decrement,
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        onPressed: () {
                          increment();
                        },
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  alreadyInCart
                      ? OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(60, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: const BorderSide(color: Colors.lightGreen),
                            backgroundColor: Colors.lightGreen,
                          ),
                          onPressed: () {
                            addToCart(widget.sweetvar);
                          },
                          child: const Text(
                            'Added to Cart',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(60, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: const BorderSide(color: Colors.red),
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            addToCart(widget.sweetvar);
                          },
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
