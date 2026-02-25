import 'package:flutter/material.dart';
import 'package:flutter_wifi_collision_detection/model/access_point_state_record_model.dart';
import 'package:flutter_wifi_collision_detection/util/helper.dart';
import 'package:flutter_wifi_collision_detection/viewmodel/radio_wifi_view_model.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scan/wifi_scan.dart';

class AccessPointStateRecordPage extends StatefulWidget {
  final WiFiAccessPoint ap;

  const AccessPointStateRecordPage({super.key, required this.ap});

  @override
  State<AccessPointStateRecordPage> createState() =>
      _AccessPointStateRecordPageState();
}

class _AccessPointStateRecordPageState
    extends State<AccessPointStateRecordPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<AccessPointStateRecordModel> rows = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recording')),
      body: SafeArea(
        child: buildStreamBuilder(context)
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.play_arrow),
      //   onPressed: () {},
      // ),
    );
  }

  StreamBuilder<WiFiAccessPoint?> buildStreamBuilder(BuildContext context) {
    return StreamBuilder<WiFiAccessPoint?>(
      stream: context.read<RadioWifiViewModel>().streamByBssid(widget.ap.bssid),
      builder: (context, snapshot) {
        late bool connected;

        if (snapshot.hasError) {
          Navigator.of(context).pop();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          connected = false;
        } else {
          connected = true;
        }

        final uuid = generateUuid();

        rows.add(
          AccessPointStateRecordModel(
            uuid: uuid,
            connectionStatus: connected
                ? EnumApConnectionStatus.connected
                : EnumApConnectionStatus.disconnected,
            ssid: widget.ap.ssid,
            bssid: widget.ap.bssid,
            frequency: snapshot.data?.frequency,
            channel: calculateFreqChannel(snapshot.data?.frequency),
            level: snapshot.data?.level,
            standard: snapshot.data?.standard.toString(),
            timestamp: DateTime.now(),
          ),
        );

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('SSID')),
              DataColumn(label: Text('BSSID')),
              DataColumn(label: Text('Channel')),
              DataColumn(label: Text('Frequency')),
              DataColumn(label: Text('Level')),
              DataColumn(label: Text('Timestamp')),
            ],
            rows: rows.asMap().entries.map((entry) {
              return DataRow(
                cells: [
                  DataCell(Text("${entry.key + 1}")),
                  DataCell(Text(entry.value.connectionStatus.name)),
                  DataCell(Text(entry.value.ssid)),
                  DataCell(Text(entry.value.bssid)),
                  DataCell(Text("${entry.value.channel ?? 'N/A'}")),
                  DataCell(Text("${entry.value.frequency ?? 'N/A'}")),
                  DataCell(Text("${entry.value.level ?? 'N/A'}")),
                  DataCell(Text("${entry.value.timestamp}")),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
