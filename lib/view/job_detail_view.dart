import 'package:flutter/material.dart';
import 'package:animated_card/animated_card.dart';
import 'package:salsel_express/constant/routes.dart';
import 'package:salsel_express/util/themes.dart';

class JobDetailView extends StatelessWidget {
  final Map<String, dynamic> jobDetails;
  final String jobTitle;
  final Map<String, dynamic> hardcodedData;
  final String? selectedOption;

  const JobDetailView(
      {Key? key,
      required this.jobDetails,
      required this.jobTitle,
      required this.hardcodedData,
      required this.selectedOption})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          jobTitle,
          style: const TextStyle(
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
      body: AnimatedCard(
        direction: AnimatedCardDirection.top,
        duration: const Duration(milliseconds: 500),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailsSection('Shipper Details', [
                              _buildDetailItem(
                                'Shipper Name',
                                hardcodedData['shipperName'],
                              ),
                              _buildDetailItem(
                                'Shipper Contact',
                                hardcodedData['shipperContact'],
                              ),
                              _buildDetailItem(
                                'Pickup Address',
                                hardcodedData['pickupAddress'],
                              ),
                              _buildDetailItem(
                                'Shipper Ref no',
                                hardcodedData['shipperRefNo'],
                              ),
                              _buildDetailItem(
                                'Origin Country',
                                hardcodedData['originCountry'],
                              ),
                              _buildDetailItem(
                                'Origin City',
                                hardcodedData['originCity'],
                              ),
                            ]),
                            _buildDetailsSection('Recipient Details', [
                              _buildDetailItem(
                                'Recipient Name',
                                hardcodedData['recipientName'],
                              ),
                              _buildDetailItem(
                                'Contact no',
                                hardcodedData['recipientContact'],
                              ),
                              _buildDetailItem(
                                'Delivery Address',
                                hardcodedData['deliveryAddress'],
                              ),
                              _buildDetailItem(
                                'Destination Country',
                                hardcodedData['destinationCountry'],
                              ),
                              _buildDetailItem(
                                'Destination City',
                                hardcodedData['destinationCity'],
                              ),
                              const SizedBox(height: 16.0),
                              _buildDropdown(),
                            ]),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(createAwb);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primarySwatch,
                            elevation: 3.0,
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primarySwatch,
            ),
          ),
        ),
        ...details,
        const SizedBox(height: 16.0),
      ],
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

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Select Option:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 8.0),
          // Use DropdownButton widget
          DropdownButton<String>(
            value: selectedOption,
            onChanged: (String? newValue) {
              // Handle dropdown value change
              // You can perform actions based on the selected option here
            },
            items: <String>['True', 'False'].map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
