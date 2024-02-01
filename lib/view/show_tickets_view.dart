// import 'package:flutter/material.dart';
// import 'package:animated_card/animated_card.dart';
// import 'package:salsel_express/util/themes.dart';
// import 'package:salsel_express/view/ticket_detail_view.dart';
// import 'package:salsel_express/widget/card_widget.dart';

// class ShowTicketsView extends StatefulWidget {
//   const ShowTicketsView({Key? key}) : super(key: key);

//   @override
//   State<ShowTicketsView> createState() => _ShowTicketsState();
// }

// class _ShowTicketsState extends State<ShowTicketsView> {
//   List<Map<String, dynamic>> tickets = [
//     {'title': 'Ticket 1', 'name': 'Waroenk kita', 'status': 'Open'},
//     {'title': 'Ticket 2', 'name': 'Waroenk kita', 'status': 'Open'},
//     {'title': 'Ticket 3', 'name': 'Waroenk kita', 'status': 'Open'},
//     {'title': 'Ticket 4', 'name': 'Waroenk kita', 'status': 'Closed'},
//     {'title': 'Ticket 5', 'name': 'Waroenk kita', 'status': 'Closed'},
//   ];

//   String selectedStatus = 'All'; // Default filter value

//   void _onViewPressed(int index) {
//     Map<String, dynamic> selectedTicket = tickets[index];

//     // Define hardcoded data here
//     Map<String, dynamic> hardcodedData = {
//       'shipperName': 'Waroenk kita',
//       'shipperContact': '03354231123',
//       'pickupAddress': 'Y-02 Central Housing',
//       'shipperRefNo': 'SH9824',
//       'originCountry': 'Pakistan',
//       'originCity': 'Karachi',
//       'recipientName': 'Bob Anderson',
//       'recipientContact': '03323428867',
//       'deliveryAddress': 'Street 24 Block 18',
//       'destinationCountry': 'Saudi Arabia',
//       'destinationCity': 'Riyadh',
//       'department': 'Operation',
//       'departmentCategory': 'Delivery Complaint',
//       'pickupDate': '2023-12-29',
//     };

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => TicketDetailView(
//           ticketDetails: selectedTicket,
//           ticketTitle: selectedTicket['title'],
//           hardcodedData: hardcodedData,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, dynamic>> filteredTickets = selectedStatus == 'All'
//         ? tickets
//         : tickets
//             .where((ticket) => ticket['status'] == selectedStatus)
//             .toList();

//     return Scaffold(
//       body: Container(
//         color: Themes.backgroundColor,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: ListView(
//             children: [
//               const Text(
//                 'Filter by Status:',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 12.0),
//               AnimatedCard(
//                 direction: AnimatedCardDirection.top,
//                 duration: const Duration(milliseconds: 500),
//                 child: PopupMenuButton<String>(
//                   offset: const Offset(0, 50),
//                   onSelected: (value) {
//                     setState(() {
//                       selectedStatus = value;
//                     });
//                   },
//                   itemBuilder: (BuildContext context) {
//                     return ['All', 'Open', 'Closed'].map((String value) {
//                       return PopupMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList();
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 24.0, vertical: 12.0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12.0),
//                       border: Border.all(
//                         color: Theme.of(context).primaryColor,
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(selectedStatus),
//                         const Icon(Icons.arrow_drop_down),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: filteredTickets.length,
//                 itemBuilder: (context, index) {
//                   return AnimatedCard(
//                     direction: AnimatedCardDirection.right,
//                     duration: const Duration(milliseconds: 500),
//                     child: CardWidget(
//                       title: filteredTickets[index]['title'] ?? '',
//                       name: filteredTickets[index]['name'] ?? '',
//                       status: filteredTickets[index]['status'] ?? '',
//                       button: TextButton(
//                         onPressed: () {
//                           _onViewPressed(index);
//                         },
//                         child: const Text(
//                           'View',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       onTap: () {
//                         // Handle tapping on a ticket card, if needed
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:animated_card/animated_card.dart';
import 'package:provider/provider.dart';
import 'package:salsel_express/config/token_provider.dart';
import 'package:salsel_express/model/ticket.dart';
import 'package:salsel_express/service/ticket_service.dart';
import 'package:salsel_express/util/themes.dart';
import 'package:salsel_express/view/ticket_detail_view.dart';
import 'package:salsel_express/widget/card_widget.dart';

class ShowTicketsView extends StatefulWidget {
  const ShowTicketsView({Key? key}) : super(key: key);

  @override
  State<ShowTicketsView> createState() => _ShowTicketsState();
}

class _ShowTicketsState extends State<ShowTicketsView> {
  List<Ticket> tickets = [];
  String selectedStatus = 'All'; // Default filter value

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    try {
    String token = Provider.of<TokenProvider>(context, listen: false).token;
    List<Ticket> fetchedTickets = await getTickets(true, token);
      setState(() {
        tickets = fetchedTickets;
      });
    } catch (error) {
      debugPrint('Error fetching tickets: $error');
    }
  }

  void _onViewPressed(int index) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     // builder: (context) => TicketDetailView(ticket: tickets[index]),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    List<Ticket> filteredTickets = selectedStatus == 'All'
        ? tickets
        : tickets.where((ticket) => ticket.ticketStatus == selectedStatus).toList();

    return Scaffold(
      body: Container(
        color: Themes.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Filter by Status:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
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
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
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
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTickets.length,
                  itemBuilder: (context, index) {
                    return AnimatedCard(
                      direction: AnimatedCardDirection.right,
                      duration: const Duration(milliseconds: 500),
                      child: CardWidget(
                        title: filteredTickets[index].shipperName ?? '',
                        name: filteredTickets[index].name ?? '',
                        status: filteredTickets[index].ticketStatus ?? '',
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
            ],
          ),
        ),
      ),
    );
  }
}
