import 'package:flutter/material.dart';
import 'package:info_wifi/features/graph_cart.dart';
import 'package:wifi_scan/wifi_scan.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool isLoading = false;
  List<WiFiAccessPoint> accessPoints = [];

  @override
  void initState() {
    super.initState();
  }

  void _startScan() async {
    setState(() {
      isLoading = true;
    });
    final can = await WiFiScan.instance.canStartScan(askPermissions: true);
    switch (can) {
      case CanStartScan.yes:
        final isScanning = await WiFiScan.instance.startScan();
        if (isScanning) {
          _getScannedResults();
        }
        break;
      case CanStartScan.notSupported:
        print("Not supported !");
      case CanStartScan.noLocationPermissionRequired:
        print("Location noLocationPermissionRequired !");
      case CanStartScan.noLocationPermissionDenied:
        print("Location noLocationPermissionDenied !");
      case CanStartScan.noLocationPermissionUpgradeAccuracy:
        print("Location noLocationPermissionUpgradeAccuracy !");
      case CanStartScan.noLocationServiceDisabled:
        print("Location noLocationServiceDisabled !");
      case CanStartScan.failed:
        print("Location failed !");
    }

    setState(() {
      isLoading = false;
    });
  }

  void _getScannedResults() async {
    final can = await WiFiScan.instance.canGetScannedResults(
      askPermissions: true,
    );
    switch (can) {
      case CanGetScannedResults.yes:
        accessPoints = await WiFiScan.instance.getScannedResults();
        break;
      case CanGetScannedResults.notSupported:
        print("Not supported !");
      case CanGetScannedResults.noLocationPermissionRequired:
        print("Location noLocationPermissionRequired !");
      case CanGetScannedResults.noLocationPermissionDenied:
        print("Location noLocationPermissionDenied !");
      case CanGetScannedResults.noLocationPermissionUpgradeAccuracy:
        print("Location noLocationPermissionUpgradeAccuracy !");
      case CanGetScannedResults.noLocationServiceDisabled:
        print("Location noLocationServiceDisabled !");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              _startScan();
                            },
                            child: const Text("Scan WIFI"),
                          ),
                        ],
                      ),
                      if (accessPoints.isEmpty) Center(child: Text("....")),
                      if (accessPoints.isNotEmpty)
                        Expanded(
                          child: GraphCart(accessPointDatas: accessPoints),
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
