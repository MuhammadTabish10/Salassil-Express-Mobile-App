// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:salsel_express/config/token_provider.dart';
import 'package:salsel_express/constant/routes.dart';
import 'package:salsel_express/model/awb.dart';
import 'package:salsel_express/model/product_field_values.dart';
import 'package:salsel_express/service/home_service.dart';
import 'package:salsel_express/util/themes.dart';

class ScanResultPage extends StatefulWidget {
  final String scannedResult;

  const ScanResultPage(this.scannedResult, {Key? key}) : super(key: key);

  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  late String _selectedStatus;
  List<ProductFieldValues> _productFieldValues =
      []; // Initialize with empty list
  bool _isLoading = false; // Track loading state
  bool _awbFound = true;

  @override
  void initState() {
    super.initState();
    _selectedStatus = '';
    _loadProductFieldValues();
  }

  void _loadProductFieldValues() async {
    setState(() {
      _isLoading = true; // Start loading
    });
    try {
      String token = Provider.of<TokenProvider>(context, listen: false).token;

      // Fetch AWB status
      Awb awb = await getAwbByUniqueNumber(
          int.parse(widget.scannedResult), // Convert scannedResult to int
          token);

      // Set default value of dropdown to AWB status
      _selectedStatus = awb.awbStatus!;
      _awbFound = true;

      // Fetch product field values
      _productFieldValues = await getProductFieldValues('Awb Status', token);
      setState(() {
        _isLoading = false; // Stop loading
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading
        _awbFound = false;
      });
      debugPrint('Error fetching product field values: $e');
    }
  }

  void showAssignStatusPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context),
        );
      },
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 10),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Assign AWB Status',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<String>(
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
              );
            },
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
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
                        Provider.of<TokenProvider>(context, listen: false)
                            .token;

                    // Call the API to update AWB status
                    await updateAwbStatusOnScan(
                      int.parse(widget.scannedResult),
                      _selectedStatus,
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

                    debugPrint('Error updating AWB status: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primarySwatch,
                ),
                child: const Text(
                  'Assign',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitSpinningLines(color: primarySwatch),
            )
          : Center(
              child: _awbFound
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Scanned Result:',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          widget.scannedResult,
                          style: const TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _selectedStatus, // Display AWB status
                          style: const TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
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
                            'Assign Status',
                            style: TextStyle(
                              color: Colors.white, // Text color
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      'Awb that you scanned is not found in our system. Please scan a valid AWB.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0),
                    ),
            ),
    );
  }
}
