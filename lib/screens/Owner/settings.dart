import 'package:flutter/material.dart';
import 'package:teetip_app/screens/Customer/account.dart';
import 'package:teetip_app/screens/Customer/help.dart';
import 'package:teetip_app/screens/Customer/notification.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import '../Customer/history.dart';
import '../Customer/home_list.dart';
import '../../constants.dart';
import '../Customer/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teetip_app/network/api.dart';
import 'dart:convert';
import 'dart:developer';

List<String> texts = [
  // 'Notifikasi',
  'Riwayat Transaksi',
  'Pengaturan Akun',
  'Bantuan'
];
List<IconData> icons = [
  // Icons.notifications,
  Icons.history,
  Icons.account_box,
  Icons.help_center
];
// List<Widget> pagelist = <Widget>[
//   // NotifCust(),
//   HistoryCust(),
//   AccountCust(),
//   HelpCust(),
// ];

class SettingOwner extends StatefulWidget {
  const SettingOwner({super.key});

  @override
  State<SettingOwner> createState() => _SettingOwnerState();
}

class _SettingOwnerState extends State<SettingOwner> {
  late String OwnerName = '';

  @override
  void initState() {
    super.initState();
    _getOwnerWarehouse();
    print(OwnerName);
  }

  _getOwnerWarehouse() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    var res = await Network().getData('/owner-warehouse/${user['id']}');
    var body = json.decode(res.body);
    print(body['owner']['name']);
    setState(() {
      OwnerName = body['owner']['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 6,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: kPrimaryOwner,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 3,
                  child: ProfilePicture(
                      name: OwnerName, radius: 40, fontsize: 21)),
              Expanded(
                  flex: 4,
                  child: Text(
                    OwnerName,
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  )),
            ],
          ),
        ),
        // Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          // color: Colors.green,
          height: MediaQuery.of(context).size.height * (5 / 8),
          child: ListView.separated(
            itemCount: texts.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  leading: Icon(icons[index]),
                  title: Text(texts[index]),
                  onTap: () {
                    if (texts[index] == 'Riwayat Transaksi') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HisotryCustomer()),
                      );
                    } else if (texts[index] == 'Pengaturan Akun') {
                    } else {}
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        )
      ],
    ));
  }
}
