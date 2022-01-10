import 'package:flutter/material.dart';

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
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
