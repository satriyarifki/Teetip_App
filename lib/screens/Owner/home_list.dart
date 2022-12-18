import 'package:flutter/material.dart';
import 'package:teetip_app/screens/Owner/addPart.dart';
import 'package:teetip_app/screens/Owner/addWarehouse.dart';
import 'package:teetip_app/screens/Owner/warehouse.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teetip_app/network/api.dart';
import 'dart:convert';
import 'dart:developer';

class HomeListOwner extends StatefulWidget {
  @override
  _HomeListOwner createState() => _HomeListOwner();
}

class _HomeListOwner extends State<HomeListOwner> {
  String name = '';
  late int idUser = 0;

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadUserData();
    // print(idUser);
    show();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        name = user['email'];
        idUser = user['id'];
      });
    }
  }

  Future getWarehouse() async {
    var res = await Network().getData('/get-warehouse');
    var body = json.decode(res.body);
    // log('$body');
    return body;
  }

  Future getOwnerWarehouse() async {
    var res = await Network().getData('/owner-warehouse/${idUser}');
    var body = json.decode(res.body);
    // log('$body');
    return body;
  }

  show() {
    // print(widget.detail[0]['harga']);
    // print(detailluas.length);
    // print(getWarehouse()['name']);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Container(
              width: double.infinity / 3,
              child: ElevatedButton(
                  onPressed: () {
                    _AddPage();
                  },
                  child: Text("Add")),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            FutureBuilder(
                future: getOwnerWarehouse(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    _isLoading = true;
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data['ownerHouse'].length,
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
                                      Text(
                                        snapshot.data['ownerHouse'][index]
                                            ['name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                      Text(snapshot.data['ownerHouse'][index]
                                          ['alamat']),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 0)),
                                      Text('Harga : Rp' +
                                          snapshot.data['ownerHouse'][index]
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
                                              height: 32,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    warehouse(snapshot
                                                            .data['ownerHouse']
                                                        [index]['id']);
                                                  },
                                                  child: Text("Details")),
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
                                                    _AddPart(snapshot
                                                            .data['ownerHouse']
                                                        [index]['id']);
                                                  },
                                                  child: Text("Add Part")),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }));
                  } else {
                    return Text('Load');
                  }
                }))
          ],
        ),
      ),
    );
  }

  void _AddPage() async {
    var res = await Network().getData('/owner-warehouse/${idUser}');
    var body = json.decode(res.body);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddWarehouseOwner(
            ownerId: body['ownerHouse'][0]['id'],
          ),
        ));
  }

  void _AddPart(id) async {
    var res = await Network().getData('/owner-warehouse/${idUser}');
    var body = json.decode(res.body);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddPartOwner(
            houseId: id,
          ),
        ));
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
            builder: (context) => WarehouseOwner(
                name: "Image",
                warehouse: body['warehouse'],
                detail: body['detail'])),
      );
    }
    // print(detail);
  }
}
