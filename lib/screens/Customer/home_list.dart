import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:teetip_app/screens/Customer/warehouse.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teetip_app/network/api.dart';
import 'dart:convert';
import 'dart:developer';

class HomeListCust extends StatefulWidget {
  @override
  _HomeListCust createState() => _HomeListCust();
}

class _HomeListCust extends State<HomeListCust> {
  String name = '';
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future getWarehouse() async {
    var res = await Network().getData('/get-warehouse');
    var body = json.decode(res.body);
    // log('$body');
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
    // TODO: implement build
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
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
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Image.asset(
                                      "assets/images/rumah1.jpg",
                                      fit: BoxFit.cover,
                                    )),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                      Text(snapshot.data['warehouse'][index]
                                          ['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),),
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
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              height: 32,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    warehouse(snapshot
                                                            .data['warehouse']
                                                        [index]['id']);
                                                  },
                                                  child: Text("Details")),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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
    );
  }

  void warehouse(id) async {
    var res = await Network().getData('/detail-warehouse/${id}');
    var body = json.decode(res.body);
    // var detail = json.decode(res.detail);
    print(body);
    if (body['success']) {
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (context) => WarehouseCust(
                name: "Image",
                warehouse: body['warehouse'],
                detail: body['detail'])),
      );
    }
    // print(detail);
  }
}
