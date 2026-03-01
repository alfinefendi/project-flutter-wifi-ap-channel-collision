import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:wifi_scan/wifi_scan.dart';

class RadioWifiViewModel extends ChangeNotifier {
  final _controller = StreamController<List<WiFiAccessPoint>>.broadcast();

  Stream<List<WiFiAccessPoint>> get stream => _controller.stream;

  bool _isRunning = false;

  Future<void> startAutoScan() async {
    if (_isRunning) return;
    _isRunning = true;

    while (_isRunning) {
      final can = await WiFiScan.instance.canStartScan(askPermissions: true);

      if (can == CanStartScan.yes) {
        await WiFiScan.instance.startScan();
        await Future.delayed(const Duration(seconds: 1));

        final results = await WiFiScan.instance.getScannedResults();

        _controller.add(results);
      }
    }
  }

  List<WiFiAccessPoint> _ap = [];
  bool _isInChecklistMode = false;

  List<WiFiAccessPoint> get selectedAp => _ap;
  bool get isInChecklistMode => _isInChecklistMode;

  Stream<List<WiFiAccessPoint>> getStreamByBssid() {
    return stream.map((list) {
      return list
          .where(
            (ap) => selectedAp.any((selected) => selected.bssid == ap.bssid),
          )
          .toList();
    });
  }

  bool validateSeletedAp(String bssid) {
    return selectedAp.any((ap) => ap.bssid == bssid);
  }

  void checklist(WiFiAccessPoint ap) {
    bool isDuplicate = validateSeletedAp(ap.bssid);

    if (isDuplicate) {
      _ap = _ap.where((item) => item.bssid != ap.bssid).toList();
    } else {
      _ap.add(ap);
    }
    notifyListeners();
  }

  void toggleChecklistMode() {
    _isInChecklistMode = !_isInChecklistMode;
    notifyListeners();
  }

  void clearSelectedAp() {
    _ap.clear();
    notifyListeners();
  }

  bool _isStartToRecording = false;
  bool get isStartToRecording => _isStartToRecording;

  void toggleStartRecording() {
    _isStartToRecording = !_isStartToRecording;

    if (_chartData.isNotEmpty) {
      _chartData.clear();
    }

    notifyListeners();
  }

  void stopRecording() {
    if (!_isStartToRecording) return; // sudah stop, skip
    _isStartToRecording = false;
    _chartData.clear();
    notifyListeners();
  }

  // getStreamByBssid
  final List<Map<String, dynamic>> _chartData = [];
  List<Map<String, dynamic>> get recordedData => _chartData;

  void recordApState(List<WiFiAccessPoint> aps) {
    final now = DateTime.now();

    for (final ap in aps) {
      _chartData.add({
        'time': now.millisecondsSinceEpoch.toDouble(),
        'rssi': ap.level.toDouble(),
        'ssid': ap.ssid,
      });
    }

    if (_chartData.length > 100) {
      _chartData.removeRange(0, _chartData.length - 100);
    }
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



        // final uuid = generateUuid();

        // rows.add(
        //   AccessPointStateRecordModel(
        //     uuid: uuid,
        //     connectionStatus: connected
        //         ? EnumApConnectionStatus.connected
        //         : EnumApConnectionStatus.disconnected,
        //     ssid: widget.ap.ssid,
        //     bssid: widget.ap.bssid,
        //     frequency: snapshot.data?.frequency,
        //     channel: calculateFreqChannel(snapshot.data?.frequency),
        //     level: snapshot.data?.level,
        //     standard: snapshot.data?.standard.toString(),
        //     timestamp: DateTime.now(),
        //   ),
        // );