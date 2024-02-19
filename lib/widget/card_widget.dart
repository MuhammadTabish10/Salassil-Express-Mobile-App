import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';
import 'package:salsel_express/util/themes.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String name;
  final String status;
  final Widget button;
  final VoidCallback? onTap;

  const CardWidget({
    Key? key,
    required this.title,
    required this.name,
    required this.status,
    required this.button,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine border color based on status
    Color borderColor = Colors.white;

    // Determine text color based on status
    Color statusTextColor = Colors.white;

    if (status == 'Open') {
      borderColor = Colors.green;
      statusTextColor = Colors.green;
    } else if (status == 'Closed') {
      borderColor = Colors.red;
      statusTextColor = Colors.red;
    } else if (status == 'On-Hold') {
      borderColor = Colors.orange;
      statusTextColor = Colors.orange;
    } else {
      borderColor = Colors.green;
      statusTextColor = Colors.green;
    }

    return AnimatedCard(
      direction: AnimatedCardDirection.right,
      duration: const Duration(milliseconds: 500),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor, width: 2.0), // Add border
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
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
                    const SizedBox(height: 4.0),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 18,
                        color: statusTextColor, // Use determined text color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: const BoxDecoration(
                      color: primarySwatch,
                      shape: BoxShape.circle,
                    ),
                    child: button,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
