import 'package:flutter/material.dart';
import 'package:clone_zingmp3/mics/colors.dart' as colors;

class ChartLayout extends StatefulWidget {
  const ChartLayout({Key? key}) : super(key: key);

  @override
  _ChartLayoutState createState() => _ChartLayoutState();
}

class _ChartLayoutState extends State<ChartLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: colors.AppColors.appColor,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
