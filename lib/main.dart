import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/Customer/home.dart';
import 'screens/Owner/home.dart';
import 'screens/Login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CheckAuth(),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  int role_id = 0;

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    // localStorage.clear();
    var token = localStorage.getString('token');
    var user = localStorage.getString('user');
    if (token != null) {
      if (mounted) {
        setState(() {
          isAuth = true;
        });
      }
    }
    if (user != null) {
      setState(() {
        role_id = jsonDecode(user)['role_id'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      if (role_id == 3) {
        child = HomeCust();
      } else if (role_id == 4) {
        child = HomeOwner();
      } else {
        child = Home();
      }
    } else {
      child = LoginScreen();
    }

    return Scaffold(
      body: child,
    );
  }
}
