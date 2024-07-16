import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop/models/cart_model.dart';
import 'package:sweet_shop/models/categories.dart';
import 'package:sweet_shop/screens/sweets_screen.dart';
import 'package:sweet_shop/widgets/coursel.dart';
import 'package:sweet_shop/widgets/homebutton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Categories> totallist = [];
  List<Cart> CartItems = [];
  bool isLoading = false;
  User? user;

  @override
  void initState() {
    super.initState();
    loadCategories();
    getUser();
  }

  Future<void> getUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        user = currentUser;
      });
    }
  }

  loadCategories() async {
    setState(() {
      isLoading = true;
    });
    List<Categories> temp = await Categories.loadFromFirestore();
    // List<Cart> temp2 = await Cart.loadListFromFirestore(currentUser!.uid);

    setState(() {
      totallist = temp;
      // CartItems = temp2;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 5,
        toolbarHeight: MediaQuery.of(context).size.height / 9,
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome,",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '${user?.displayName}',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 144, 38, 31),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        leadingWidth: double.infinity,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today\'s Special',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 200, // Adjust the height as per your requirement
                child: ComplicatedImageDemo(),
              ),
              const Text(
                'Categories',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
              ),
              GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  childAspectRatio: 3 / 3.2,
                ),
                itemCount: totallist.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => HomeButton(
                  image: totallist[index].image,
                  imgName: totallist[index].name,
                  functionpg: SweetsScreen(
                    sweetslist: totallist[index].categorysweets,
                    categoryname: totallist[index].name,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
