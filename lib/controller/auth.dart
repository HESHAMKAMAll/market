import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market/controller/storage_methods.dart';
import 'package:market/models/user_model.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({required String email, required String password, required String phone, required String username, required Uint8List file,context}) async {
    String res = "Some error occurred";
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      String photoUrl = await StorageMethods().uploadImageToStorage("profilePics", file, false);

      model.User user = model.User(
        // cartPrice: cartPrice,
        email: email,
        uid: cred.user!.uid,
        photoUrl: photoUrl,
        username: username,
        phone: phone,
      );
      await _firestore.collection("users").doc(cred.user!.uid).set(user.toJson());
      await _firestore.collection("users").doc(cred.user!.uid).update({
        "cartPrice": 0,
      });
      res = "success";

    }  catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser({required String email, required String password}) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "Please enter your account and password.";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

}
