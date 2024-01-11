import 'package:flutter/material.dart';
import 'package:salsel_express/util/themes.dart';
import 'package:animated_card/animated_card.dart';

Widget buildLogo(double logoSize) {
  return Hero(
    tag: 'logoTag',
    child: Image.asset(
      'lib/assets/salassil-logo.png',
      width: logoSize,
      height: logoSize,
      fit: BoxFit.contain,
    ),
  );
}

Widget buildInputField(String labelText, IconData prefixIcon) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon, color: primarySwatch),
        border: InputBorder.none,
      ),
    ),
  );
}

Widget buildCard(String title, IconData iconData,
    {bool showCount = true, int count = 0, VoidCallback? onTap}) {
  return AnimatedCard(
    direction: AnimatedCardDirection.right,
    duration: const Duration(milliseconds: 500),
    child: Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (showCount) // Conditionally show count
                      const SizedBox(height: 4.0),
                    if (showCount)
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: const BoxDecoration(
                  color: primarySwatch,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
