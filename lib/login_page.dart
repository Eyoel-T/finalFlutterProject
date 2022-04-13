import "package:flutter/material.dart";

import "home.dart";
import 'package:flutter/gestures.dart';
import 'register_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:dio/dio.dart";

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked = false;
  bool game = false;
  bool loadingSpinner = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Dio dio = Dio();

  void login() async {
    try {
      var response = await dio
          .post("https://fluttertaskapp.herokuapp.com/api/auth/login", data: {
        "email": emailController.text,
        "password": passwordController.text,
      });
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("isUserlogged", true);
      pref.setString("username", response.data["username"]);
      pref.setString("userId", response.data["_id"]);

      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Home(),
          ),
          (route) => false,
        );
      }
    } catch (err) {
      setState(() {
        loadingSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: loadingSpinner,
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: [
              SizedBox(
                height: 100.0,
              ),
              Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Text(
                "Email",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: "enter your email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.email),
                    contentPadding: EdgeInsets.all(17)),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Password",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "enter your password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  prefixIcon: Icon(Icons.lock),
                  contentPadding: EdgeInsets.all(17),
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 60,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    loadingSpinner = true;
                  });
                  login();
                },
                style: ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
                child: Text(
                  "Sign In",
                  style: TextStyle(fontFamily: "Poppins", fontSize: 20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                      text: "Create new account? ",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPage(),
                                  ),
                                );
                              })
                      ]),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
