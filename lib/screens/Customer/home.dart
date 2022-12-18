import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teetip_app/network/api.dart';
import 'package:teetip_app/screens/Customer/transaction.dart';
import 'dart:convert';
import 'home_list.dart';
import 'settings.dart';
import '../login.dart';
import '../Login/login_screen.dart';
import '../../constants.dart';

class HomeCust extends StatefulWidget {
  @override
  _HomeStateCust createState() => _HomeStateCust();
}

class _HomeStateCust extends State<HomeCust> {
  String name = '';
  int _selectedIndex = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadUserData();
  // }

  // Future getWarehouse() async {
  //   var res = await Network().getData('/get-warehouse');
  //   var body = json.decode(res.body);
  //   log('$body');
  //   return body;
  // }

  // _loadUserData() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var user = jsonDecode(localStorage.getString('user'));

  //   if (user != null) {
  //     setState(() {
  //       name = user['email'];
  //     });
  //   }
  // }

  static List<Widget> _widgetOptions = <Widget>[
    HomeListCust(),
    TransactionCust(),
    SettingCust(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        elevation: 0,
        title: Text('Customer Home'),
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
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_rounded),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 0,
        onTap: _onItemTapped,
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
