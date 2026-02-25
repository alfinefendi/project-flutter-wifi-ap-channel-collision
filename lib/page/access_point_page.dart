import 'package:flutter/material.dart';
import 'package:flutter_wifi_collision_detection/page/access_point_state_record_page.dart';
import 'package:flutter_wifi_collision_detection/util/helper.dart';
import 'package:flutter_wifi_collision_detection/viewmodel/radio_wifi_view_model.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scan/wifi_scan.dart';

class AccessPointPage extends StatelessWidget {
  const AccessPointPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Access Points'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Search Wifi'),
                    content: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter SSID',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Search'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<List<WiFiAccessPoint>>(
          stream: context.read<RadioWifiViewModel>().stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: const CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {

                final ap = snapshot.data![index];

                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccessPointStateRecordPage(
                          ap: ap,
                        ),
                      ),
                    );
                  },
                  title: Text(ap.ssid),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(ap.bssid),
                      Text("Frequency: ${ap.frequency}"),
                      Text(
                        "Channel: ${calculateFreqChannel(ap.frequency)}",
                      ),
                      Text(
                        "Operator Name: ${ap.operatorFriendlyName}",
                      ),
                      Text("cf0: ${ap.centerFrequency0 ?? '-'}"),
                      Text("cf1: ${ap.centerFrequency1 ?? '-'}"),
                      Text("Standard: ${ap.standard}"),
                      Text("Channel Width: ${ap.channelWidth ?? '-'}"),
                      Text("Capabilities: ${ap.capabilities}"),
                      Text("Level: ${ap.level}"),
                      Text("Passpoint: ${ap.isPasspoint}"),
                      Text("Venue Name: ${ap.venueName}"),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
