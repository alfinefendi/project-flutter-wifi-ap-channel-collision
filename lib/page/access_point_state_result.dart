import 'package:flutter/material.dart';
import 'package:flutter_wifi_collision_detection/model/access_point_state_record_model.dart';
import 'package:flutter_wifi_collision_detection/viewmodel/radio_wifi_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wifi_scan/wifi_scan.dart';

const invoices = [
  (
    invoice: "INV001",
    paymentStatus: "Paid",
    totalAmount: r"$250.00",
    paymentMethod: "Credit Card",
  ),
  (
    invoice: "INV002",
    paymentStatus: "Pending",
    totalAmount: r"$150.00",
    paymentMethod: "PayPal",
  ),
  (
    invoice: "INV003",
    paymentStatus: "Unpaid",
    totalAmount: r"$350.00",
    paymentMethod: "Bank Transfer",
  ),
  (
    invoice: "INV004",
    paymentStatus: "Paid",
    totalAmount: r"$450.00",
    paymentMethod: "Credit Card",
  ),
  (
    invoice: "INV005",
    paymentStatus: "Paid",
    totalAmount: r"$550.00",
    paymentMethod: "PayPal",
  ),
  (
    invoice: "INV006",
    paymentStatus: "Pending",
    totalAmount: r"$200.00",
    paymentMethod: "Bank Transfer",
  ),
  (
    invoice: "INV007",
    paymentStatus: "Unpaid",
    totalAmount: r"$300.00",
    paymentMethod: "Credit Card",
  ),
];

class AccessPointStateResultPage extends StatefulWidget {
  final WiFiAccessPoint ap;

  const AccessPointStateResultPage({super.key, required this.ap});

  @override
  State<AccessPointStateResultPage> createState() =>
      _AccessPointStateResultPageState();
}

class _AccessPointStateResultPageState
    extends State<AccessPointStateResultPage> {
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pop();
      },
      child: ShadApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Recording', style: ShadTheme.of(context).textTheme.h3),
          ),
          body: ShadTable.list(
            header: const [
              ShadTableCell.header(child: Text('Invoice')),
              ShadTableCell.header(child: Text('Status')),
              ShadTableCell.header(child: Text('Method')),
              ShadTableCell.header(
                alignment: Alignment.centerRight,
                child: Text('Amount'),
              ),
            ],
            footer: const [
              ShadTableCell.footer(child: Text('Total')),
              ShadTableCell.footer(child: Text('')),
              ShadTableCell.footer(child: Text('')),
              ShadTableCell.footer(
                alignment: Alignment.centerRight,
                child: Text(r'$2500.00'),
              ),
            ],
            columnSpanExtent: (index) {
              if (index == 2) return const FixedTableSpanExtent(130);
              if (index == 3) {
                return const MaxTableSpanExtent(
                  FixedTableSpanExtent(120),
                  RemainingTableSpanExtent(),
                );
              }
              // uses the default value
              return null;
            },
            children: invoices.map(
              (invoice) => [
                ShadTableCell(
                  child: Text(
                    invoice.invoice,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                ShadTableCell(child: Text(invoice.paymentStatus)),
                ShadTableCell(child: Text(invoice.paymentMethod)),
                ShadTableCell(
                  alignment: Alignment.centerRight,
                  child: Text(invoice.totalAmount),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.play_arrow),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
