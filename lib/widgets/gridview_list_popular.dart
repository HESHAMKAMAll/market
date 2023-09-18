import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controller/storage_methods.dart';
import '../views/product_details_screen/product_details_screen.dart';
import 'like_animation.dart';

class GridViewListIPhone extends StatelessWidget {
  GridViewListIPhone({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("products")
          .orderBy("time", descending: true)
          .where("permission", isEqualTo: true)
          .where("category", isEqualTo: "iPhone")
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
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
                            // Image.asset(
                            //   "assets/icons/icons8-love-96.png",
                            //   height: 25,
                            //   color: Colors.grey[100],
                            // ),
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
        if (snapshot.hasData) {
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width >= 1200? 5:MediaQuery.of(context).size.width >= 850?4:MediaQuery.of(context).size.width >= 650?3:2,
              mainAxisExtent: 370,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
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
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                        child: Image.network(
                          snapshot.data!.docs[i]["productImage"],
                          height: 235,
                          // width: 190,
                          fit: BoxFit.cover,
                        ),
                      ),
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
                              Text("Rating  "),
                              snapshot.data!.docs[i]["likes"].length == 0
                                  ? Row(
                                      children: [
                                        Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                        Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                        Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                        Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                        Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                      ],
                                    )
                                  : snapshot.data!.docs[i]["likes"].length == 1
                                      ? Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                            Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                            Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                            Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                            Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                          ],
                                        )
                                      : snapshot.data!.docs[i]["likes"].length == 2
                                          ? Row(
                                              children: [
                                                Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                                Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                                Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                                Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                                Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                              ],
                                            )
                                          : snapshot.data!.docs[i]["likes"].length == 3
                                              ? Row(
                                                  children: [
                                                    Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                                    Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                                    Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                                    Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                                    Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                                  ],
                                                )
                                              : snapshot.data!.docs[i]["likes"].length == 4
                                                  ? Row(
                                                      children: [
                                                        Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                                        Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                                        Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                                        Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                                        Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                                      ],
                                                    )
                                                  : Row(
                                                      children: [
                                                        Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                                        Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                                        Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                                        Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                                        Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                                      ],
                                                    ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  "\$${snapshot.data!.docs[i]["price"]}",
                                  style: TextStyle(color: Colors.grey[700], fontSize: 20),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 300,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
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
                            // Image.asset(
                            //   "assets/icons/icons8-love-96.png",
                            //   height: 25,
                            //   color: Colors.grey[100],
                            // ),
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
      },
    );
  }
}
