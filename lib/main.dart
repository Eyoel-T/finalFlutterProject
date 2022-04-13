import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'login_page.dart';

void main() async {
  runApp(LandingPage());
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isLoggedIn = false;

  @override
  void initState() {
    getLogData();
    super.initState();
  }

  void getLogData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var value = pref.getBool("isUserlogged");
    setState(() {
      isLoggedIn = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? Home() : LoginPage(),
    );
  }
}
