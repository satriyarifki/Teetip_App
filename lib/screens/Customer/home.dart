import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teetip_app/network/api.dart';
import 'dart:convert';
import '../login.dart';
import '../Login/login_screen.dart';
import '../../constants.dart';

class HomeCust extends StatefulWidget {
  @override
  _HomeStateCust createState() => _HomeStateCust();
}

class _HomeStateCust extends State<HomeCust> {
  String name = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future getWarehouse() async {
    var res = await Network().getData('/get-warehouse');
    var body = json.decode(res.body);
    log('$body');
    return body;
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        name = user['email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: kPrimaryCustomer,
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
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Hello, ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '${name}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
              FutureBuilder(
                  future: getWarehouse(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data['warehouse'].length,
                          itemBuilder: ((context, index) {
                            return Card(
                              elevation: 3,
                              child: Column(
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                  Text(snapshot.data['warehouse'][index]
                                      ['name']),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                  Text(snapshot.data['warehouse'][index]
                                      ['alamat']),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                  Text('Harga : Rp' +
                                      snapshot.data['warehouse'][index]
                                              ['harga_m2']
                                          .toString() +
                                      ' m2'),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                  ElevatedButton(
                                      onPressed: (() => HomeCust()),
                                      child: Text("Details"))
                                ],
                              ),
                            );
                          }));
                    } else {
                      return Text('Error');
                    }
                  }))
            ],
          ),
        ),
      ),
    );
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
