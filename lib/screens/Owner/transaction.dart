import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teetip_app/screens/Owner/transactionDet.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teetip_app/network/api.dart';
import 'dart:convert';
import 'dart:developer';

class TransactionOwner extends StatefulWidget {
  @override
  _HomeListOwner createState() => _HomeListOwner();
}

class _HomeListOwner extends State<TransactionOwner> {
  String name = '';
  late String idTransaction, statusValue;
  late int idUser = 0;
  final format = DateFormat('dd-MM-yyyy');
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
    var res = await Network().getData('/owner-transaction/${idUser}');
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

  _showMsg(msg) {
    final snackBarr = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBarr);
  }

  // _statusChanges(index) async {
  //   var res = await Network().getData('/owner-transaction/${idUser}');
  //   var body = json.decode(res.body);
  //   if (body['data'][index]['status'] == 'unpaid') {
  //     return Text(
  //       body['data'][index]['status'],
  //       style: TextStyle(color: Colors.red),
  //     );
  //   } else if(body['data'][index]['status'] == 'processing'){
  //     return Text(
  //       body['data'][index]['status'],
  //       style: TextStyle(color: Colors.orange),
  //     );
  //   } else {
  //     return Text(
  //       body['data'][index]['status'],
  //       style: TextStyle(color: Colors.green),
  //     );
  //   }
  // }

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
                                              onPressed: (() => HomeOwner()),
                                              child: Text("Cancel")),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 32,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.green.shade600),
                                              onPressed: () {
                                                if (snapshot.data['data'][index]
                                                        ['status'] ==
                                                    'unpaid') {
                                                  statusValue = 'processing';
                                                  idTransaction =
                                                      snapshot.data['data']
                                                          [index]['txid'];
                                                }
                                                _update();
                                              },
                                              child: Text("Accept")),
                                        ),
                                      ),
                                    ] else ...[
                                      Expanded(
                                        flex: 2,
                                        child: Container(),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(),
                                      ),
                                    ],
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 32,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TransactionDetailsOwner(
                                                          transaction : snapshot.data['data'][index],
                                                        )),
                                              );
                                            },
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

  void _update() async {
    var data = {'status': statusValue};

    var res =
        await Network().postData(data, '/update-transaction/${idTransaction}');
    var body = json.decode(res.body);
    print(body);
    if (body['success'] != null) {
      print("test2");
      _showMsg('Confirm Success');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeOwner()),
      );
    } else {
      _showMsg('Confirm Failed');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeOwner()),
      );
    }
  }
}
