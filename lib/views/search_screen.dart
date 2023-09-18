import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market/views/product_details_screen/product_details_screen.dart';
import '../widgets/cart_item.dart';
import '../widgets/material_custom.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: MaterialCustom(
                borderRadius: 10,
                child: TextFormField(
                  controller: searchController,
                  onChanged: (String _) {
                    setState(() {
                      isShowUsers = true;
                    });
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: "search",
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(CupertinoIcons.search, color: Colors.grey),
                      border: InputBorder.none),
                ),
              ),
            ),
            SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                searchController.clear();
              },
              child: MaterialCustom(
                borderRadius: 10,
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Icon(Icons.clear_outlined),
                ),
              ),
            ),
          ],
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance.collection('products').where('title', isGreaterThanOrEqualTo: searchController.text).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, i) {
                    var data = snapshot.data!.docs[i];
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
                                    )));
                      },
                      child: CartItem(
                        onPressedDelete: () {},
                        positioned: 0,
                        iconColor: Colors.transparent,
                        icon: Icons.delete,
                        image: data["productImage"],
                        title: data["title"],
                        details: data["ProductDetails"],
                        price: data["price"].toString(),
                      ),
                    );
                  },
                );
              },
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Image.asset("assets/icons/join.png", height: 300)),
                SizedBox(height: 10),
                Text(
                  "Join us and publish your products.",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
    );
  }
}
