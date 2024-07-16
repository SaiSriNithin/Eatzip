import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sweet_shop/models/cart_model.dart';
import 'package:sweet_shop/models/sweet_model.dart';
import 'package:sweet_shop/screens/cart_screen.dart';
import 'package:sweet_shop/widgets/new_sweet_to_cart.dart';

class SweetCard extends StatefulWidget {
  final Sweet sweetvar;
  final bool incart;
  const SweetCard({super.key, required this.sweetvar, required this.incart});

  @override
  State<SweetCard> createState() => _SweetCardState();
}

class _SweetCardState extends State<SweetCard> {
  late User? user;
  late bool alreadyInCart;
  late Cart cartobj;

  @override
  void initState() {
    super.initState();
    call();
    // getUser();
  }

  call() {
    setState(() {
      alreadyInCart = widget.incart;
      debugPrint(alreadyInCart.toString());
      debugPrint("Hiiiiiiii");
      debugPrint(widget.incart.toString());
    });
  }

  // Future<void> getUser() async {
  //   User? currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser != null) {
  //     setState(() {
  //       user = currentUser;
  //     });
  //     await getInCart();
  //   }
  // }

  // This below function can cause performance drops it will execute for each and every product
  // Solution : call loadListFromFirestore in the sweets_screen that will load only once that makes easier. to check wether it is presnt in cart or not use conditional rendering concept in list view builder and pass inCart true or false to this sweet card

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

  void _openAddSweetOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(ctx).size.height * 0.35,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          child: NewSweetToCart(
            sweetvar: widget.sweetvar,
            onCartStatusChanged: (status) {
              setState(() {
                alreadyInCart = status;
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  child: Image.network(
                    widget.sweetvar.image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      widget.sweetvar.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '₹${widget.sweetvar.price}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          !alreadyInCart
                              ? OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(60, 30),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    side: const BorderSide(color: Colors.red),
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: _openAddSweetOverlay,
                                  child: const Text(
                                    'Buy Now',
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CartScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'View Cart',
                                    style: TextStyle(color: Colors.white),
                                  ),
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
    );
  }
}
