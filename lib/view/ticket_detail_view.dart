import 'package:flutter/material.dart';
import 'package:animated_card/animated_card.dart';

class TicketDetailView extends StatelessWidget {
  final Map<String, dynamic> ticketDetails;
  final String ticketTitle;
  final Map<String, dynamic> hardcodedData;

  const TicketDetailView({
    Key? key,
    required this.ticketDetails,
    required this.ticketTitle,
    required this.hardcodedData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details'),
      ),
      body: AnimatedCard(
        direction: AnimatedCardDirection.top,
        duration: const Duration(milliseconds: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  ticketTitle,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailsSection('Shipper Details', [
                        _buildDetailItem(
                            'Shipper Name', hardcodedData['shipperName']),
                        _buildDetailItem(
                            'Shipper Contact', hardcodedData['shipperContact']),
                        _buildDetailItem(
                            'Pickup Address', hardcodedData['pickupAddress']),
                        _buildDetailItem(
                            'Shipper Ref no', hardcodedData['shipperRefNo']),
                        _buildDetailItem(
                            'Origin Country', hardcodedData['originCountry']),
                        _buildDetailItem(
                            'Origin City', hardcodedData['originCity']),
                      ]),
                      _buildDetailsSection('Recipient Details', [
                        _buildDetailItem(
                            'Recipient Name', hardcodedData['recipientName']),
                        _buildDetailItem(
                            'Contact no', hardcodedData['recipientContact']),
                        _buildDetailItem('Delivery Address',
                            hardcodedData['deliveryAddress']),
                        _buildDetailItem('Destination Country',
                            hardcodedData['destinationCountry']),
                        _buildDetailItem('Destination City',
                            hardcodedData['destinationCity']),
                      ]),
                      _buildDetailsSection('Other Details', [
                        _buildDetailItem(
                            'Department', hardcodedData['department']),
                        _buildDetailItem('Department Category',
                            hardcodedData['departmentCategory']),
                        _buildDetailItem(
                            'Pickup Date', hardcodedData['pickupDate']),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection(String title, List<Widget> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...details,
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildDetailItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('$value'),
        ],
      ),
    );
  }
}
