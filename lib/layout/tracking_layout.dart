import 'package:flutter/material.dart';

class TrackingLayout extends StatefulWidget {
  const TrackingLayout({Key? key}) : super(key: key);

  @override
  _TrackingLayoutState createState() => _TrackingLayoutState();
}

class _TrackingLayoutState extends State<TrackingLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
