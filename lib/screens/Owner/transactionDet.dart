import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teetip_app/network/api.dart';
import 'package:intl/intl.dart';
import 'package:teetip_app/screens/Customer/home.dart';
import 'package:teetip_app/screens/Customer/home_list.dart';
import 'package:teetip_app/screens/Owner/home.dart';
import 'dart:convert';

import '../../constants.dart';
import '../Login/login_screen.dart';

class TransactionDetailsOwner extends StatefulWidget {
  final Map transaction;

  const TransactionDetailsOwner({super.key, required this.transaction});
  @override
  State<TransactionDetailsOwner> createState() => _AddPartOwnerState();
}

class _AddPartOwnerState extends State<TransactionDetailsOwner> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late int price, long, width;
  final format = DateFormat('dd-MM-yyyy');
  @override
  void initState() {}

  _showMsg(msg) {
    final snackBarr = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBarr);
  }

  Future getTransaction() async {
    var res = await Network()
        .getData('/owner-transaction/${widget.transaction['id']}');
    var body = json.decode(res.body);
    return body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details'),
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
            Card(
              elevation: 3,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                            Text('ID : ' + widget.transaction['txid']),
                            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                            if (widget.transaction['status'] == 'unpaid') ...[
                              Text(
                                widget.transaction['status'],
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ] else if (widget.transaction['status'] ==
                                'processing') ...[
                              Text(
                                widget.transaction['status'],
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold),
                              ),
                            ] else ...[
                              Text(
                                widget.transaction['status'],
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
                            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                            Text('Start Date : ' +
                                format.format(DateTime.parse(
                                    widget.transaction['start_at']))),
                            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                            Text('End Date   : ' +
                                format.format(DateTime.parse(
                                    widget.transaction['end_at']))),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                ],
              ),
            ),
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
