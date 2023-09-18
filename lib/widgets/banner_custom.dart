import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'material_custom.dart';

class BannerCustom extends StatefulWidget {
  const BannerCustom({super.key});

  @override
  State<BannerCustom> createState() => _BannerCustomState();
}

class _BannerCustomState extends State<BannerCustom> {
  final PageController _pageController = PageController();
  int itemCounts = 0;
  int _currentPage = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   // Start auto navigation
  //   startAutoNavigation();
  // }

  void startAutoNavigation() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      final localItemCount = itemCounts; // Store itemCounts in a local variable
      if (_currentPage < localItemCount - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: FutureBuilder(
        future: FirebaseFirestore.instance.collection("banners").get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100],
              ),
            );
          }
          itemCounts = snapshot.data!.docs.length;
          return SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              itemCount: itemCounts,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: MaterialCustom(
                    borderRadius: 25,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        snapshot.data!.docs[i]["banner"],
                        fit: BoxFit.cover,
                        height: 170,
                        width: double.infinity,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
