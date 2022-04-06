import "package:flutter/material.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'login_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
