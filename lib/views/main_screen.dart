import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market/views/cart_screen.dart';
import 'package:market/views/favorite_screen.dart';
import 'package:market/views/home_screen.dart';
import 'package:market/views/vendor_screen/vendor_add_products_screen.dart';
import '../widgets/drawer_custom.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int page) {
    // pageController.jumpToPage(page);
    pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  List<Widget> pages = [
    Home(),
    FavoriteScreen(),
    VendorAddProductsScreen(),
    // CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustom(),
      floatingActionButton: StreamBuilder(
        stream: _firestore.collection("users").doc(_auth.currentUser!.uid).collection("cart").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return FloatingActionButton(
              onPressed: (){},
              backgroundColor: Theme.of(context).primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_shopping_cart,color: Colors.white),
                  Text("0",style: TextStyle(color: Colors.white,fontSize: 14)),
                ],
              ),
            );
          }
          return FloatingActionButton(
            onPressed: (){
              Navigator.push(context, CupertinoModalPopupRoute(builder: (context) => CartScreen(),));
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_shopping_cart,color: Colors.white),
                Text(snapshot.data!.docs.length.toString(),style: TextStyle(color: Colors.white,fontSize: 14)),
              ],
            ),
          );
        },
      ),
      body: PageView(
        // physics: NeverScrollableScrollPhysics(),
        allowImplicitScrolling: true,
        children: pages,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: navigationTapped,
        currentIndex: _page,
        backgroundColor: Colors.transparent,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Sell your products"),
        ],
      ),
    );
  }
}
