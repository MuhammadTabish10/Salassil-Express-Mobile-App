import 'package:flutter/material.dart';
import 'package:animated_card/animated_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:salsel_express/config/token_provider.dart';
import 'package:salsel_express/constant/routes.dart';
import 'package:salsel_express/util/themes.dart';
import 'package:salsel_express/service/ticket_service.dart';
import 'package:salsel_express/model/ticket.dart';

class TicketDetailView extends StatefulWidget {
  const TicketDetailView({Key? key}) : super(key: key);

  @override
  State<TicketDetailView> createState() => _TicketDetailViewState();
}

class _TicketDetailViewState extends State<TicketDetailView> {
  late Future<Ticket> ticketDetailsFuture;
  late String ticketId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access ModalRoute and get the ticketId here
    ticketId = ModalRoute.of(context)!.settings.arguments as String;
    ticketDetailsFuture = fetchTicketDetails(ticketId);
  }

  Future<Ticket> fetchTicketDetails(String ticketId) async {
    String token = Provider.of<TokenProvider>(context, listen: false).token;
    try {
      Ticket ticketDetails = await getTicketById(ticketId, token);
      return ticketDetails;
    } catch (error) {
      debugPrint('Error fetching ticket details: $error');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ticket Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).pushNamed(userProfile);
            },
            iconSize: 28.0,
            color: colorScheme.onPrimary,
          ),
        ],
        backgroundColor: primarySwatch,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<Ticket>(
        future: ticketDetailsFuture,
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
            // Show ticket details when data is available
            Ticket ticketDetails = snapshot.data!;
            return AnimatedCard(
              direction: AnimatedCardDirection.top,
              duration: const Duration(milliseconds: 500),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailsSection(
                      'Shipper Details',
                      [
                        _buildDetailItem(
                            'Shipper Name', ticketDetails.shipperName),
                        _buildDetailItem('Shipper Contact Number',
                            ticketDetails.shipperContactNumber),
                        _buildDetailItem(
                            'Pickup Address', ticketDetails.pickupAddress),
                        _buildDetailItem('Shipper Ref Number',
                            ticketDetails.shipperRefNumber),
                        _buildDetailItem(
                            'Recipient Name', ticketDetails.recipientName),
                        _buildDetailItem('Recipient Contact Number',
                            ticketDetails.recipientContactNumber),
                        _buildDetailItem(
                            'Delivery Address', ticketDetails.deliveryAddress),
                        _buildDetailItem('Delivery Street Name',
                            ticketDetails.deliveryStreetName),
                        _buildDetailItem('Delivery District',
                            ticketDetails.deliveryDistrict),
                        _buildDetailItem('Pickup Street Name',
                            ticketDetails.pickupStreetName),
                        _buildDetailItem(
                            'Pickup District', ticketDetails.pickupDistrict),
                      ],
                    ),
                    _buildDetailsSection(
                      'Other Details',
                      [
                        _buildDetailItem('Name', ticketDetails.name),
                        _buildDetailItem('Weight', ticketDetails.weight),
                        _buildDetailItem('Email', ticketDetails.email),
                        _buildDetailItem('Phone', ticketDetails.phone),
                        _buildDetailItem(
                            'Airway Number', ticketDetails.airwayNumber),
                        _buildDetailItem(
                            'Ticket Type', ticketDetails.ticketType),
                        _buildDetailItem('Ticket URL', ticketDetails.ticketUrl),
                        _buildDetailItem('Pickup Date',
                            ticketDetails.pickupDate?.toString() ?? ''),
                        _buildDetailItem(
                            'Pickup Time', ticketDetails.pickupTime),
                        _buildDetailItem('Textarea', ticketDetails.textarea),
                        _buildDetailItem('Category', ticketDetails.category),
                        _buildDetailItem(
                            'Ticket Flag', ticketDetails.ticketFlag),
                        _buildDetailItem(
                            'Assigned To', ticketDetails.assignedTo),
                        _buildDetailItem(
                            'Origin Country', ticketDetails.originCountry),
                        _buildDetailItem(
                            'Origin City', ticketDetails.originCity),
                        _buildDetailItem('Destination Country',
                            ticketDetails.destinationCountry),
                        _buildDetailItem(
                            'Destination City', ticketDetails.destinationCity),
                        _buildDetailItem('Created By', ticketDetails.createdBy),
                        _buildDetailItem(
                            'Department', ticketDetails.department),
                        _buildDetailItem('Department Category',
                            ticketDetails.departmentCategory),
                        _buildDetailItem(
                            'Ticket Status', ticketDetails.ticketStatus),
                        _buildDetailItem(
                            'Status', ticketDetails.status?.toString() ?? ''),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDetailsSection(String title, List<Widget> details) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primarySwatch,
              ),
            ),
            const SizedBox(height: 8.0),
            ...details,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              '$value',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
