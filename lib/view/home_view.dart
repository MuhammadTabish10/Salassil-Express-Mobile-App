// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:salsel_express/config/token_provider.dart';
import 'package:salsel_express/constant/routes.dart';
import 'package:salsel_express/service/home_service.dart';
import 'package:salsel_express/util/helper.dart';
import 'package:salsel_express/util/themes.dart';
import 'package:salsel_express/view/scan_result_view.dart';
import 'package:salsel_express/view/show_jobs_view.dart';
import 'package:salsel_express/view/show_tickets_view.dart';
import 'package:salsel_express/widget/bottom_navigation_widget.dart';
import 'package:salsel_express/widget/general_widgets.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  int? awbCount;
  int? ticketCount;

  @override
  void initState() {
    super.initState();
    _fetchCountsOnPageLoad();
  }

  void _fetchCountsOnPageLoad() async {
    String token = Provider.of<TokenProvider>(context, listen: false).token;
    try {
      awbCount = await getAwbCount(token);
      ticketCount = await getTicketCount(token);
      setState(() {}); // Trigger a rebuild after counts are fetched
    } catch (error) {
      debugPrint('Error fetching counts: $error');
    }
  }

  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 1.0,
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          getAppBarTitle(_currentIndex),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
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
      ),
      body: awbCount == null || ticketCount == null
          ? const Center(
              child: SpinKitSpinningLines(color: primarySwatch),
            ) // Show loading indicator while counts are being fetched
          : PageView(
              controller: _pageController,
              children: [
                Container(
                  color: Themes.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildCard('Scan', Icons.qr_code_scanner,
                            showCount: false, onTap: () => _startScan()),
                        const SizedBox(height: 16.0),
                        buildCard('My Jobs', Icons.assignment, count: awbCount!,
                            onTap: () {
                          navigateToPage(2);
                        }),
                        const SizedBox(height: 16.0),
                        buildCard('Tickets', Icons.confirmation_number,
                            count: ticketCount!, onTap: () {
                          navigateToPage(1);
                        }),
                      ],
                    ),
                  ),
                ),
                const ShowTicketsView(),
                const ShowJobsView(),
              ],
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            _pageController.jumpToPage(index);
          } else if (index == 0) {
            _pageController.jumpToPage(index);
          } else {
            navigateToPage(index);
          }
        },
      ),
    );
  }

  Future<void> _startScan() async {
    try {
      var result = await BarcodeScanner.scan(
        options: const ScanOptions(
          useCamera: 0,
          autoEnableFlash: false,
          restrictFormat: [
            BarcodeFormat.qr,
            BarcodeFormat.code128,
            BarcodeFormat.code39,
            BarcodeFormat.code93,
            BarcodeFormat.ean8,
            BarcodeFormat.ean13,
          ],
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanResultPage(result.rawContent),
        ),
      );
    } catch (e) {
      debugPrint('Error during scanning: $e');
    }
  }

  void navigateToPage(int pageIndex) {
    setState(() {
      _currentIndex = pageIndex;
      _pageController.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }
}
