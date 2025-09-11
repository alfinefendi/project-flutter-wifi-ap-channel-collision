import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wifi_scan/wifi_scan.dart';

int _calculateChannel({required int freq}) {
  const freqDivideBy = 5;
  const freq2GhzMin = 2412;
  const freq2GhzMax = 2472;
  const freq2GhzJapan = 2484;
  const freq5GhzMin = 5180;
  const freq5GhzMax = 5825;
  const freq2GhzBaseLine = 2407;
  const freq5GhzBaseLine = 5000;

  late int channel;

  if (freq >= freq2GhzMin && freq <= freq2GhzMax) {
    channel = (freq - freq2GhzBaseLine) ~/ freqDivideBy;
  } else if (freq == freq2GhzJapan) {
    channel = 14;
  } else if (freq >= freq5GhzMin && freq <= freq5GhzMax) {
    channel = (freq - freq5GhzBaseLine) ~/ freqDivideBy;
  } else {
    channel = -1;
  }

  return channel;
}

// ignore: must_be_immutable
class GraphCart extends StatefulWidget {
  List<WiFiAccessPoint> accessPointDatas = [];

  GraphCart({super.key, required this.accessPointDatas});

  @override
  State<GraphCart> createState() => _GraphCartState();
}

class _GraphCartState extends State<GraphCart> {
  late Widget _pages;
  late List<WiFiAccessPoint> formattedAPD;

  @override
  void initState() {
    super.initState();
    formattedAPD = widget.accessPointDatas.toList();
    // formattedAPD.sort((a, b) => a.frequency.compareTo(b.frequency));
    // _pages = ImgGraph(datas: formattedAPD);
  }

  void _setPage(int index) {
    setState(() {
      if (index == 0) {
        _pages = ImgGraph(datas: formattedAPD);
      } else {
        _pages = ListGraph(datas: formattedAPD);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _pages),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton.filled(
              onPressed: () {
                _setPage(0);
              },
              icon: Icon(Icons.chevron_left),
            ),
            IconButton.filled(
              onPressed: () {
                _setPage(1);
              },
              icon: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ],
    );
  }
}

class ImgGraph extends StatelessWidget {
  final List<WiFiAccessPoint> datas;

  ImgGraph({super.key, required this.datas});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        enablePinching: true,
        enableMouseWheelZooming: true,
        zoomMode: ZoomMode.x,
        enableSelectionZooming: false,
      ),
      primaryYAxis: NumericAxis(
        minimum: -150,
        maximum: 150,
        interval: 25,
        numberFormat: NumberFormat("###"),
        labelFormat: '{value} dBm',
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryXAxis: CategoryAxis(
        labelIntersectAction: AxisLabelIntersectAction.wrap,
        labelRotation: 90,
        interval: 1,
      ),
      series: [
        ColumnSeries<WiFiAccessPoint, int>(
          dataSource: datas,
          xValueMapper: (data, _) => _calculateChannel(freq: data.frequency),
          yValueMapper: (data, _) => data.level,
          dataLabelMapper: (data, _) => data.ssid,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class ListGraph extends StatelessWidget {
  final List<WiFiAccessPoint> datas;

  ListGraph({super.key, required this.datas});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final WiFiAccessPoint accessPoint = datas[index];
        return ListTile(
          leading: Text("${index + 1}"),
          title: Text(accessPoint.ssid),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Channel : ${_calculateChannel(freq: accessPoint.frequency)}",
              ),
              Text(accessPoint.bssid),
              Text(accessPoint.centerFrequency0.toString()),
              Text(accessPoint.frequency.toString()),
              Text(accessPoint.standard.toString()),
              Text(accessPoint.level.toString()),
              Text(accessPoint.channelWidth.toString()),
              Text(accessPoint.operatorFriendlyName.toString()),
            ],
          ),
        );
      },
      itemCount: datas.length,
    );
  }
}
