import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:wifi_scan/wifi_scan.dart';

class RadioWifiViewModel extends ChangeNotifier {

  final _controller =
      StreamController<List<WiFiAccessPoint>>.broadcast();

  Stream<List<WiFiAccessPoint>> get stream => _controller.stream;

  bool _isRunning = false;


  Future<void> startAutoScan() async {
    if (_isRunning) return;
    _isRunning = true;

    while (_isRunning) {
      final can = await WiFiScan.instance.canStartScan(
        askPermissions: true,
      );

      if (can == CanStartScan.yes) {
        await WiFiScan.instance.startScan();
        await Future.delayed(const Duration(seconds: 1));

        final results =
            await WiFiScan.instance.getScannedResults();

        _controller.add(results);
      }
    }
  }

  Stream<WiFiAccessPoint?> streamByBssid(String bssid) {
    return stream.map((list) {
      try {
        return list.firstWhere(
          (ap) => ap.bssid == bssid,
        );
      } catch (_) {
        return null;
      }
    });
  }

  void stopAutoScan() {
    _isRunning = false;
  }

  @override
  void dispose() {
    stopAutoScan();
    _controller.close();
    super.dispose();
  }
}
