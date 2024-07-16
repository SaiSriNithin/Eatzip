import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      print("Attempting to sign in with Google...");
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      print("GoogleSignInAccount: $googleSignInAccount");

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        print("GoogleSignInAuthentication: $googleSignInAuthentication");

        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        UserCredential userCredential =
            await auth.signInWithCredential(authCredential);
        print("UserCredential: $userCredential");

        // Update Firestore with user details
        await updateUserData(userCredential.user);
        print("User data updated successfully");

        return userCredential;
      } else {
        print("GoogleSignInAccount is null");
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: $e');
      return null;
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<void> updateUserData(User? user) async {
    if (user != null) {
      final userRef = firestore.collection('users').doc(user.uid);

      final userData = {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'lastSignInTime': user.metadata.lastSignInTime?.toIso8601String(),
        'creationTime': user.metadata.creationTime?.toIso8601String(),
        'phoneNumber': user.phoneNumber,
        'address': '',
      };

      await userRef.set(userData, SetOptions(merge: true));

      await firestore
          .collection('carts')
          .doc(user.uid)
          .set({"cartItems": []}, SetOptions(merge: true));
    }
  }

  Future<void> updateUserAddress(String uid, String address) async {
    await firestore.collection('users').doc(uid).update({'address': address});
  }

  // Update User Phone Number
  Future<void> updateUserPhoneNumber(String uid, String phoneNumber) async {
    await firestore
        .collection('users')
        .doc(uid)
        .update({'phoneNumber': phoneNumber});
  }
}
