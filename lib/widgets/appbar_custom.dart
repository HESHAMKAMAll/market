import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'material_custom.dart';

class AppbarCustom extends StatelessWidget {
  final Function() onTap;
  final double padding;
  AppbarCustom({super.key, required this.onTap, this.padding = 30});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: FutureBuilder(
        future: _firestore.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: onTap,
                    child: MaterialCustom(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset("assets/icons/icons8-circled-menu-96.png",height: 25,color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                    width: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[100],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[100],
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.only(bottom: padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onTap,
                  child: MaterialCustom(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image.asset("assets/icons/icons8-circled-menu-96.png",height: 25,color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),

                Text("Hello ${snapshot.data!["username"]}",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold)),
                MaterialCustom(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(snapshot.data!["photoUrl"]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
