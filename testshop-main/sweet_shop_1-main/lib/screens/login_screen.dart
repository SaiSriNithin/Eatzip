import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop/admin/admin_homescreen.dart';
import 'package:sweet_shop/screens/signup_screen.dart';
import 'package:sweet_shop/services/authentication.dart';
import 'package:sweet_shop/services/google_signin.dart';
import 'package:sweet_shop/widgets/navbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController forgotemailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

// email and passowrd auth part
  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    // signup user using our authmethod
    String res = await AuthMethod().loginUser(
        email: emailController.text, password: passwordController.text);

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      //navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Navbar(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 100),
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Log in to your account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 40),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email id';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelText: 'Email or Username',
                    hintText: 'Enter your email or username',
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      overlayColor: Colors.transparent,
                    ),
                    onPressed: () {
                      //it's code was written down side .The code in a function inside the class
                      forgotPassword(context);
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (emailController.text == 'admin' &&
                            passwordController.text == 'admin') {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => AdminHomeScreen(),
                            ),
                          );
                        } else {
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(
                          //     builder: (context) => Navbar(),
                          //   ),
                          // );
                          loginUser();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.all(8),
                    ),
                    child: Text(
                      'Log In',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?'),
                    TextButton(
                      style: TextButton.styleFrom(
                        overlayColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(),
                    ),
                    Text('or'),
                    Expanded(
                      child: Divider(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseServices()
                        .signInWithGoogle()
                        .then((userCredential) {
                      if (userCredential != null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => Navbar(),
                          ),
                        );
                      } else {
                        // Handle the case where sign-in failed
                        print("Sign-in failed");
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(77, 0, 0, 0),
                    padding: EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 18,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255,
                              255), // Background color inside the circle
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/google_logo.png',
                          width: MediaQuery.of(context).size.width / 15,
                          height: MediaQuery.of(context).size.height / 15,
                        ),
                      ),
                      SizedBox(width: 15.0),
                      Text(
                        'Countinue with Google',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//forgot password code for pop up
  void forgotPassword(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      const Text(
                        "Forgot Your Password",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: forgotemailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter the Email",
                      hintText: "eg abc@gmail.com",
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () async {
                      await auth
                          .sendPasswordResetEmail(
                              email: forgotemailController.text)
                          .then((value) {
                        // if success then show this message
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "We have send you the reset password link to your email id, Please check it"),
                        ));
                      }).onError((error, stackTrace) {
                        // if unsuccess then show error message
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(error.toString()),
                        ));
                      });
                      // terminate the dialog after send the forgot password link
                      Navigator.pop(context);
                      // clear the text field
                      forgotemailController.clear();
                    },

                    // if we remember the password then we can easily login
                    // if we forget the password then we apply this method
                    child: const Text(
                      "Send",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
  // void _handleGoogleSignIn() {
  //   try {
  //     GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
  //     _auth.signInWithProvider(_googleAuthProvider);
  //   } catch (error) {
  //     print(error);
  //   }
  // }
}
