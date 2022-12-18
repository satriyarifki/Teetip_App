import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teetip_app/network/api.dart';
import 'package:teetip_app/screens/Customer/home.dart';
import 'package:teetip_app/screens/Customer/home_list.dart';
import 'package:teetip_app/screens/Owner/editWarehouse.dart';
import 'package:teetip_app/screens/Owner/home.dart';
import 'dart:convert';
import '../../constants.dart';
import '../Login/login_screen.dart';

class WarehouseOwner extends StatefulWidget {
  final String name;
  final List detail;
  final Map warehouse;
  const WarehouseOwner(
      {super.key,
      required this.name,
      required this.detail,
      required this.warehouse});

  @override
  State<WarehouseOwner> createState() => _WarehouseOwnerState();
}

class _WarehouseOwnerState extends State<WarehouseOwner> {
  String nama = '';
  String alamat = '';
  String des = '';
  List<int> detailId = [];
  List<int> detailluas = [];
  List<int> listHarga = [];
  int dropdownArea = 1;
  int idDetail = 1;
  late int idCust;
  @override
  void initState() {
    _loadUserData();
    // getWarehouse();
    // getDetail();
    show();
  }

  show() {
    // print(widget.detail[0]['harga']);
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        idCust = user['id'];
      });
    }
  }

  areaChanges(val) {
    setState(() {
      dropdownArea = val!;
      print(dropdownArea.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Warehouse'),
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
              width: double.infinity,
              height: 350,
              color: Colors.grey,
              alignment: Alignment.center,
              child: Text(widget.name),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                widget.warehouse['name'],
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.warehouse['alamat'],
                textAlign: TextAlign.start,
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Desc : ',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '  ' + widget.warehouse['deskripsi'],
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Luas Total : ' + widget.warehouse['luas_total'],
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            edit();
          },
          child: Text('Edit'),
        ),
      ),
    );
  }

  void back(context) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    // print(localStorage.get('warehouse'));
    if (localStorage.get('warehouse') != null &&
        localStorage.get('detail') != null) {
      localStorage.remove('warehouse');
      localStorage.remove('detail');
      // print(localStorage.get('warehouse'));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeOwner()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeOwner()));
    }
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

  void edit() async {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
          builder: (context) => EditWarehouseOwner(
                warehouse: widget.warehouse,
              )),
    );
  }
}
