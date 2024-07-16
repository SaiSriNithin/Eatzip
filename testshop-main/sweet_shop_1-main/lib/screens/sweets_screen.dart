import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop/models/cart_model.dart';
import 'package:sweet_shop/models/sweet_model.dart';
import 'package:sweet_shop/widgets/sweet_card.dart';

class SweetsScreen extends StatefulWidget {
  const SweetsScreen({
    super.key,
    required this.sweetslist,
    required this.categoryname,
  });

  final List<Sweet> sweetslist;
  final String categoryname;

  @override
  State<SweetsScreen> createState() => _SweetsScreenState();
}

class _SweetsScreenState extends State<SweetsScreen> {
  List<Sweet> searchList = [];
  List<Cart> inCart = [];
  User? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    searchList = widget.sweetslist;
    getUser();
  }

  Future<void> getUser() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await getCarts();
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> getCarts() async {
    if (user != null) {
      List<Cart> temp = await Cart.loadListFromFirestore(user!.uid);
      debugPrint(temp.toString());
      setState(() {
        inCart = temp;
      });
    }
  }

  bool getInCart(Sweet sweet) {
    if (user != null) {
      List<Cart> nithin =
          inCart.where((element) => element.sweetcart.id == sweet.id).toList();
      return nithin.isNotEmpty;
    }
    return false;
  }

  void filterSearchResults(String enteredKeyword) {
    List<Sweet> results = [];
    if (enteredKeyword.isEmpty) {
      results = widget.sweetslist;
    } else {
      results = widget.sweetslist
          .where((test) =>
              test.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      searchList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryname),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      filterSearchResults(value);
                    },
                    decoration: const InputDecoration(
                      labelText: "Search",
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: searchList.length,
                    itemBuilder: (context, index) {
                      Sweet sweetvar = searchList[index];

                      return SweetCard(
                        sweetvar: sweetvar,
                        incart: getInCart(sweetvar),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
