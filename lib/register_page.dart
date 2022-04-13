import 'dart:convert';

import "package:flutter/material.dart";
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'home.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import "package:http/http.dart";
import "package:dio/dio.dart";

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isChecked = false;
  bool loadingSpinner = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  Dio dio = Dio();

  void register() async {
    try {
      var response = await dio.post(
          "https://fluttertaskapp.herokuapp.com/api/auth/register",
          data: {
            "username": nameController.text,
            "email": emailController.text,
            "password": passwordController.text,
          });
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("isUserlogged", true);
      pref.setString("username", nameController.text);
      pref.setString("userId", response.data["_id"]);
      print(response.data["_id"]);
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
        body: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: loadingSpinner,
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: ListView(
                children: [
                  SizedBox(height: 50),
                  Text(
                    "Get's Started",
                    style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Already have an account ?",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        color: Colors.grey[600],
                      ),
                      children: [
                        TextSpan(
                          text: "Sign in",
                          style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'Poppins',
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Username",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "enter your username",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(
                        Icons.person,
                      ),
                      contentPadding: EdgeInsets.all(17),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "you@example.com",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.email),
                      contentPadding: EdgeInsets.all(17),
                    ),
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
                    height: 15,
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
                    height: 40,
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: RichText(
                      text: TextSpan(
                        text: "I agree to the",
                        style: TextStyle(
                            color: Colors.grey, fontFamily: "Poppins"),
                        children: [
                          TextSpan(
                            text: " Terms of Service",
                            style: TextStyle(
                                color: Colors.blue, fontFamily: "Poppins"),
                          ),
                          TextSpan(
                            text: " and",
                            style: TextStyle(
                                color: Colors.grey, fontFamily: "Poppins"),
                          ),
                          TextSpan(
                            text: " Privacy Policy",
                            style: TextStyle(
                                color: Colors.blue, fontFamily: "Poppins"),
                          ),
                        ],
                      ),
                    ),
                    value: isChecked,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: isChecked
                        ? () {
                            setState(() {
                              loadingSpinner = true;
                            });
                            // await FirebaseAuth.instance
                            //     .createUserWithEmailAndPassword(
                            //         email: emailController.text,
                            //         password: passwordController.text);

                            register();
                            // setState(() {
                            //   loadingSpinner = false;
                            // });

                            // Navigator.pushAndRemoveUntil(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (BuildContext context) => Home(),
                            //   ),
                            //   (route) => false,
                            // );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(fontFamily: "Poppins", fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
