import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'camera_page.dart';
import 'metering_page.dart';
import 'factors_page.dart';
import 'dof_page.dart';
import 'exposure_page.dart';
import 'session.dart';

void main() => runApp(const BTZSCalcApp());

class BTZSCalcApp extends StatelessWidget {
  const BTZSCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(brightness: Brightness.dark),
      home: MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _tabIndex = 0;

  final List<Widget> _tabs = const [
    CameraPage(),
    MeteringPage(),
    FactorsPage(),
    DOFCalculatorPage(),
    ExposurePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: _tabIndex,
        onTap: (index) => setState(() => _tabIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.photo_camera), label: 'Camera'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.lock), label: 'Metering'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.add), label: 'Factors'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.photo_on_rectangle), label: 'DOF'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.textformat_alt), label: 'Exposure'),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) => _tabs[index],
        );
      },
    );
  }
}