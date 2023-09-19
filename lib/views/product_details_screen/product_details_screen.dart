import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/storage_methods.dart';
import '../../controller/theme.dart';
import '../../stripe_payment/payment_manager.dart';
import '../../utils/utils.dart';
import '../../widgets/like_animation.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String image;
  final String title;
  final String details;
  final double price;
  final String productsID;

  ProductDetailsScreen({
    super.key,
    required this.image,
    required this.title,
    required this.details,
    required this.price,
    required this.productsID,
  });

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int random = Random().nextInt(999999999);
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection("products").doc(productsID).snapshots(),
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
        return Scaffold(
          appBar: AppBar(title: Text("Product Details", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
          body: ListView(
            padding: EdgeInsets.all(10),
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Hero(tag: productsID,child: Image.network(image, fit: BoxFit.cover)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: LikeAnimation(
                      isAnimating: snapshot.data!["likes"].contains(_auth.currentUser!.uid),
                      smallLike: true,
                      child: IconButton(
                        onPressed: () async {
                          await StorageMethods().likeProduct(
                            snapshot.data!["productsID"],
                            _auth.currentUser!.uid,
                            snapshot.data!["likes"],
                          );
                        },
                        icon: snapshot.data!["likes"].contains(_auth.currentUser!.uid)
                            ? Icon(Icons.favorite, color: Colors.red)
                            : Icon(Icons.favorite_border),
                        iconSize: 50,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text("Rating  "),
                  snapshot.data!["likes"].length == 0
                      ? Row(
                          children: [
                            Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                            Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                            Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                            Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                            Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                          ],
                        )
                      : snapshot.data!["likes"].length == 1
                          ? Row(
                              children: [
                                Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                              ],
                            )
                          : snapshot.data!["likes"].length == 2
                              ? Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                    Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                    Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                    Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                    Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                  ],
                                )
                              : snapshot.data!["likes"].length == 3
                                  ? Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                        Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                        Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                                        Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                        Icon(Icons.star_border, color: Colors.orangeAccent, size: 16),
                                      ],
                                    )
                                  : snapshot.data!["likes"].length == 4
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
              SizedBox(height: 20),
              Text(title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              Text(
                details,
                style: TextStyle(),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                SizedBox(
                  width: 130,
                  child: Text(
                    "\$$price",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Spacer(),
                OutlinedButton(
                  onPressed: () async {
                    if (!isButtonPressed) {
                      // value.addProduct(Cart(image: image, title: title, details: details, price: price));
                      await _firestore.collection("users").doc(_auth.currentUser!.uid).collection("cart").doc(random.toString()).set({
                        "id": random,
                        "image": image,
                        "title": title,
                        "details": details,
                        "price": price,
                      });

                      await _firestore.collection("users").doc(_auth.currentUser!.uid).update({
                        "cartPrice": FieldValue.increment(price),
                      });
                      showSnackBar("Added to the cart.", context);
                      isButtonPressed = true;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Add to Card",
                    style: TextStyle(
                      color: Provider.of<MyTheme>(context).theme == Brightness.light ? Colors.black : Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    PaymentManager.makePayment(price.toInt(), "USD");
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    "Buy Now",
                    style: TextStyle(
                      color: Colors.white,
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
