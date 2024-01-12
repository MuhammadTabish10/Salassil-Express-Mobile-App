import 'package:flutter/material.dart';
import 'package:animated_card/animated_card.dart';
import 'package:salsel_express/util/themes.dart';
import 'package:salsel_express/view/job_detail_view.dart';
import 'package:salsel_express/widget/card_widget.dart';

class ShowJobsView extends StatefulWidget {
  const ShowJobsView({Key? key}) : super(key: key);

  @override
  State<ShowJobsView> createState() => _ShowJobsState();
}

class _ShowJobsState extends State<ShowJobsView> {
  List<Map<String, dynamic>> awbList = [
    {'title': 'Awb 1', 'name': 'Waroenk kita', 'status': 'Open'},
    {'title': 'Awb 2', 'name': 'Waroenk kita', 'status': 'Open'},
    {'title': 'Awb 3', 'name': 'Waroenk kita', 'status': 'Open'},
    {'title': 'Awb 4', 'name': 'Waroenk kita', 'status': 'Open'},
    {'title': 'Awb 5', 'name': 'Waroenk kita', 'status': 'Open'},
    {'title': 'Awb 6', 'name': 'Waroenk kita', 'status': 'Closed'},
    {'title': 'Awb 7', 'name': 'Waroenk kita', 'status': 'Closed'},
  ];

  String selectedStatus = 'All';

  void _onViewPressed(int index) {
    Map<String, dynamic> selectedAwb = awbList[index];

    Map<String, dynamic> hardcodedData = {
      'shipperName': 'Waroenk kita',
      'shipperContact': '03354231123',
      'pickupAddress': 'Y-02 Central Housing',
      'shipperRefNo': 'SH9824',
      'originCountry': 'Pakistan',
      'originCity': 'Karachi',
      'recipientName': 'Bob Anderson',
      'recipientContact': '03323428867',
      'deliveryAddress': 'Street 24 Block 18',
      'destinationCountry': 'Saudi Arabia',
      'destinationCity': 'Riyadh',
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailView(
          jobDetails: selectedAwb,
          jobTitle: selectedAwb['title'],
          hardcodedData: hardcodedData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredAwb = selectedStatus == 'All'
        ? awbList
        : awbList.where((awb) => awb['status'] == selectedStatus).toList();

    return Scaffold(
      body: Container(
        color: Themes.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter by Status:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle AWB button press
                      // Add your AWB button functionality here
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primarySwatch,
                      elevation: 3.0,
                    ),
                    child: const Text(
                      'Create AWB',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              AnimatedCard(
                direction: AnimatedCardDirection.top,
                duration: const Duration(milliseconds: 500),
                child: PopupMenuButton<String>(
                  offset: const Offset(0, 50),
                  onSelected: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return ['All', 'Open', 'Closed'].map((String value) {
                      return PopupMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(selectedStatus),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredAwb.length,
                itemBuilder: (context, index) {
                  return AnimatedCard(
                    direction: AnimatedCardDirection.right,
                    duration: const Duration(milliseconds: 500),
                    child: CardWidget(
                      title: filteredAwb[index]['title'] ?? '',
                      name: filteredAwb[index]['name'] ?? '',
                      status: filteredAwb[index]['status'] ?? '',
                      button: TextButton(
                        onPressed: () {
                          _onViewPressed(index);
                        },
                        child: const Text(
                          'View',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        // Handle tapping on a ticket card, if needed
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
