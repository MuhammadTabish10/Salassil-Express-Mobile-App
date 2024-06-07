import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:salsel_express/config/token_provider.dart';
import 'package:salsel_express/constant/awb_status_constants.dart';
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
  late List<Awb> filteredAwb;
  late User user;
  String? selectedStatus = "All";
  bool initialLoadCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadAwbAndUser();
  }

  void _loadAwbAndUser() async {
    try {
      user = await fetchLoggedInUser();
      List<Awb> awbs = await fetchAwbsFirstTime(user.id!);
      setState(() {
        awbsFuture = Future.value(awbs);
        initialLoadCompleted = true;
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

  Future<List<Awb>> fetchAwbs(String status) async {
    try {
      String token = Provider.of<TokenProvider>(context, listen: false).token;
      return await getAllAwbByAssignedUser(user.id!, status, token);
    } catch (error) {
      debugPrint('Error fetching awbs: $error');
      rethrow;
    }
  }

  Future<List<Awb>> fetchAwbsFirstTime(int userId) async {
    try {
      String token = Provider.of<TokenProvider>(context, listen: false).token;
      return await getAllAwbByAssignedUserId(user.id!, token);
    } catch (error) {
      debugPrint('Error fetching awbs: $error');
      rethrow;
    }
  }

  void _onStatusSelected(String? status) {
    setState(() {
      selectedStatus = status;
      if (status == "All") {
        awbsFuture = fetchAwbsFirstTime(user.id!);
    } else {
        awbsFuture = fetchAwbs(status!);
    }
    });
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
                child: PopupMenuButton<String?>(
                  offset: const Offset(0, 50),
                  onSelected: _onStatusSelected,
                  itemBuilder: (BuildContext context) {
                    return [
                      "All",
                      awbCreated,
                      pickedUp,
                      arrivedInStation,
                      heldInStation,
                      departFromStation,
                      arrivedInHub,
                      departFromHub,
                      outForDelivery,
                      delivered
                    ].map((String? value) {
                      return PopupMenuItem<String?>(
                        value: value,
                        child: Text(value!),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(selectedStatus!),
                        const Icon(Icons.arrow_drop_down),
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
                    filteredAwb = snapshot.data!;
                    if (!initialLoadCompleted) {
                      return const SizedBox
                          .shrink(); // Hide message during initial load
                    } else if (filteredAwb.isEmpty) {
                      return const Center(
                        child: Text('No AWBs for the selected status'),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredAwb.length,
                      itemBuilder: (context, index) {
                        return AnimatedCard(
                          direction: AnimatedCardDirection.right,
                          duration: const Duration(milliseconds: 500),
                          child: CardWidget(
                            title: filteredAwb[index].shipperName ?? '',
                            name: filteredAwb[index].uniqueNumber.toString(),
                            status: filteredAwb[index].awbStatus ?? '',
                            button: TextButton(
                              onPressed: () {
                                _onViewPressed(filteredAwb[index].id ?? 0);
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
                    return Container();
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
