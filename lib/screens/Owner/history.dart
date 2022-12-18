import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teetip_app/network/api.dart';
import 'package:teetip_app/screens/Customer/home.dart';
import 'package:teetip_app/screens/Customer/home_list.dart';
import 'package:teetip_app/screens/Owner/home.dart';
import 'dart:convert';
import '../../constants.dart';
import '../Login/login_screen.dart';

class HistoryOwner extends StatefulWidget {
  @override
  State<HistoryOwner> createState() => _AddPartOwnerState();
}

class _AddPartOwnerState extends State<HistoryOwner> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late int price, long, width;
  @override
  void initState() {}

  _showMsg(msg) {
    final snackBarr = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBarr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Owner'),
        backgroundColor: kPrimaryOwner,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {
              logout();
            },
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          // scrollDirection: Axis.horizontal,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () {
                    back(context);
                  },
                  icon: Icon(Icons.arrow_back)),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [],
                  )),
            )
          ],
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.all(8.0),
      //   child: Hero(
      //     tag: "add_button",
      //     child: ElevatedButton(
      //       child: Text(
      //         _isLoading ? 'Proccessing..' : 'Submit',
      //         textDirection: TextDirection.ltr,
      //       ),
      //       onPressed: () {
      //         if (_formKey.currentState!.validate()) {
      //           _store();
      //         }
      //       },
      //     ),
      //   ),
      // ),
    );
  }

  void back(context) async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeOwner()));
  }

  void logout() async {
    var res = await Network().getData('/logout');
    var body = json.decode(res.body);
    if (body['success'] == null) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}
