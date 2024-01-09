import 'package:flutter/material.dart';
import 'package:salsel_express/constant/routes.dart';
import 'package:salsel_express/util/themes.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigationWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: primarySwatch,
      buttonBackgroundColor: primarySwatch,
      height: 60.0,
      index: currentIndex,
      onTap: (index) {
        if (index == 3) {
          // Logout item is clicked (assuming 'Logout' is at index 3)
          Navigator.pushReplacementNamed(context, loginRoute);
        } else {
          onTap(index);
        }
      },
      items: <Widget>[
        _buildNavItem(Icons.home, 'Home'),
        _buildNavItem(Icons.confirmation_number, 'Tickets'),
        _buildNavItem(Icons.assignment, 'My Jobs'),
        _buildNavItem(Icons.logout, 'Logout'),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return SizedBox(
      width: 120.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Icon(
              icon,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
