import 'package:flutter/cupertino.dart';
import 'package:btzs_calc/pages/exposure_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'BTZS Exposure App',
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: CupertinoColors.activeBlue,
        scaffoldBackgroundColor: CupertinoColors.black,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            color: CupertinoColors.white,
            fontSize: 16,
          ),
          actionTextStyle: TextStyle(color: CupertinoColors.activeBlue),
          navTitleTextStyle: TextStyle(
            color: CupertinoColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const ExposureListPage(),
    );
  }
}
