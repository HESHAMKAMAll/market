import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../views/search_screen.dart';
import 'material_custom.dart';

class SearchCustom extends StatelessWidget {
  const SearchCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) => SearchScreen()));
          },
          child: Row(
            children: [
              Expanded(
                child: MaterialCustom(
                  borderRadius: 15,
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                        hintText: "search",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(CupertinoIcons.search, color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
              ),
              SizedBox(width: 20),
              MaterialCustom(
                borderRadius: 10,
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Image.asset("assets/icons/icons8-search-58.png", height: 25, color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
