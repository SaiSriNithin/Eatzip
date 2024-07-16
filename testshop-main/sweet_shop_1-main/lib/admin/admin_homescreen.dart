import 'package:flutter/material.dart';
import 'package:sweet_shop/admin/add_category.dart';
import 'package:sweet_shop/admin/add_sweet.dart';
import 'package:sweet_shop/admin/AdminImageUploadScreen.dart';
import 'package:sweet_shop/admin/edit_categoryscreen.dart';
import 'package:sweet_shop/admin/edit_sweetscreen.dart';
import 'package:sweet_shop/admin/homebutton_admin.dart';
import 'package:sweet_shop/admin/orders.dart';
import 'package:sweet_shop/admin/remove_category.dart';
import 'package:sweet_shop/admin/remove_coursel_img.dart';
import 'package:sweet_shop/admin/remove_sweet.dart';
import 'package:sweet_shop/screens/login_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, Admin\nWelcome'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              AdminHomebutton(
                Name: 'Add category',
                functionpg: AddCategory(),
              ),
              AdminHomebutton(
                Name: 'Remove category',
                functionpg: RemoveCategory(),
              ),
              AdminHomebutton(
                Name: 'Edit category',
                functionpg: EditCategoryScreen(),
              ),
              AdminHomebutton(
                Name: 'Add Sweet',
                functionpg: AddSweet(),
              ),
              AdminHomebutton(
                Name: 'Remove Sweet',
                functionpg: RemoveSweet(),
              ),
              AdminHomebutton(
                Name: 'Edit Sweet',
                functionpg: EditSweetScreen(),
              ),
              AdminHomebutton(
                Name: 'Coursel Images Upload',
                functionpg: AdminImageUploadScreen(),
              ),
              AdminHomebutton(
                Name: 'Coursel Images Deleting',
                functionpg: RemoveCourselImg(),
              ),
              AdminHomebutton(
                Name: 'Pending Orders',
                functionpg: OrdersScreen(
                  isPendingOrders: true,
                ),
              ),
              AdminHomebutton(
                Name: 'Compleated Orders',
                functionpg: OrdersScreen(
                  isPendingOrders: false,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:sweet_shop/admin/add_category.dart';
// import 'package:sweet_shop/admin/add_sweet.dart';
// import 'package:sweet_shop/admin/AdminImageUploadScreen.dart';
// import 'package:sweet_shop/admin/edit_categoryscreen.dart';
// import 'package:sweet_shop/admin/edit_sweetscreen.dart';
// import 'package:sweet_shop/admin/homebutton_admin.dart';
// import 'package:sweet_shop/admin/orders.dart';
// import 'package:sweet_shop/admin/remove_category.dart';
// import 'package:sweet_shop/admin/remove_sweet.dart';
// import 'package:sweet_shop/screens/login_screen.dart';

// class AdminHomeScreen extends StatefulWidget {
//   const AdminHomeScreen({super.key});

//   @override
//   State<AdminHomeScreen> createState() => _AdminHomeScreenState();
// }

// class _AdminHomeScreenState extends State<AdminHomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Hello,Admin\nWelcome'),
//         elevation: 2,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: GridView(
//               padding: const EdgeInsets.all(3),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 childAspectRatio: 3 / 3,
//               ),
//               children: const [
//                 AdminHomebutton(
//                   Name: 'Add category',
//                   functionpg: AddCategory(),
//                 ),
//                 AdminHomebutton(
//                   Name: 'Remove category',
//                   functionpg: RemoveCategory(),
//                 ),
//                 AdminHomebutton(
//                   Name: 'edit category',
//                   functionpg: EditCategoryScreen(),
//                 ),
//                 AdminHomebutton(
//                   Name: 'Add Sweet',
//                   functionpg: AddSweet(),
//                 ),
//                 AdminHomebutton(
//                   Name: 'Remove sweet',
//                   functionpg: RemoveSweet(),
//                 ),
//                 AdminHomebutton(
//                   Name: 'edit sweet',
//                   functionpg: EditSweetScreen(),
//                 ),
//                 AdminHomebutton(
//                     Name: 'Coursel images upload',
//                     functionpg: AdminImageUploadScreen()),
//                 AdminHomebutton(
//                   Name: 'Orders',
//                   functionpg: Orders(),
//                 ),
//               ],
//             ),
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (context) => LoginScreen(),
//                   ),
//                 );
//               },
//               child: Text('logout'))
//         ],
//       ),
//     );
//   }
// }
