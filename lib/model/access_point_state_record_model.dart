
enum EnumApConnectionStatus {
  connected,
  disconnected
}

class AccessPointStateRecordModel {
  final String uuid;
  final EnumApConnectionStatus connectionStatus;
  final String ssid;
  final String bssid;
  final String? operatorFriendlyName;
  final String? standard;
  final int? level;
  final int? frequency;
  final int? channel;
  final String? channelWidth;
  final DateTime timestamp;

  AccessPointStateRecordModel({
    required this.uuid,
    required this.connectionStatus,
    required this.ssid,
    required this.bssid,
    this.operatorFriendlyName,
    this.standard,
    this.level,
    this.frequency,
    this.channel,
    this.channelWidth,
    required this.timestamp,
  });


}
