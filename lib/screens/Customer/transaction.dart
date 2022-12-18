import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teetip_app/network/api.dart';
import 'dart:convert';
import 'dart:developer';

class TransactionCust extends StatefulWidget {
  @override
  _HomeListCust createState() => _HomeListCust();
}

class _HomeListCust extends State<TransactionCust> {
  String name = '';
  late String idTransaction, statusValue;
  final format = DateFormat('dd-MM-yyyy');
  late int idUser = 0;
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

  Future getTransaction() async {
    var res = await Network().getData('/customer-transaction/${idUser}');
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
        idUser = user['id'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            FutureBuilder(
                future: getTransaction(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data['data'].length,
                        itemBuilder: ((context, index) {
                          return Card(
                            elevation: 3,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 10, 0, 0)),
                                          Text('ID : ' +
                                              snapshot.data['data'][index]
                                                  ['txid']),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 10, 0, 0)),
                                          if (snapshot.data['data'][index]
                                                  ['status'] ==
                                              'unpaid') ...[
                                            Text(
                                              snapshot.data['data'][index]
                                                  ['status'],
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ] else if (snapshot.data['data']
                                                  [index]['status'] ==
                                              'processing') ...[
                                            Text(
                                              snapshot.data['data'][index]
                                                  ['status'],
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ] else ...[
                                            Text(
                                              snapshot.data['data'][index]
                                                  ['status'],
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                          // Text('Status : ' +
                                          //     _statusChanges(index).toString()),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 10, 0, 0)),
                                          Text('Start Date : ' +
                                              format.format(DateTime.parse(
                                                  snapshot.data['data'][index]
                                                      ['start_at']))),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 10, 0, 0)),
                                          Text('End Date   : ' +
                                              format.format(DateTime.parse(
                                                  snapshot.data['data'][index]
                                                      ['end_at']))),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                Row(
                                  children: [
                                    if (snapshot.data['data'][index]
                                            ['status'] ==
                                        'unpaid') ...[
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 32,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red),
                                              onPressed: (() => HomeCust()),
                                              child: Text("Cancel")),
                                        ),
                                      ),
                                    ] else ...[
                                      Expanded(
                                        flex: 2,
                                        child: Container(),
                                      ),
                                    ],
                                    Expanded(
                                      flex: 2,
                                      child: Container(),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 32,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: ElevatedButton(
                                            onPressed: (() => HomeCust()),
                                            child: Text("Details")),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
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
}
