import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:sweet_shop/screens/cart_screen.dart';
import 'package:sweet_shop/screens/home_screen.dart';
import 'package:sweet_shop/screens/orders_screen.dart';
import 'package:sweet_shop/screens/profile_screen.dart';

enum _SelectedTab { home, favorite, add, search, person }

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  var _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  final screens = [
    const HomeScreen(),
    const CartScreen(),
    const OrderScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final items = [
      CrystalNavigationBarItem(
        icon: IconlyBold.home,
        unselectedIcon: IconlyLight.home,
        selectedColor: Colors.white,
      ),
      CrystalNavigationBarItem(
        icon: Icons.shopping_cart,
        unselectedIcon: Icons.shopping_cart_outlined,
        selectedColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      CrystalNavigationBarItem(
          icon: IconlyBold.paper_plus,
          unselectedIcon: IconlyLight.paper_plus,
          selectedColor: Colors.white),
      CrystalNavigationBarItem(
        icon: IconlyBold.user_2,
        unselectedIcon: IconlyLight.user,
        selectedColor: Colors.white,
      ),
    ];
    return Scaffold(
      extendBody: true,
      body: screens[_SelectedTab.values.indexOf(_selectedTab)],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: CrystalNavigationBar(
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          itemPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          height: 10,
          //enableFloatingNavBar: false,
          //indicatorColor: Colors.blue,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.black.withOpacity(0.5),
          onTap: _handleIndexChanged,
          items: items,
        ),
      ),
    );
  }
}
