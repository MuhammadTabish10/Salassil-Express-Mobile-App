import 'package:flutter/material.dart';
import 'package:animated_card/animated_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:salsel_express/config/token_provider.dart';
import 'package:salsel_express/constant/routes.dart';
import 'package:salsel_express/model/awb.dart';
import 'package:salsel_express/service/awb_service.dart';
import 'package:salsel_express/util/themes.dart';

class JobDetailView extends StatefulWidget {
  const JobDetailView({Key? key}) : super(key: key);

  @override
  State<JobDetailView> createState() => _JobDetailViewState();
}

class _JobDetailViewState extends State<JobDetailView> {
  late Future<Awb> awbDetailsFuture;
  late int awbId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final id = arguments['id'] as String?; // Receive as String
    awbId = int.parse(id!); // Convert String to int
    awbDetailsFuture =
        fetchAwbDetails(awbId.toString()); // Convert int to String if necessary
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
            icon: const Icon(Icons.save), // Save icon
            onPressed: () {
              // Add functionality to save data here
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
      body: FutureBuilder<Awb>(
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
                          'Shipper Contact', awbDetails.shipperContactNumber),
                      _buildDetailItem(
                          'Pickup Address', awbDetails.pickupAddress),
                      _buildDetailItem(
                          'Shipper Ref no', awbDetails.shipperRefNumber),
                      _buildDetailItem(
                          'Origin Country', awbDetails.originCountry),
                      _buildDetailItem('Origin City', awbDetails.originCity),
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
                        _buildDetailItem(
                            'Contact no', awbDetails.recipientsContactNumber),
                        _buildDetailItem(
                            'Delivery Address', awbDetails.deliveryAddress),
                        _buildDetailItem('Destination Country',
                            awbDetails.destinationCountry),
                        _buildDetailItem(
                            'Destination City', awbDetails.destinationCity),
                      ],
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

// class JobDetailView extends StatefulWidget {
//   const JobDetailView({Key? key}) : super(key: key);

//   @override
//   State<JobDetailView> createState() => _JobDetailViewState();
// }

// class _JobDetailViewState extends State<JobDetailView> {
//   late Future<Awb> awbDetailsFuture;
//   late String awbId;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     awbId = ModalRoute.of(context)!.settings.arguments as String;
//     awbDetailsFuture = fetchAwbDetails(awbId);
//   }

//   Future<Awb> fetchAwbDetails(String awbId) async {
//     String token = Provider.of<TokenProvider>(context, listen: false).token;
//     try {
//       Awb awbDetails = await getAwbById(awbId, token);
//       return awbDetails;
//     } catch (error) {
//       debugPrint('Error fetching awb details: $error');
//       rethrow;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "AWB Details",
//           style: TextStyle(color: Colors.white),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.account_circle),
//             onPressed: () {
//               Navigator.of(context).pushNamed(userProfile);
//             },
//             iconSize: 28.0,
//             color: Theme.of(context).colorScheme.onPrimary,
//           ),
//         ],
//         backgroundColor: primarySwatch,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: AnimatedCard(
//         direction: AnimatedCardDirection.top,
//         duration: const Duration(milliseconds: 500),
//         child: FutureBuilder<Awb>(
//           future: awbDetailsFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else {
//               Awb awbDetails = snapshot.data!;
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildDetailsSection('AWB Details', 
//                     [
//                       _buildDetailItem('Awb id', awbDetails.id),
//                       _buildDetailItem('Shipper Contact', awbDetails.shipperContactNumber),
//                       _buildDetailItem('Pickup Address', awbDetails.pickupAddress),
//                       _buildDetailItem('Shipper Ref no', awbDetails.shipperRefNumber),
//                       _buildDetailItem('Origin Country', awbDetails.originCountry),
//                       _buildDetailItem('Origin City', awbDetails.originCity),
//                     ],),
//                     _buildDetailsSection('Recipient Details', 
//                     [
//                       _buildDetailItem('Recipient Name',awbDetails.recipientsName),
//                       _buildDetailItem('Contact no',awbDetails.recipientsContactNumber),
//                       _buildDetailItem('Delivery Address',awbDetails.deliveryAddress),
//                       _buildDetailItem('Destination Country',awbDetails.destinationCountry),
//                       _buildDetailItem('Destination City',awbDetails.destinationCity),
//                     ],),
//                     const SizedBox(height: 16.0),
//                               _buildDropdown(),
//                   ),
                              
                              
//                             ]),
//                           ],
//                         ),
//                       ),
                      // Positioned(
                      //   top: 8.0,
                      //   right: 8.0,
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       Navigator.of(context).pushNamed(createAwb);
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       foregroundColor: Colors.white,
                      //       backgroundColor: primarySwatch,
                      //       elevation: 3.0,
                      //     ),
                      //     child: const Text(
                      //       'Save',
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ),
                      // ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }


//  Widget _buildDetailsSection(String title, List<Widget> details) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(bottom: 8.0),
//           child: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: primarySwatch,
//             ),
//           ),
//         ),
//         ...details,
//         const SizedBox(height: 16.0),
//       ],
//     );
//   }

//   Widget _buildDetailItem(String label, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             '$label:',
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(width: 8.0),
//           Expanded(
//             child: Text(
//               '$value',
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }