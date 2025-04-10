import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'camera_page.dart';
import 'metering_page.dart';
import 'factors_page.dart';
import 'dof_page.dart';
import 'exposure_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BTZS Exposure App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const TabsPage(),
    );
  }
}

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    CameraPage(),
    MeteringPage(),
    FactorsPage(),
    DOFCalculatorPage(),
    ExposurePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Camera'),
          BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'Metering'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Factors'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'DOF'),
          BottomNavigationBarItem(icon: Icon(Icons.text_fields), label: 'Exposure'),
        ],
      ),
    );
  }
}