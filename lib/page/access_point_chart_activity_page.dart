import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wifi_collision_detection/util/helper.dart';
import 'package:flutter_wifi_collision_detection/viewmodel/radio_wifi_view_model.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scan/wifi_scan.dart';

class AccessPointChartActivityPage extends StatefulWidget {
  const AccessPointChartActivityPage({super.key});

  @override
  State<AccessPointChartActivityPage> createState() =>
      _AccessPointChartActivityPageState();
}

class _AccessPointChartActivityPageState
    extends State<AccessPointChartActivityPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RadioWifiViewModel>().startAutoScan();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Activity')),
      body: SafeArea(
        child: StreamBuilder<List<WiFiAccessPoint>>(
          stream: context.read<RadioWifiViewModel>().stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: const CircularProgressIndicator());
            }

            return buildLineChart(snapshot.data!);
          },
        ),
      ),
    );
  }

  LineChart buildLineChart(List<WiFiAccessPoint> accessPoints) {
    return LineChart(
      LineChartData(
        minX: 0,
        minY: 1,
        maxY: 25,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0) return const SizedBox();

                int index = value.toInt();

                if (index < 0 || index >= accessPoints.length) {
                  return const SizedBox();
                }

                final ap = accessPoints[index];

                return Text(
                  ap.ssid, // atau ap.frequency
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
            sideTitleAlignment: SideTitleAlignment.outside,
          ),
          topTitles: AxisTitles(),
          leftTitles: AxisTitles(),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0) return const SizedBox();
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
            sideTitleAlignment: SideTitleAlignment.outside,
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: accessPoints
                .asMap()
                .entries
                .map(
                  (entry) => FlSpot(
                    entry.key.toDouble(),
                    calculateFreqChannel(entry.value.frequency)!.toDouble(),
                  ),
                )
                .toList(),
            isCurved: true,
            barWidth: 1,
            color: Colors.blue,
            dotData: FlDotData(show: true),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
          ),
        ),
      ),
    );
  }
}
