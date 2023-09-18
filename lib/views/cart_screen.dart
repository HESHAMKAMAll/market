import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/theme.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  fun() async {
    await _firestore.collection("users").doc(_auth.currentUser!.uid).update({"cartPrice": 0.0});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection("users").doc(_auth.currentUser!.uid).collection("cart").snapshots(),
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
          appBar: AppBar(title: Text("Cart", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)), centerTitle: true),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MediaQuery.of(context).size.width >= 850?
            GridView.builder(
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
                    await _firestore.collection("users").doc(_auth.currentUser!.uid).collection("cart").doc(data["id"].toString()).delete();
                    await _firestore.collection("users").doc(_auth.currentUser!.uid).update({
                      "cartPrice": FieldValue.increment(-data["price"]),
                    });
                    // Future.delayed(Duration(seconds: 1),() {setState(() {});},);
                    // if (snapshot.data!.docs.isEmpty) {
                    //   await _firestore.collection("users").doc(_auth.currentUser!.uid).update({"cartPrice": 0.0});
                    //
                    // }
                  },
                  positioned: 0,
                  iconColor: Theme.of(context).primaryColor,
                  icon: Icons.delete,
                  image: data["image"],
                  title: data["title"],
                  details: data["details"],
                  price: data["price"].toString(),
                );
              },
            ):
            ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, i) {
                var data = snapshot.data!.docs[i];
                return CartItem(
                  onPressedDelete: () async {
                    await _firestore.collection("users").doc(_auth.currentUser!.uid).collection("cart").doc(data["id"].toString()).delete();
                    await _firestore.collection("users").doc(_auth.currentUser!.uid).update({
                      "cartPrice": FieldValue.increment(-data["price"]),
                    });
                    // Future.delayed(Duration(seconds: 1),() {setState(() {});},);
                    // if (snapshot.data!.docs.isEmpty) {
                    //   await _firestore.collection("users").doc(_auth.currentUser!.uid).update({"cartPrice": 0.0});
                    //
                    // }
                  },
                  positioned: 0,
                  iconColor: Theme.of(context).primaryColor,
                  icon: Icons.delete,
                  image: data["image"],
                  title: data["title"],
                  details: data["details"],
                  price: data["price"].toString(),
                );
              },
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(bottom: 10, right: 10, left: 10),
            height: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                MediaQuery.of(context).size.width >= 700? Text(""):
                Text("TOTAL", style: TextStyle(fontSize: 14)),
                StreamBuilder(
                  stream: _firestore.collection("users").doc(_auth.currentUser!.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        "0",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        "0",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      );
                    }
                    return MediaQuery.of(context).size.width >= 700
                        ? Row(
                            children: [
                              Spacer(flex: 2),
                              Column(
                                children: [
                                  Text(
                                    "TOTAL",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "\$${snapshot.data!["cartPrice"]}",
                                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              Spacer(),
                              OutlinedButton(
                                onPressed: () async {
                                  final collectionRef =
                                      FirebaseFirestore.instance.collection("users").doc(_auth.currentUser!.uid).collection("cart");
                                  final querySnapshot = await collectionRef.get();
                                  for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
                                    await documentSnapshot.reference.delete();
                                  }
                                  await _firestore.collection("users").doc(_auth.currentUser!.uid).update({
                                    "cartPrice": 0,
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Clear Cart",
                                  style: TextStyle(
                                    color: Provider.of<MyTheme>(context).theme == Brightness.light ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                              Spacer(flex: 2),
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                "\$${snapshot.data!["cartPrice"]}",
                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Spacer(),
                              OutlinedButton(
                                onPressed: () async {
                                  final collectionRef =
                                      FirebaseFirestore.instance.collection("users").doc(_auth.currentUser!.uid).collection("cart");
                                  final querySnapshot = await collectionRef.get();
                                  for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
                                    await documentSnapshot.reference.delete();
                                  }
                                  await _firestore.collection("users").doc(_auth.currentUser!.uid).update({
                                    "cartPrice": 0,
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Clear Cart",
                                  style: TextStyle(
                                    color: Provider.of<MyTheme>(context).theme == Brightness.light ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                  },
                ),
                SizedBox(height: 7),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: MediaQuery.of(context).size.width >= 700 ? Size(500, 50) : Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      "Buy Now",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
