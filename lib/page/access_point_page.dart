import 'package:flutter/material.dart';
import 'package:flutter_wifi_collision_detection/page/access_point_state_record_page.dart';
import 'package:flutter_wifi_collision_detection/util/helper.dart';
import 'package:flutter_wifi_collision_detection/viewmodel/radio_wifi_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wifi_scan/wifi_scan.dart';

class AccessPointPage extends StatelessWidget {
  const AccessPointPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // if (didPop) return;
        // // logic kamu di sini sebelum keluar

        // final viewModel = context.read<RadioWifiViewModel>();
        // if (!viewModel.isStartToRecording) {
        //   Navigator.of(context).pop();
        // }
        // viewModel.stopRecording();
      },
      child: ShadApp(
        home: Consumer<RadioWifiViewModel>(
          builder: (context, viewModel, _) {
            bool isSelectedApNotEmpty = viewModel.selectedAp.isNotEmpty;
            bool inChecklistMode = viewModel.isInChecklistMode;

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Akses Poin',
                  style: ShadTheme.of(context).textTheme.h3,
                ),
                leading: isSelectedApNotEmpty && inChecklistMode
                    ? IconButton(
                        icon: Icon(
                          isSelectedApNotEmpty ? LucideIcons.trash : null,
                        ),
                        onPressed: () {
                          viewModel.toggleChecklistMode();
                          viewModel.clearSelectedAp();
                        },
                      )
                    : null,
                actions: [
                  IconButton(
                    icon: Badge(
                      isLabelVisible: isSelectedApNotEmpty && !inChecklistMode
                          ? true
                          : false,
                      label: Text(viewModel.selectedAp.length.toString()),
                      child: Icon(
                        inChecklistMode
                            ? LucideIcons.listX
                            : LucideIcons.listCheck,
                      ),
                    ),
                    onPressed: () {
                      viewModel.toggleChecklistMode();
                    },
                  ),
                ],
              ),
              body: SafeArea(
                child: StreamBuilder<List<WiFiAccessPoint>>(
                  stream: viewModel.stream,
                  builder: (context, snapshot) {
                    // Handle semua state

                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('Tidak ada WiFi terdeteksi'),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final ap = snapshot.data![index];
                        final isChecked = viewModel.validateSeletedAp(ap.bssid);

                        return ListTile(
                          onTap: () {
                            inChecklistMode ? viewModel.checklist(ap) : null;
                          },
                          onLongPress: () {
                            if (!inChecklistMode) {
                              viewModel.toggleChecklistMode();
                              !isChecked ? viewModel.checklist(ap) : null;
                            }
                          },
                          leading: inChecklistMode
                              ? Checkbox(
                                  value: isChecked, // ✅ bukan null
                                  onChanged: (_) => viewModel.checklist(ap),
                                )
                              : null,
                          title: Text(ap.ssid),
                          subtitle: Text(ap.bssid),
                          trailing: Text(
                            "Channel: ${calculateFreqChannel(ap.frequency)}",
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              floatingActionButton: isSelectedApNotEmpty
                  ? FloatingActionButton(
                      child: Icon(LucideIcons.arrowRight),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccessPointStateRecordPage(),
                          ),
                        );
                      },
                    )
                  : null,
            );
          },
        ),
      ),
    );
  }
}
