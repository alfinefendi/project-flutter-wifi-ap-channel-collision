import 'package:cristalyse/cristalyse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wifi_collision_detection/viewmodel/radio_wifi_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wifi_scan/wifi_scan.dart';

class AccessPointStateRecordPage extends StatefulWidget {
  const AccessPointStateRecordPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // logic kamu di sini sebelum keluar

        final viewModel = context.read<RadioWifiViewModel>();
        if (!viewModel.isStartToRecording) {
          Navigator.of(context).pop();
        }
        viewModel.stopRecording();
      },
      child: ShadApp(
        home: Consumer<RadioWifiViewModel>(
          builder: (context, viewModel, _) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Akses Poin Terpilih',
                  style: ShadTheme.of(context).textTheme.h4,
                ),
              ),
              body: SafeArea(
                child: viewModel.isStartToRecording
                    ? StreamBuilder<List<WiFiAccessPoint>>(
                        stream: viewModel.getStreamByBssid(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            // Tambah data baru ke list
                            viewModel.recordApState(snapshot.data!);
                          }

                          if (viewModel.recordedData.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          // Chart akan re-render + animate setiap setState dipanggil
                          return CristalyseChart()
                              .data(viewModel.recordedData)
                              .mapping(x: 'time', y: 'rssi', color: 'ssid')
                              .geomLine(strokeWidth: 1.0)
                              .scaleXContinuous()
                              .scaleYContinuous(min: -100, max: 0)
                              .theme(ChartTheme.defaultTheme())
                              .build();
                        },
                      )
                    : ShadTable.list(
                        header: const [
                          ShadTableCell.header(child: Text('SSID')),
                          ShadTableCell.header(child: Text('BSSID')),
                        ],
                        columnSpanExtent: (index) {
                          if (index == 0)
                            return const FixedTableSpanExtent(220);
                          if (index == 1) {
                            return const MaxTableSpanExtent(
                              FixedTableSpanExtent(120),
                              RemainingTableSpanExtent(),
                            );
                          }
                          return null;
                        },
                        children: viewModel.selectedAp.map(
                          (ap) => [
                            ShadTableCell(
                              child: Text(
                                ap.ssid,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ShadTableCell(child: Text(ap.bssid)),
                          ],
                        ),
                      ),
              ),
              // Hanya FAB yang butuh isScanning
              floatingActionButton: Consumer<RadioWifiViewModel>(
                builder: (context, viewModel, _) {
                  return FloatingActionButton(
                    onPressed: viewModel.toggleStartRecording,
                    child: Icon(
                      viewModel.isStartToRecording
                          ? Icons.stop
                          : Icons.play_arrow,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
