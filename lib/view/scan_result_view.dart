import 'package:flutter/material.dart';

class ScanResultPage extends StatelessWidget {
  final String scannedResult;

  const ScanResultPage(this.scannedResult, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Scanned Result:',
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              scannedResult,
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
