// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:animated_card/animated_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:salsel_express/config/token_provider.dart';
import 'package:salsel_express/constant/routes.dart';
import 'package:salsel_express/model/awb.dart';
import 'package:salsel_express/model/awb_history.dart';
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
  AwbHistory? awbHistory;
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
    fetchAwbHistory(awbId);
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

  void fetchAwbHistory(int awbId) async {
    String token = Provider.of<TokenProvider>(context, listen: false).token;
    try {
      AwbHistory awbHistoryData = await getAwbHistoryWithComment(awbId, token);
      awbHistory = awbHistoryData;
    } catch (error) {
      debugPrint('Error fetching awb history details: $error');
      rethrow;
    }
  }

  void showAssignStatusPopup(BuildContext context) {
    TextEditingController commentController =
        TextEditingController(); // Controller for the comment text field

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit AWB Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatus = newValue!;
                    });
                  },
                  items: _productFieldValues.map<DropdownMenuItem<String>>(
                    (ProductFieldValues value) {
                      return DropdownMenuItem<String>(
                        value: value.name ?? '',
                        child: Text(value.name ?? ''),
                      );
                    },
                  ).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    labelText: 'Add Comment (optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
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
                              Provider.of<TokenProvider>(context, listen: false)
                                  .token;

                          // Check if the status is changed
                          if (_selectedStatus != awb.awbStatus) {
                            // Call the API to update AWB status with selected status and comment
                            await updateAwbStatusWithComment(
                              awb.uniqueNumber ??
                                  0, // Convert scannedResult to int
                              _selectedStatus, // Use the selected status
                              commentController.text,
                              token,
                            );

                            // Stop loading
                            setState(() {
                              _isLoading = false;
                            });

                            // Close the dialog
                            Navigator.of(context)
                                .popUntil(ModalRoute.withName(homeRoute));
                            Navigator.of(context).pushNamed(homeRoute);
                          } else {
                            // Stop loading
                            setState(() {
                              _isLoading = false;
                            });

                            CustomToast.showAlert(context,
                                'AWB status is already set to $_selectedStatus.');
                          }
                        } catch (e) {
                          // Stop loading
                          setState(() {
                            _isLoading = false;
                          });

                          debugPrint('Error updating AWB status: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primarySwatch[500],
                      ),
                      child: const Text('Edit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showEditCommentPopup(BuildContext context) {
    TextEditingController commentController =
        TextEditingController(); // Controller for the comment text field

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Comment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    labelText: 'Enter Comment',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String comment = commentController.text.trim();
                        if (comment.isNotEmpty) {
                          // Start loading
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            // Get the token
                            String token = Provider.of<TokenProvider>(context,
                                    listen: false)
                                .token;

                            // Call the API to update the comment
                            await updateComment(
                              awbId,
                              comment,
                              token,
                            );

                            // Stop loading
                            setState(() {
                              _isLoading = false;
                            });

                            // Close the dialog
                            Navigator.of(context)
                                .popUntil(ModalRoute.withName(homeRoute));
                            Navigator.of(context).pushNamed(homeRoute);
                          } catch (e) {
                            // Stop loading
                            setState(() {
                              _isLoading = false;
                            });

                            debugPrint('Error updating comment: $e');
                          }
                        } else {
                          // Show an error message if comment is empty
                          CustomToast.showAlert(
                              context, 'Please enter a comment.');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primarySwatch[500],
                      ),
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                            _buildDetailItem(
                                'Shipper Name', awbDetails.shipperName),
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
                        AnimatedCard(
                          direction: AnimatedCardDirection.top,
                          duration: const Duration(milliseconds: 500),
                          child: _buildDetailsSection(
                            'Awb Status Details',
                            [
                              _buildDetailItem(
                                  'Awb Status', awbHistory?.awbStatus),
                              _buildDetailItem(
                                  'Awb Comment', awbHistory?.comment),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: ElevatedButton(
                                onPressed: () {
                                  showAssignStatusPopup(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: primarySwatch[500],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 5,
                                  ),
                                  child: Text(
                                    'Edit Status',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                                width: 10), // Add spacing between buttons
                            Flexible(
                              fit: FlexFit.tight,
                              child: ElevatedButton(
                                onPressed: () {
                                  showEditCommentPopup(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: primarySwatch[500],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 5,
                                  ),
                                  child: Text(
                                    'Edit Comment',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
