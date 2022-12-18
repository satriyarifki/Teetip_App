import 'package:flutter/material.dart';
import 'package:teetip_app/network/api.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teetip_app/screens/Login/login_screen.dart';
import 'package:teetip_app/screens/login.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../Home.dart';
import '../../../constants.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpForm createState() => _SignUpForm();
}

const List<String> role = <String>['Customer', 'Owner'];
const List<int> role_ids = <int>[3, 4];

class _SignUpForm extends State<SignUpForm> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late String name, email, password;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _secureText = true;
  int dropdownValue = role_ids.first;
  int role_id = 3;
  String roletext = "";

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  roleChanges(val) {
    setState(() {
      dropdownValue = val!;
    });
  }

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (name) {},
              decoration: InputDecoration(
                hintText: "Your Name",
              ),
              validator: (nameValue) {
                if (nameValue!.isEmpty) {
                  return 'Please enter your name';
                }
                name = nameValue;
                return null;
              }),
          DropdownButton<int>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (int? value) {
              // This is called when the user selects an item.
              roleChanges(value);
              role_id = value!;
            },
            items: role_ids.map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(role[value - 3]),
              );
            }).toList(),
          ),
          TextFormField(
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
                _isLoading ? 'Proccessing..' : 'Sign Up',
                textDirection: TextDirection.ltr,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _register();
                }
              },
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _register() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'name': name,
      'role_id': role_id,
      'email': email,
      'password': password
    };

    var res = await Network().auth(data, '/auth/register');
    var body = json.decode(res.body);
    if (body['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      if (body['message']['name'] != null) {
        _showMsg(body['message']['name'][0].toString());
      } else if (body['message']['email'] != null) {
        _showMsg(body['message']['email'][0].toString());
      } else if (body['message']['password'] != null) {
        _showMsg(body['message']['password'][0].toString());
      }
    }

    setState(() {
      _isLoading = false;
    });
  }
}
