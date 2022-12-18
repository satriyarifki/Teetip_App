import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teetip_app/network/api.dart';
import 'package:teetip_app/screens/Customer/home.dart';
import 'package:teetip_app/screens/Customer/home_list.dart';
import 'dart:convert';
import '../../constants.dart';
import '../Login/login_screen.dart';

class WarehouseCust extends StatefulWidget {
  final String name;
  final List detail;
  final Map warehouse;
  const WarehouseCust(
      {super.key,
      required this.name,
      required this.detail,
      required this.warehouse});

  @override
  State<WarehouseCust> createState() => _WarehouseCustState();
}

class _WarehouseCustState extends State<WarehouseCust> {
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
    ListDetail();
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

  ListDetail() {
    print(widget.detail.toString());
    if (!widget.detail.isEmpty) {
      dropdownArea = widget.detail.first['id'];
      for (var i = 0; i < widget.detail.length; i++) {
        detailId.add(widget.detail[i]['id']);
        detailluas.add(widget.detail[i]['luas_petak']);
        listHarga.add(widget.detail[i]['luas_petak']);
      }
    } else {
      dropdownArea = 0;
      detailId.add(0);
      detailluas.add(0);
      listHarga.add(0);
    }
  }

  _showMsg(msg) {
    final snackBarr = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBarr);
  }

  DateTimeRange selectedDates =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          "${selectedDates.start.day}/${selectedDates.start.month}/${selectedDates.start.year}  -  ${selectedDates.end.day}/${selectedDates.end.month}/${selectedDates.end.year}"),
                      ElevatedButton(
                        child: Text("Choose Range Date"),
                        onPressed: () async {
                          final DateTimeRange? dateTimeRange =
                              await showDateRangePicker(
                                  context: context,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100));
                          if (dateTimeRange != null) {
                            setState(
                              () {
                                selectedDates = dateTimeRange;
                              },
                            );
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Luas Petak : "),
                          DropdownButton(
                              value: dropdownArea,
                              onChanged: (int? value) {
                                setState(() {
                                  if (detailId != null) {
                                    dropdownArea = value!;
                                  } else {
                                    null;
                                  }
                                });
                                idDetail = value!;
                              },
                              items: detailId
                                  .map<DropdownMenuItem<int>>((int value) {
                                return new DropdownMenuItem<int>(
                                  value: value,
                                  child: new Text(
                                    "${detailluas[detailId.indexOf(value)]} m2",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                );
                              }).toList()),
                        ],
                      ),
                    ],
                  )),
              title: Text('Form Pemesanan'),
              actions: <Widget>[
                Ink(
                  height: 30,
                  width: 80,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.blueGrey),
                  child: InkWell(
                    child: Text(
                      'Submit',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        // Do something like updating SharedPreferences or User Settings etc.
                        // Navigator.of(context).pop();
                        _store();
                      }
                    },
                  ),
                )
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Warehouse'),
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
            await showInformationDialog(context);
          },
          child: Text('Order'),
        ),
      ),
    );
  }

  void _store() async {
    var data = {
      'idCust': idCust,
      'start_at': selectedDates.start.toIso8601String(),
      'end_at': selectedDates.end.toIso8601String(),
      'total_hari': selectedDates.duration.inDays,
      'detailId': dropdownArea,
      // 'information': "",
      'harga': listHarga[detailId.indexOf(dropdownArea)],
      'luas': detailluas[detailId.indexOf(dropdownArea)],
    };
    print("${idCust}");
    print("${selectedDates.start}");
    print("${dropdownArea}");
    print("${listHarga[detailId.indexOf(dropdownArea)]}");
    print("${detailluas[detailId.indexOf(dropdownArea)]}");

    var res = await Network().postData(data, '/store-transaction');
    var body = json.decode(res.body);
    print(body);
    if (body['success'] != null) {
      print("test2");
      _showMsg('Order Success');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeCust()),
      );
    } else {
      _showMsg('Order Failed');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeCust()),
      );
    }
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
          context, MaterialPageRoute(builder: (context) => HomeCust()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeCust()));
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
}
