import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/auth.dart';
import '../controller/theme.dart';
import '../views/auth/login_screen.dart';
import '../views/favorite_screen.dart';
import '../views/vendor_screen/vender_view_products_screen.dart';

class DrawerCustom extends StatefulWidget {
  const DrawerCustom({super.key});

  @override
  State<DrawerCustom> createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder(
            future: _firestore.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return UserAccountsDrawerHeader(
                  otherAccountsPictures: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/icons/Logo-removebg-preview.png"),
                      backgroundColor: Colors.black,
                    )
                  ],
                  currentAccountPicture: CircleAvatar(
                    // backgroundImage: AssetImage("assets/icons/Logo-removebg-preview.png"),
                    backgroundColor: Colors.grey[100],
                  ),
                  accountName: Container(
                    height: 10,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[400],
                    ),
                  ),
                  accountEmail: Container(
                    height: 10,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[400],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }
              return UserAccountsDrawerHeader(
                otherAccountsPictures: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/icons/Logo-removebg-preview.png"),
                    backgroundColor: Colors.black,
                  )
                ],
                currentAccountPicture: CircleAvatar(backgroundImage: NetworkImage(snapshot.data!["photoUrl"])),
                accountName: Text(snapshot.data!["username"], style: TextStyle(fontSize: 24.0)),
                accountEmail: Text(snapshot.data!["email"]),
                decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              );
            },
          ),
          Consumer<MyTheme>(
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      value.changColorToBlue();
                      value.changeTheme();
                      // Navigator.pushReplacement(
                      //     context,
                      //     PageRouteBuilder(
                      //       pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
                      //     ));
                    },
                    child: value.theme == Brightness.dark
                        ? Text('Light', style: TextStyle(color: Colors.white))
                        : Text('Dark', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      value.changColorToRed();
                      value.changeTheme();
                      // Navigator.pushReplacement(
                      //     context,
                      //     PageRouteBuilder(
                      //       pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
                      //     ));
                    },
                    child: value.theme == Brightness.dark
                        ? Text('Light', style: TextStyle(color: Colors.white))
                        : Text('Dark', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      value.changColorToTeal();
                      value.changeTheme();
                      // Navigator.pushReplacement(
                      //     context,
                      //     PageRouteBuilder(
                      //       pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
                      //     ));
                    },
                    child: value.theme == Brightness.dark
                        ? Text('Light', style: TextStyle(color: Colors.white))
                        : Text('Dark', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  ),
                ],
              );
            },
          ),
          const Divider(
            height: 10,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard),
            title: const Text('Your products', style: TextStyle(fontSize: 24.0)),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => VendorViewProductsScreen(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites', style: TextStyle(fontSize: 24.0)),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => FavoriteScreen(),
                  ));
            },
          ),
          ListTile(
              leading: const Icon(Icons.apartment),
              title: const Text('Apartments', style: TextStyle(fontSize: 24.0, decoration: TextDecoration.lineThrough))),
          ListTile(
              leading: const Icon(Icons.house_outlined),
              title: const Text('Townhomes', style: TextStyle(fontSize: 24.0, decoration: TextDecoration.lineThrough))),
          const Divider(
            height: 10,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out', style: TextStyle(fontSize: 24.0)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Sign Out"),
                  content: Text("Are you sure you want to log out?"),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          AuthMethods().signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => const LoginScreen(),
                              ));
                        },
                        child: Text("Sign Out")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cansel")),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
