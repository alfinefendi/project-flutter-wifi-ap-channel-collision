import 'package:flutter/material.dart';
import 'package:flutter_wifi_collision_detection/page/access_point_chart_activity_page.dart';
import 'package:flutter_wifi_collision_detection/page/access_point_page.dart';
import 'package:flutter_wifi_collision_detection/viewmodel/radio_wifi_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RadioWifiViewModel()),
      ],
      child: const MainApp()
    )
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  final List<Widget> _screen = [
    AccessPointChartActivityPage(),
    AccessPointPage()
  ];

  void _onBottomNavigationBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _screen[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onBottomNavigationBarItemTapped,
          items: [
            BottomNavigationBarItem(label: "Activity", icon: Icon(Icons.accessibility)),
            BottomNavigationBarItem(label: "Access Points", icon: Icon(Icons.info))
          ],
        ),

      )
    );
  }
}
