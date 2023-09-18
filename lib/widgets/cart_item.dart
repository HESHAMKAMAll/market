import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String image;
  final String title;
  final String details;
  final String price;
  final IconData icon;
  final Color iconColor;
  final double positioned;
  final Function() onPressedDelete;

  CartItem(
     {
    super.key,
    required this.image,
    required this.title,
    required this.details,
    required this.price,
    required this.icon, required this.iconColor,
        required this.positioned,
       required this.onPressedDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 170,
        child: Stack(
          children: [
            Row(
              children: [
                Image.network(
                  image,
                  height: 150,
                  width: 110,
                ),
                SizedBox(width: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          title,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: Text(
                          details,
                          style: TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 180,
                        child: Text(
                          "\$$price",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: positioned,
              right: 0,
              child: IconButton(
                onPressed: onPressedDelete,
                icon: Icon(icon),
                iconSize: 30,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
