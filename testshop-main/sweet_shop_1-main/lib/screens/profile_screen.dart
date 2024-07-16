import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop/screens/login_screen.dart';
import 'package:sweet_shop/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  String? userAddress;
  String? userPhoneNumber;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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
    }
  }

  Future<void> _showPhoneNumberDialog() async {
    _phoneNumberController.text = userPhoneNumber ?? '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Phone Number"),
          content: TextField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: "Enter new phone number"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Update"),
              onPressed: () async {
                String newPhoneNumber = _phoneNumberController.text.trim();
                if (user != null && newPhoneNumber.isNotEmpty) {
                  await AuthMethod()
                      .updateUserPhoneNumber(user!.uid, newPhoneNumber);
                  setState(() {
                    userPhoneNumber = newPhoneNumber;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddressDialog() async {
    _addressController.text =
        userAddress ?? ''; // Set to the current address if available
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Address"),
          content: TextField(
            controller: _addressController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(hintText: "Enter address"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Update"),
              onPressed: () async {
                String newAddress = _addressController.text.trim();
                if (user != null && newAddress.isNotEmpty) {
                  await AuthMethod().updateUserAddress(user!.uid, newAddress);
                  setState(() {
                    userAddress = newAddress;
                  });
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 19, 79, 90),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
            child: Text('Profile', style: TextStyle(color: Colors.white))),
        backgroundColor: Color.fromARGB(255, 19, 79, 90),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          child: Container(
            height: MediaQuery.of(context).size.height - 4 * 20.8,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 60.0,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage("${user?.photoURL}")
                        : AssetImage('assets/profile.png') as ImageProvider,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Card(
                  color: Colors.white,
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Name :",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '${user?.displayName ?? '---------------'}',
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 17, 79, 90),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Email :",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '${user?.email}',
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 17, 79, 90),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Phone Number :",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${userPhoneNumber ?? '---------------'}',
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 17, 79, 90),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _showPhoneNumberDialog();
                              },
                              icon: Icon(Icons.edit),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Address:",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${userAddress ?? '---------------'}',
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 17, 79, 90),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _showAddressDialog();
                              },
                              icon: Icon(Icons.edit),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                    onPressed: () async {
                      await AuthMethod().logout();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text('Logout')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:sweet_shop/screens/login_screen.dart';
// import 'package:sweet_shop/services/authentication.dart';
// import 'package:sweet_shop/services/google_signin.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   User? user;
//   TextEditingController _phoneNumberController = TextEditingController();
//   TextEditingController _addressController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     getUser();
//   }

//   Future<void> getUser() async {
//     User? currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser != null) {
//       user = currentUser;
//     }
//   }

//   Future<void> _showPhoneNumberDialog() async {
//     _phoneNumberController.text = user?.phoneNumber ?? '';
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Edit Phone Number"),
//           content: TextField(
//             controller: _phoneNumberController,
//             keyboardType: TextInputType.phone,
//             decoration: InputDecoration(hintText: "Enter new phone number"),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text("Cancel"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text("Update"),
//               onPressed: () async {
//                 String newPhoneNumber = _phoneNumberController.text.trim();
//                 if (user != null && newPhoneNumber.isNotEmpty) {
//                   await AuthMethod()
//                       .updateUserPhoneNumber(user!.uid, newPhoneNumber);
//                   await FirebaseServices()
//                       .updateUserPhoneNumber(user!.uid, newPhoneNumber);
//                   await getUser();
//                 }
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _AddressDialog() async {
//     _phoneNumberController.text = user?.phoneNumber ?? '';
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Edit Address Number"),
//           content: TextField(
//             controller: _addressController,
//             keyboardType: TextInputType.text,
//             decoration: InputDecoration(hintText: "Enter address"),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text("Cancel"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text("Update"),
//               onPressed: () async {
//                 String newAddress = _addressController.text.trim();
//                 if (user != null && newAddress.isNotEmpty) {
//                   await AuthMethod().updateUserAddress(user!.uid, newAddress);
//                   await FirebaseServices()
//                       .updateUserAddress(user!.uid, newAddress);
//                   await getUser();
//                 }

//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 19, 79, 90),
//       appBar: AppBar(
//         title: Center(
//             child: Text('Profile', style: TextStyle(color: Colors.white))),
//         backgroundColor: Color.fromARGB(255, 19, 79, 90),
//         elevation: 0,
//       ),
//       body: ClipRRect(
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(50), topRight: Radius.circular(50)),
//         child: Container(
//           color: Colors.white,
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 50,
//               ),
//               Center(
//                 child: CircleAvatar(
//                   radius: 60.0,
//                   backgroundImage: user?.photoURL != null
//                       ? NetworkImage("${user?.photoURL}")
//                       : AssetImage('assets/profile.png') as ImageProvider,
//                   backgroundColor: Colors.transparent,
//                 ),
//               ),
//               SizedBox(
//                 height: 50,
//               ),
//               Card(
//                 color: Colors.white,
//                 shadowColor: Colors.grey,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Row(
//                         children: [
//                           const Text(
//                             "Name :",
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                             ),
//                           ),
//                           Text(
//                             '${user?.displayName ?? '---------------'}',
//                             softWrap: true,
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Color.fromARGB(255, 17, 79, 90),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Row(
//                         children: [
//                           const Text(
//                             "Email :",
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                             ),
//                           ),
//                           Text(
//                             '${user?.email}',
//                             softWrap: true,
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Color.fromARGB(255, 17, 79, 90),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Card(
//                 color: Colors.white,
//                 shadowColor: Colors.grey,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Row(
//                         children: [
//                           const Text(
//                             "Phone Number :",
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                             ),
//                           ),
//                           Text(
//                             '${user?.phoneNumber ?? '---------------'}',
//                             softWrap: true,
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Color.fromARGB(255, 17, 79, 90),
//                             ),
//                           ),
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: IconButton(
//                               onPressed: () {
//                                 _showPhoneNumberDialog();
//                               },
//                               icon: Icon(Icons.edit),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Card(
//                 color: Colors.white,
//                 shadowColor: Colors.grey,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Row(
//                         children: [
//                           const Text(
//                             "Address:",
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                             ),
//                           ),
//                           Text(
//                             '${'---------------'}',
//                             softWrap: true,
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Color.fromARGB(255, 17, 79, 90),
//                             ),
//                           ),
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: IconButton(
//                               onPressed: () {
//                                 _AddressDialog();
//                               },
//                               icon: Icon(Icons.edit),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               ElevatedButton(
//                   onPressed: () async {
//                     await AuthMethod().logout();
//                     Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(
//                         builder: (context) => LoginScreen(),
//                       ),
//                     );
//                   },
//                   child: Text('logout')),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


  // Widget build(BuildContext context) {
     

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Profile Screen"),
  //       backgroundColor: Color.fromARGB(255, 0, 0, 0),
  //     ),
  //     body: ClipRRect(
  //       borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(50), topRight: Radius.circular(50)),
  //       child: Container(
  //         color: const Color.fromARGB(255, 0, 0, 0),
  //         child: Center(
  //           child: Text(
  //             'App Content',
  //             // style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.black),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
//}
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           CustomPaint(
//             painter: HeaderCurvedContainer(),
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: Text(
              //     user.RollNo.toUpperCase(),
              //     style: const TextStyle(
              //       fontSize: 35.0,
              //       letterSpacing: 1.5,
              //       color: Colors.white,
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),
              // Container(
              //   width: MediaQuery.of(context).size.width / 2,
              //   height: MediaQuery.of(context).size.width / 2,
              //   padding: EdgeInsets.all(10.0),
              //   decoration: BoxDecoration(
              //     boxShadow: [
              //       BoxShadow(
              //         color: Color.fromARGB(210, 135, 135, 135),
              //         blurRadius: 10,
              //         spreadRadius: 2,
              //         offset: Offset(
              //           0,
              //           10,
              //         ),
              //       ),
              //     ],
              //     shape: BoxShape.circle,
              //     color: Colors.white,
              //     image: DecorationImage(
              //       image: NetworkImage(user.ImageUrl),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Color.fromARGB(119, 135, 135, 135),
//                           blurRadius: 10,
//                           spreadRadius: 2,
//                           offset: Offset(
//                             0,
//                             10,
//                           ),
//                         ),
//                       ],
//                     ),
//                     child: Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         //set border radius more than 50% of height and width to make circle
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text("Name :"),
//                             Text(user.StudentName),
//                             const Divider(
//                               color: Colors.black,
//                             ),
//                             const Text("Email :"),
//                             Text(user.StudentEmail),
//                             const Divider(
//                               color: Colors.black,
//                             ),
//                             const Text("Mobile :"),
//                             Text(user.StudentPhnNo.toString()),
//                             const Divider(
//                               color: Colors.black,
//                             ),
//                             const Text("Department :"),
//                             Text(user.Department),
//                             const Divider(
//                               color: Colors.black,
//                             ),
//                             const Text("Parent details :"),
//                             Text(user.FatherName),
//                             Text(user.FatherPhnNo.toString()),
//                             Text(user.FatherEmail),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // CustomPainter class to for the header curved-container
// class HeaderCurvedContainer extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()..color = Color.fromARGB(255, 181, 201, 154);
//     Path path = Path()
//       ..relativeLineTo(0, 150)
//       ..quadraticBezierTo(size.width / 2, 250.0, size.width, 150)
//       ..relativeLineTo(0, -150)
//       ..close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
