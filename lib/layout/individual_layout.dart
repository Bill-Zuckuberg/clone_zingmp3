import 'package:flutter/material.dart';

class IndividualLayout extends StatefulWidget {
  const IndividualLayout({Key? key}) : super(key: key);

  @override
  _IndividualLayoutState createState() => _IndividualLayoutState();
}

class _IndividualLayoutState extends State<IndividualLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
