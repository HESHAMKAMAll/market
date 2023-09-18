import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controller/storage_methods.dart';
import '../widgets/cart_item.dart';
import 'main_screen.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection("products").where("likes", arrayContains: _auth.currentUser!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, i) {
                return Card(
                  child: Container(
                    color: Colors.grey[100],
                    height: 150,
                  ),
                );
              },
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
                      ));
                },
                icon: Icon(Icons.arrow_back_ios_new)),
            title: Text("Your Favorite", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MediaQuery.of(context).size.width >= 850
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width >= 1210? 3:2,
                      mainAxisExtent: 190,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, i) {
                      var data = snapshot.data!.docs[i];
                      return CartItem(
                        onPressedDelete: () async {
                          await StorageMethods().likeProduct(
                            snapshot.data!.docs[i]["productsID"],
                            _auth.currentUser!.uid,
                            snapshot.data!.docs[i]["likes"],
                          );
                        },
                        positioned: 100,
                        iconColor: Colors.red,
                        icon: Icons.favorite,
                        image: data["productImage"],
                        title: data["title"],
                        details: data["ProductDetails"],
                        price: data["price"].toString(),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, i) {
                      var data = snapshot.data!.docs[i];
                      return CartItem(
                        onPressedDelete: () async {
                          await StorageMethods().likeProduct(
                            snapshot.data!.docs[i]["productsID"],
                            _auth.currentUser!.uid,
                            snapshot.data!.docs[i]["likes"],
                          );
                        },
                        positioned: 100,
                        iconColor: Colors.red,
                        icon: Icons.favorite,
                        image: data["productImage"],
                        title: data["title"],
                        details: data["ProductDetails"],
                        price: data["price"].toString(),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
