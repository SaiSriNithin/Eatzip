import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class AuthMethod {
  // SignUp User
  Future<String> signupUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'uid': cred.user!.uid,
          'email': email,
          'phoneNumber': cred.user?.phoneNumber,
          'address': "",
        });

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // LogIn User
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Sign out
  Future<void> logout() async {
    await googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> updateUserAddress(String uid, String address) async {
    await _firestore.collection('users').doc(uid).update({'address': address});
  }

  // Update User Phone Number
  Future<void> updateUserPhoneNumber(String uid, String phoneNumber) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update({'phoneNumber': phoneNumber});
  }
}
