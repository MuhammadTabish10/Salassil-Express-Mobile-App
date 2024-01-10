import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';
import 'package:salsel_express/util/themes.dart';

class TicketCard extends StatelessWidget {
  final String title;
  final String name;
  final String status;
  final Widget button;
  final VoidCallback? onTap;

  const TicketCard({
    Key? key,
    required this.title,
    required this.name,
    required this.status,
    required this.button,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
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
