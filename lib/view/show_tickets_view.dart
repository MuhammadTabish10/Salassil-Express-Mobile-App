import 'package:flutter/material.dart';
import 'package:animated_card/animated_card.dart';
import 'package:salsel_express/util/themes.dart';
import 'package:salsel_express/view/ticket_detail_view.dart';
import 'package:salsel_express/widget/ticket_card_widget.dart';

class ShowTicketsView extends StatefulWidget {
  const ShowTicketsView({Key? key}) : super(key: key);

  @override
  State<ShowTicketsView> createState() => _ShowTicketsState();
}

class _ShowTicketsState extends State<ShowTicketsView> {
  List<Map<String, dynamic>> tickets = [
    {'title': 'Ticket 1', 'name': 'Waroenk kita', 'status': 'Open'},
    {'title': 'Ticket 2', 'name': 'Waroenk kita', 'status': 'Open'},
    {'title': 'Ticket 3', 'name': 'Waroenk kita', 'status': 'Open'},
    {'title': 'Ticket 4', 'name': 'Waroenk kita', 'status': 'Closed'},
    {'title': 'Ticket 5', 'name': 'Waroenk kita', 'status': 'Closed'},
  ];

  void _onViewPressed(int index) {
    Map<String, dynamic> selectedTicket = tickets[index];

    // Define hardcoded data here
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
      'department': 'Operation',
      'departmentCategory': 'Delivery Complaint',
      'pickupDate': '2023-12-29',
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketDetailView(
          ticketDetails: selectedTicket,
          ticketTitle: selectedTicket['title'],
          hardcodedData: hardcodedData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Themes.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              return AnimatedCard(
                direction: AnimatedCardDirection.right,
                duration: const Duration(milliseconds: 500),
                child: TicketCard(
                  title: tickets[index]['title'] ?? '',
                  name: tickets[index]['name'] ?? '',
                  status: tickets[index]['status'] ?? '',
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
        ),
      ),
    );
  }
}
