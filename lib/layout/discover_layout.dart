import 'package:flutter/material.dart';

class DiscoverLayout extends StatefulWidget {
  const DiscoverLayout({Key? key}) : super(key: key);

  @override
  _DiscoverLayoutState createState() => _DiscoverLayoutState();
}

class _DiscoverLayoutState extends State<DiscoverLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
