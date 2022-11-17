import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
    this.logo = "assets/images/teetip-logo.png",
  }) : super(key: key);

  final String logo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 3,
              child: Image.asset(
                logo,
              ),
            ),
            const Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding * 4),
        Text(
          "SIGN UP",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
