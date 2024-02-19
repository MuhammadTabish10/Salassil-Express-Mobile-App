import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:salsel_express/config/token_provider.dart';
import 'package:salsel_express/constant/routes.dart';
import 'package:animated_card/animated_card.dart';
import 'package:salsel_express/model/awb.dart';
import 'package:salsel_express/model/user.dart';
import 'package:salsel_express/service/awb_service.dart';
import 'package:salsel_express/service/home_service.dart';
import 'package:salsel_express/util/themes.dart';
import 'package:salsel_express/widget/card_widget.dart';

class ShowJobsView extends StatefulWidget {
  const ShowJobsView({Key? key}) : super(key: key);

  @override
  State<ShowJobsView> createState() => _ShowJobsState();
}

class _ShowJobsState extends State<ShowJobsView> {
  late Future<List<Awb>> awbsFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    _loadAwbAndUser();
  }

  void _loadAwbAndUser() async {
    try {
      User user = await fetchLoggedInUser();
      List<Awb> awbs = await fetchAwbs(true, user.name);
      setState(() {
        awbsFuture = Future.value(awbs);
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<User> fetchLoggedInUser() async {
    try {
      String token = Provider.of<TokenProvider>(context, listen: false).token;
      User loggedInUser = await getLoggedInUser(token);
      return loggedInUser;
    } catch (error) {
      debugPrint('Error fetching User: $error');
      rethrow;
    }
  }

  Future<List<Awb>> fetchAwbs(bool status, String? user) async {
    try {
      String token = Provider.of<TokenProvider>(context, listen: false).token;
      List<Awb> fetchedAwbs =
          await getAllAwbByAssignedUser(user!, status, token);
      return fetchedAwbs;
    } catch (error) {
      debugPrint('Error fetching awbs: $error');
      rethrow;
    }
  }

  void _onViewPressed(int id) {
    Navigator.pushNamed(
      context,
      jobDetail,
      arguments: {'id': id.toString()}, // Convert int to String
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Themes.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter by Status:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(createAwb);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primarySwatch,
                      elevation: 3.0,
                    ),
                    child: const Text(
                      'Create AWB',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              AnimatedCard(
                direction: AnimatedCardDirection.top,
                duration: const Duration(milliseconds: 500),
                child: PopupMenuButton<String>(
                  offset: const Offset(0, 50),
                  onSelected: (value) {
                    setState(() {
                      // selectedStatus = value;
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
                        horizontal: 24.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("selectedStatus"),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              FutureBuilder<List<Awb>>(
                future: awbsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitSpinningLines(color: primarySwatch),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return AnimatedCard(
                          direction: AnimatedCardDirection.right,
                          duration: const Duration(milliseconds: 500),
                          child: CardWidget(
                            title: snapshot.data![index].shipperName ?? '',
                            name: '',
                            status: snapshot.data![index].awbStatus ?? '',
                            button: TextButton(
                              onPressed: () {
                                _onViewPressed(snapshot.data![index].id ?? 0);
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
                  } else {
                    return Container(); // Placeholder, adjust as needed
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
// import 'package:salsel_express/config/token_provider.dart';
// import 'package:salsel_express/constant/routes.dart';
// import 'package:animated_card/animated_card.dart';
// import 'package:salsel_express/model/awb.dart';
// import 'package:salsel_express/model/user.dart';
// import 'package:salsel_express/service/awb_service.dart';
// import 'package:salsel_express/service/home_service.dart';
// import 'package:salsel_express/util/themes.dart';
// import 'package:salsel_express/view/job_detail_view.dart';
// import 'package:salsel_express/widget/card_widget.dart';

// class ShowJobsView extends StatefulWidget {
//   const ShowJobsView({Key? key}) : super(key: key);

//   @override
//   State<ShowJobsView> createState() => _ShowJobsState();
// }

// class _ShowJobsState extends State<ShowJobsView> {
//   late Future<List<Awb>> awbsFuture;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadAwbAndUser();
//   }

//   void _loadAwbAndUser() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       User user = await fetchLoggedInUser();
//       List<Awb> awbs = await fetchAwbs(true, user.name);
//       setState(() {
//         _isLoading = false;
//         awbsFuture = Future.value(awbs);
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       debugPrint('Error fetching data: $e');
//     }
//   }

//   Future<User> fetchLoggedInUser() async {
//     try {
//       String token = Provider.of<TokenProvider>(context, listen: false).token;
//       User loggedInUser = await getLoggedInUser(token);
//       return loggedInUser;
//     } catch (error) {
//       debugPrint('Error fetching User: $error');
//       rethrow;
//     }
//   }

//   Future<List<Awb>> fetchAwbs(bool status, String? user) async {
//     try {
//       String token = Provider.of<TokenProvider>(context, listen: false).token;
//       List<Awb> fetchedAwbs =
//           await getAllAwbByAssignedUser(user!, status, token);
//       return fetchedAwbs;
//     } catch (error) {
//       debugPrint('Error fetching awbs: $error');
//       rethrow;
//     }
//   }

//   void _onViewPressed(int id) {
//     Navigator.pushNamed(
//       context,
//       jobDetail,
//       arguments: id.toString(),
//     );
//   }

//   @override
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
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
//             color: colorScheme.onPrimary,
//           ),
//         ],
//         backgroundColor: primarySwatch,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: AnimatedCard(
//         direction: AnimatedCardDirection.top,
//         duration: const Duration(milliseconds: 500),
//         child: FutureBuilder<List<Awb>>(
//           future: awbsFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                   child: SpinKitSpinningLines(color: primarySwatch));
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else {
//               List<Awb>? awbs = snapshot.data;
//               return ListView.builder(
//                 itemCount: awbs?.length ?? 0,
//                 itemBuilder: (context, index) {
//                   Awb awb = awbs![index];
//                   return AnimatedCard(
//                     direction: AnimatedCardDirection.right,
//                     duration: const Duration(milliseconds: 500),
//                     child: CardWidget(
//                       title: awb.shipperName ?? '',
//                       name: '',
//                       status: awb.awbStatus ?? '',
//                       button: TextButton(
//                         onPressed: () {
//                           _onViewPressed(awb.id!);
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
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
