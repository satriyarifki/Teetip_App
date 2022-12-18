import 'package:flutter/material.dart';
import 'package:teetip_app/screens/Customer/history.dart';
import 'package:teetip_app/screens/Customer/home.dart';
import 'notification.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teetip_app/network/api.dart';
import 'dart:convert';
import '../../constants.dart';

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

class SettingCust extends StatefulWidget {
  const SettingCust({super.key});

  @override
  State<SettingCust> createState() => _SettingCustState();
}

class _SettingCustState extends State<SettingCust> {
  late String CustName = '';

  @override
  void initState() {
    super.initState();
    _getCust();
  }

  _getCust() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    var res = await Network().getData('/get-customer/${user['id']}');
    var body = json.decode(res.body);
    print(body['customer']['name']);
    setState(() {
      CustName = body['customer']['name'];
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
            color: kPrimaryCustomer,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 3,
                  child:
                      ProfilePicture(name: CustName, radius: 40, fontsize: 21)),
              Expanded(
                  flex: 4,
                  child: Text(
                    CustName,
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  )),
            ],
          ),
        ),
        // Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Container(
          padding: EdgeInsets.symmetric(vertical: 30),
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
