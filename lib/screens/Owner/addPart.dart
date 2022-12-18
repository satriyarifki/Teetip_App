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

class AddPartOwner extends StatefulWidget {
  final int houseId;

  const AddPartOwner({super.key, required this.houseId});
  @override
  State<AddPartOwner> createState() => _AddPartOwnerState();
}

class _AddPartOwnerState extends State<AddPartOwner> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late int price, long, width;
  @override
  void initState() {
    print(widget.houseId);
  }

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
        title: Text('Add Part Warehouse'),
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
                    children: [
                      TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          cursorColor: kPrimaryColor,
                          onSaved: (long) {},
                          decoration: InputDecoration(
                            hintText: "Panjang Petak",
                          ),
                          validator: (longValue) {
                            if (longValue!.isEmpty) {
                              return 'Please enter Panjang';
                            }
                            long = int.parse(longValue);
                            return null;
                          }),
                      TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          cursorColor: kPrimaryColor,
                          onSaved: (width) {},
                          decoration: InputDecoration(
                            hintText: "Panjang Petak",
                          ),
                          validator: (widthValue) {
                            if (widthValue!.isEmpty) {
                              return 'Please enter Lebar';
                            }
                            width = int.parse(widthValue);
                            return null;
                          }),
                      TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          cursorColor: kPrimaryColor,
                          onSaved: (price) {},
                          decoration: InputDecoration(
                            hintText: "Harga",
                          ),
                          validator: (priceValue) {
                            if (priceValue!.isEmpty) {
                              return 'Please enter Harga';
                            }
                            price = int.parse(priceValue);
                            return null;
                          }),
                    ],
                  )),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: Hero(
          tag: "add_button",
          child: ElevatedButton(
            child: Text(
              _isLoading ? 'Proccessing..' : 'Submit',
              textDirection: TextDirection.ltr,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _store();
              }
            },
          ),
        ),
      ),
    );
  }

  void _store() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'warehouse_id': widget.houseId,
      'panjang_petak': long,
      'lebar_petak': width,
      'luas_petak': width * long,
      'harga': price,
    };

    var res = await Network().postData(data, '/store-detail-warehouse');
    var body = json.decode(res.body);
    print(body);
    if (body['success'] != null) {
      print("test2");
      _showMsg("Add Part Success");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeOwner()),
      );
    } else {
      _showMsg("Failed to Add Part");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeOwner()),
      );
    }
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
