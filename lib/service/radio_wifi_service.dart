import 'dart:async';
import 'package:wifi_scan/wifi_scan.dart';

class RadioWifiService {
  final _controller =
      StreamController<List<WiFiAccessPoint>>.broadcast();

  Stream<List<WiFiAccessPoint>> get stream => _controller.stream;

  bool _isRunning = false;

  Future<void> start() async {
    if (_isRunning) return;
    _isRunning = true;

    while (_isRunning) {
      final can = await WiFiScan.instance.canStartScan(
        askPermissions: true,
      );

      if (can == CanStartScan.yes) {
        await WiFiScan.instance.startScan();
        await Future.delayed(const Duration(seconds: 3));

        final result =
            await WiFiScan.instance.getScannedResults();

        _controller.add(result);
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }

  void stop() {
    _isRunning = false;
  }

  void dispose() {
    stop();
    _controller.close();
  }
}
