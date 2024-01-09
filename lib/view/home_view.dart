import 'package:flutter/material.dart';
import 'package:salsel_express/util/themes.dart';
import 'package:salsel_express/widget/bottom_navigation_widget.dart';
import 'package:salsel_express/widget/general_widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
      ),
      body: Container(
        color: Themes.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildCard('Scan', Icons.qr_code_scanner, showCount: false),
              const SizedBox(height: 16.0),
              buildCard('My Jobs', Icons.assignment, count: 5),
              const SizedBox(height: 16.0),
              buildCard('Tickets', Icons.confirmation_number, count: 8),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
