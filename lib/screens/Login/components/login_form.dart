import 'package:flutter/material.dart';
import 'package:teetip_app/network/api.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teetip_app/screens/Signup/components/signup_form.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../Home.dart';
import '../../Customer/home.dart';
import '../../Owner/home.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';
import 'dart:developer';

class LoginForm extends StatefulWidget {
  @override
  _LoginForm createState() => _LoginForm();
}

class _LoginForm extends State<LoginForm> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email, password;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  _showMsg(msg) {
    final snackBarr = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBarr);
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
              initialValue: 'customer@teetip.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: InputDecoration(
                hintText: "Your email",
              ),
              validator: (emailValue) {
                if (emailValue!.isEmpty) {
                  return 'Please enter your email';
                }
                email = emailValue;
                return null;
              }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
                initialValue: 'customer',
                textInputAction: TextInputAction.done,
                obscureText: _secureText,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  hintText: "Your password",
                  suffixIcon: IconButton(
                    onPressed: showHide,
                    icon: Icon(
                        _secureText ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
                validator: (passwordValue) {
                  if (passwordValue!.isEmpty) {
                    return 'Please enter your password';
                  }
                  password = passwordValue;
                  return null;
                }),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              child: Text(
                _isLoading ? 'Proccessing..' : 'Login',
                textDirection: TextDirection.ltr,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _login();
                }
              },
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    var data = {'email': email, 'password': password};

    var res = await Network().auth(data, '/auth/login');
    var body = json.decode(res.body);
    // log("$body['success']");
    if (body['success'] == true) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      int role_id = body['user']['role_id'];
      log('$role_id');
      if (role_id == 3) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (context) => HomeCust()),
        );
      } else if (role_id == 4) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (context) => HomeOwner()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (context) => Home()),
        );
      }
    } else {
      log(body['message']);
      _showMsg(body['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
