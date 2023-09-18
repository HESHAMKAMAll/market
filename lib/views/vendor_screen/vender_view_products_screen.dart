import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../controller/storage_methods.dart';
import '../../widgets/appbar_custom.dart';
import '../../widgets/like_animation.dart';
import '../product_details_screen/product_details_screen.dart';

class VendorViewProductsScreen extends StatefulWidget {
  const VendorViewProductsScreen({super.key});

  @override
  State<VendorViewProductsScreen> createState() => _VendorViewProductsScreenState();
}

class _VendorViewProductsScreenState extends State<VendorViewProductsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 25,left: 5,right: 5),
          child: Column(
            children: [
              AppbarCustom(
                onTap: () {
                  Navigator.pop(context);
                },
                padding: 0,
              ),
              Text("Your products will be displayed here"),
              Divider(),
              SizedBox(height: 10),
              StreamBuilder(
                stream: _firestore
                    .collection("products")
                    .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    // .orderBy("time", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/icons/join.png", height: 300),
                          SizedBox(height: 10),
                          Text("Join us and publish your products.",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                        ],
                      );
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 6,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, mainAxisExtent: 300, mainAxisSpacing: 10, crossAxisSpacing: 10),
                      itemBuilder: (context, i) {
                        return Column(
                          children: [
                            Center(
                              child: Container(
                                height: 230,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.grey[100],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 10,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.grey[100],
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 10,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.grey[100],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 380,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                    ),
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                  image: snapshot.data!.docs[i]["productImage"],
                                  title: snapshot.data!.docs[i]["title"],
                                  details: snapshot.data!.docs[i]["ProductDetails"],
                                  price: snapshot.data!.docs[i]["price"],
                                  productsID: snapshot.data!.docs[i]["productsID"],
                                ),
                              ));
                        },
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      snapshot.data!.docs[i]["productImage"],
                                      height: 230,
                                      // width: 170,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 16,
                                  child: IconButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Delete"),
                                          content: Text("Are you sure you want to delete this product?"),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () async {
                                                  await _firestore
                                                      .collection("products")
                                                      .doc(snapshot.data!.docs[i]["productsID"])
                                                      .delete();
                                                  await _storage
                                                      .ref()
                                                      .child("products")
                                                      .child(snapshot.data!.docs[i]["productsID"])
                                                      .delete();
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                                child: Text("Delete")),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cansel")),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.delete),
                                    color: Theme.of(context).primaryColor,
                                    iconSize: 30,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data!.docs[i]["title"],
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  Row(
                                    children: [
                                      LikeAnimation(
                                        isAnimating: snapshot.data!.docs[i].data()["likes"].contains(_auth.currentUser!.uid),
                                        smallLike: true,
                                        child: IconButton(
                                          onPressed: () async {
                                            await StorageMethods().likeProduct(
                                              snapshot.data!.docs[i]["productsID"],
                                              _auth.currentUser!.uid,
                                              snapshot.data!.docs[i]["likes"],
                                            );
                                          },
                                          icon: snapshot.data!.docs[i]["likes"].contains(_auth.currentUser!.uid)
                                              ? Icon(Icons.favorite, color: Colors.red)
                                              : Icon(Icons.favorite_border),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 105,
                                        child: Text(
                                          "${snapshot.data!.docs[i]["likes"].length}  Likes",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      "\$${snapshot.data!.docs[i]["price"]}",
                                      style: TextStyle(color: Colors.grey[700]),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
