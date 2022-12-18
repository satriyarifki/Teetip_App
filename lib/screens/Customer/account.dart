import 'package:flutter/material.dart';
import 'settings.dart';

class AccountCust extends StatelessWidget {
  const AccountCust({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(onPressed: () => SettingCust(), icon: Icon(Icons.back_hand)),
    );
  }
}