import 'package:clone_zingmp3/layout/main_layout.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future _splashScreen() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeLayout()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _splashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        "assets/images/splash_screen.jpg",
        fit: BoxFit.cover,
      ),
    );
  }
}
