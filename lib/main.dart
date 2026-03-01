import 'package:flutter/material.dart';
import 'package:flutter_wifi_collision_detection/page/access_point_chart_activity_page.dart';
import 'package:flutter_wifi_collision_detection/page/access_point_page.dart';
import 'package:flutter_wifi_collision_detection/viewmodel/radio_wifi_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RadioWifiViewModel())],
      child: const MainApp(),
    ),
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
    AccessPointPage(),
  ];

  void _onBottomNavigationBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShadApp.custom(
      themeMode: ThemeMode.light,
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadSlateColorScheme.dark(),
      ),
      appBuilder: (BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return ShadAppBuilder(child: child!);
          },
          home: Scaffold(
            body: _screen[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onBottomNavigationBarItemTapped,
              items: [
                BottomNavigationBarItem(
                  label: "Grafik",
                  icon: Icon(LucideIcons.monitor),
                ),
                BottomNavigationBarItem(
                  label: "Akses Poin",
                  icon: Icon(LucideIcons.wifiHigh),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
