import 'package:flutter/material.dart';
import 'package:animated_card/animated_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:salsel_express/config/token_provider.dart';
import 'package:salsel_express/constant/routes.dart';
import 'package:salsel_express/model/ticket.dart';
import 'package:salsel_express/service/ticket_service.dart';
import 'package:salsel_express/util/themes.dart';
import 'package:salsel_express/widget/card_widget.dart';

class ShowTicketsView extends StatefulWidget {
  const ShowTicketsView({Key? key}) : super(key: key);

  @override
  State<ShowTicketsView> createState() => _ShowTicketsState();
}

class _ShowTicketsState extends State<ShowTicketsView> {
  late Future<List<Ticket>> ticketsFuture;
  late List<Ticket> filteredTickets;
  String selectedStatus = 'Open'; // Default filter value

  @override
  void initState() {
    super.initState();
    ticketsFuture = fetchTickets("Open");
  }

  Future<List<Ticket>> fetchTickets(String status) async {
    try {
      String token = Provider.of<TokenProvider>(context, listen: false).token;
      List<Ticket> fetchedTickets = await getTickets(status, token);
      return fetchedTickets;
    } catch (error) {
      debugPrint('Error fetching tickets: $error');
      rethrow;
    }  
  }

  void _onStatusSelected(String status) {
    setState(() {
      selectedStatus = status;
      ticketsFuture =
          fetchTickets(status); // Update tickets based on selected status
    });
  }

void _onViewPressed(int index) {
  String ticketId = filteredTickets[index].id.toString();
  Navigator.of(context).pushNamed(
    ticketDetail,
    arguments: ticketId,
  );
}

  @override
  Widget build(BuildContext context) {
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
                  onSelected: _onStatusSelected,
                  itemBuilder: (BuildContext context) {
                    return ['Open', 'Closed', 'On-Hold'].map((String value) {
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
                child: FutureBuilder<List<Ticket>>(
                  future: ticketsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show loader while waiting for data
                      return const Center(
                        child: SpinKitSpinningLines(color: primarySwatch),
                      );
                    } else if (snapshot.hasError) {
                      // Show error message if fetching data fails
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      // Show ticket cards when data is available
                      filteredTickets = snapshot.data!;
                      return ListView.builder(
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
                      );
                    }
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
