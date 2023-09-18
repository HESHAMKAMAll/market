import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String phone;
  final String email;
  final String photoUrl;
  final String uid;
  // final double cartPrice;

  const User({
    required this.username,
    required this.phone,
    required this.email,
    required this.photoUrl,
    required this.uid,
    // required this.cartPrice,
  });

  Map<String,dynamic> toJson() => {
    "username": username,
    "phone": phone,
    "email": email,
    "photoUrl": photoUrl,
    "uid": uid,
  };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      phone: snapshot["phone"],
      // cartPrice: snapshot["cartPrice"],
    );
  }
}
