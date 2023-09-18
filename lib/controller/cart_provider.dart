import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import '../models/cart_nodel.dart';

// class CartProvider extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final List<Cart> cartItems = [];
//   fun()async{
//     var cartValue = await _firestore.collection("users").doc(_auth.currentUser!.uid).collection("cart").get();
//   }
//
//   getTotalPrice()async{
//     double total = 0.0;
//     cartItems.forEach((element) {
//       total += element.price;
//       print(element.price);
//     });
//   }
//
//   void addProduct(Cart cart) {
//     if(cartItems.length < 10){
//       cartItems.add(cart);
//       notifyListeners();
//     }
//   }
//
//   void removeProduct(Cart cart) {
//     cartItems.remove(cart);
//     notifyListeners();
//   }
//
//   total(){
//     cartItems[0].price + cartItems[1].price;
//   }
//
// }
