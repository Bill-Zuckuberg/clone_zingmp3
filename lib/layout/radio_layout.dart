import 'package:flutter/material.dart';

class RadioLayout extends StatefulWidget {
  const RadioLayout({Key? key}) : super(key: key);

  @override
  _RadioLayoutState createState() => _RadioLayoutState();
}

class _RadioLayoutState extends State<RadioLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
