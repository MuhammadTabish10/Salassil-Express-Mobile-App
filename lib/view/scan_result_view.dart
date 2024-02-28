// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:salsel_express/config/token_provider.dart';
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

  void showAssignStatusPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Assign AWB Status'),
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
                      int.parse(
                          widget.scannedResult), // Convert scannedResult to int
                      _selectedStatus, // Use the selected status
                      token);

                  // Stop loading
                  setState(() {
                    _isLoading = false;
                  });

                  // Close the dialog
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
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
              child:
                  const Text('Assign', style: TextStyle(color: Colors.white)),
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
        title: const Text('Scan Result', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitSpinningLines(color: primarySwatch),
            )
          : Center(
              child: Column(
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
                      backgroundColor: primarySwatch, // Change the color here
                    ),
                    child: const Text(
                      'Assign Status',
                      style: TextStyle(
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
