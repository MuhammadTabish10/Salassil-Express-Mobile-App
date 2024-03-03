// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:animated_card/animated_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:salsel_express/config/token_provider.dart';
import 'package:salsel_express/constant/routes.dart';
import 'package:salsel_express/model/awb.dart';
import 'package:salsel_express/model/product_field_values.dart';
import 'package:salsel_express/service/awb_service.dart';
import 'package:salsel_express/service/home_service.dart';
import 'package:salsel_express/util/custom_toast.dart';
import 'package:salsel_express/util/themes.dart';

class JobDetailView extends StatefulWidget {
  const JobDetailView({Key? key}) : super(key: key);

  @override
  State<JobDetailView> createState() => _JobDetailViewState();
}

class _JobDetailViewState extends State<JobDetailView> {
  late Future<Awb> awbDetailsFuture;
  late int awbId;
  bool _isLoading = false;
  late String _selectedStatus;
  List<ProductFieldValues> _productFieldValues = [];
  late Awb awb;

  @override
  void initState() {
    super.initState();
    _selectedStatus = '';
  }

  void _loadProductFieldValues() async {
    setState(() {
      _isLoading = true; // Start loading
    });
    try {
      String token = Provider.of<TokenProvider>(context, listen: false).token;

// Fetch AWB status
      awb = await getAwbByUniqueNumber(
          (await awbDetailsFuture).uniqueNumber ?? 0, token);

      // Set default value of dropdown to AWB status
      _selectedStatus = awb.awbStatus!;

      // Fetch product field values
      _productFieldValues = await getProductFieldValues('Awb Status', token);
      setState(() {
        _isLoading = false; // Stop loading
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading
      });
      debugPrint('Error fetching product field values: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final id = arguments['id'] as String?; // Receive as String
    awbId = int.parse(id!); // Convert String to int
    awbDetailsFuture =
        fetchAwbDetails(awbId.toString()); // Convert int to String if necessary
    _loadProductFieldValues();
  }

  Future<Awb> fetchAwbDetails(String awbId) async {
    String token = Provider.of<TokenProvider>(context, listen: false).token;
    try {
      Awb awbDetails = await getAwbById(awbId, token);
      return awbDetails;
    } catch (error) {
      debugPrint('Error fetching awb details: $error');
      rethrow;
    }
  }

  void showAssignStatusPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit AWB Status'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<String>(
                value: _selectedStatus,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
                items: _productFieldValues
                    .map<DropdownMenuItem<String>>((ProductFieldValues value) {
                  return DropdownMenuItem<String>(
                    value: value.name ?? '',
                    child: Text(value.name ?? ''),
                  );
                }).toList(),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Start loading
                setState(() {
                  _isLoading = true;
                });

                try {
                  // Get the token
                  String token =
                      Provider.of<TokenProvider>(context, listen: false).token;

                  // Call the API to update AWB status
                  await updateAwbStatusOnScan(
                      awb.uniqueNumber ?? 0, // Convert scannedResult to int
                      _selectedStatus, // Use the selected status
                      token);

                  // Stop loading
                  setState(() {
                    _isLoading = false;
                  });

                  // Close the dialog
                  
                  Navigator.of(context).pushNamed(homeRoute);
                } catch (e) {
                  // Stop loading
                  setState(() {
                    _isLoading = false;
                  });

                  debugPrint('Error updating AWB status: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primarySwatch,
              ),
              child: const Text('Edit', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AWB Details",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              OverlayEntry?
                  loaderOverlay; // Declare the OverlayEntry variable with null safety
              try {
                // Show loader overlay
                loaderOverlay = OverlayEntry(
                  builder: (BuildContext context) => Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: SpinKitSpinningLines(
                        color: primarySwatch,
                      ),
                    ),
                  ),
                );
                Overlay.of(context).insert(
                    loaderOverlay); // Ensure Overlay.of(context) is not null

                // Download AWB PDF
                await downloadAwbPdf(awbId);

                // Remove loader overlay when download is complete
                loaderOverlay.remove();
                CustomToast.showAlert(
                    context, 'AWB PDF downloaded successfully.');
              } catch (e) {
                // Remove loader overlay if an error occurs
                if (loaderOverlay != null) {
                  loaderOverlay.remove();
                }
                CustomToast.showAlert(context, 'Failed to download AWB PDF.');
              }
            },
            iconSize: 28.0,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).pushNamed(userProfile);
            },
            iconSize: 28.0,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ],
        backgroundColor: primarySwatch,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitSpinningLines(color: primarySwatch),
            )
          : FutureBuilder<Awb>(
              future: awbDetailsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitSpinningLines(color: primarySwatch),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  Awb awbDetails = snapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedCard(
                          direction: AnimatedCardDirection.top,
                          duration: const Duration(milliseconds: 500),
                          child: _buildDetailsSection('Shipper Details', [
                            _buildDetailItem('Awb id', awbDetails.id),
                            _buildDetailItem('Shipper Contact',
                                awbDetails.shipperContactNumber),
                            _buildDetailItem(
                                'Pickup Address', awbDetails.pickupAddress),
                            _buildDetailItem(
                                'Shipper Ref no', awbDetails.shipperRefNumber),
                            _buildDetailItem(
                                'Origin Country', awbDetails.originCountry),
                            _buildDetailItem(
                                'Origin City', awbDetails.originCity),
                          ]),
                        ),
                        AnimatedCard(
                          direction: AnimatedCardDirection.top,
                          duration: const Duration(milliseconds: 500),
                          child: _buildDetailsSection(
                            'Recipient Details',
                            [
                              _buildDetailItem(
                                  'Recipient Name', awbDetails.recipientsName),
                              _buildDetailItem('Contact no',
                                  awbDetails.recipientsContactNumber),
                              _buildDetailItem('Delivery Address',
                                  awbDetails.deliveryAddress),
                              _buildDetailItem('Destination Country',
                                  awbDetails.destinationCountry),
                              _buildDetailItem('Destination City',
                                  awbDetails.destinationCity),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            showAssignStatusPopup(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                primarySwatch, // Change the color here
                          ),
                          child: const Text(
                            'Edit Status',
                            style: TextStyle(
                              color: Colors.white, // Text color
                            ),
                          ),
                        ),
                      ],
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
