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

class EditWarehouseOwner extends StatefulWidget {
  final Map warehouse;

  const EditWarehouseOwner({super.key, required this.warehouse});
  @override
  State<EditWarehouseOwner> createState() => _EditWarehouseOwnerState();
}

class _EditWarehouseOwnerState extends State<EditWarehouseOwner> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late String name, desc, address, luas, type;
  late int hargam2;
  @override
  void initState() {}

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
        title: Text('Edit Warehouse'),
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
                          initialValue: widget.warehouse['name'],
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          cursorColor: kPrimaryColor,
                          onSaved: (name) {},
                          decoration: InputDecoration(
                            hintText: "Warehouse Name",
                          ),
                          validator: (nameValue) {
                            if (nameValue!.isEmpty) {
                              return 'Please enter Warehouse Name';
                            }
                            name = nameValue;
                            return null;
                          }),
                      TextFormField(
                          initialValue: widget.warehouse['deskripsi'],
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          cursorColor: kPrimaryColor,
                          onSaved: (desc) {},
                          decoration: InputDecoration(
                            hintText: "Description",
                          ),
                          validator: (descValue) {
                            if (descValue!.isEmpty) {
                              return 'Please enter Description';
                            }
                            desc = descValue;
                            return null;
                          }),
                      TextFormField(
                          initialValue: widget.warehouse['alamat'],
                          keyboardType: TextInputType.streetAddress,
                          textInputAction: TextInputAction.next,
                          cursorColor: kPrimaryColor,
                          onSaved: (address) {},
                          decoration: InputDecoration(
                            hintText: "Address",
                          ),
                          validator: (addressValue) {
                            if (addressValue!.isEmpty) {
                              return 'Please enter Address';
                            }
                            address = addressValue;
                            return null;
                          }),
                      TextFormField(
                          initialValue: widget.warehouse['luas_total'],
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          cursorColor: kPrimaryColor,
                          onSaved: (luas) {},
                          decoration: InputDecoration(
                            hintText: "Luas Total",
                          ),
                          validator: (largeValue) {
                            if (largeValue!.isEmpty) {
                              return 'Please enter Luas Total';
                            }
                            luas = largeValue;
                            return null;
                          }),
                      TextFormField(
                          initialValue: widget.warehouse['harga_m2'].toString(),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          cursorColor: kPrimaryColor,
                          onSaved: (hargam2) {},
                          decoration: InputDecoration(
                            hintText: "Harga m2",
                          ),
                          validator: (priceValue) {
                            if (priceValue!.isEmpty) {
                              return 'Please enter Harga m2';
                            }
                            hargam2 = int.parse(priceValue);
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
      'user_owner_id': widget.warehouse['user_owner_id'],
      'name': name,
      'deskripsi': desc,
      'alamat': address,
      'luas_total': luas,
      'harga_m2': hargam2,
    };

    var res = await Network()
        .postData(data, '/update-warehouse/${widget.warehouse['id']}');
    var body = json.decode(res.body);
    print(body);
    if (body['success'] != null) {
      print("test2");
      _showMsg("Edit Success");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeOwner()),
      );
    } else {
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
