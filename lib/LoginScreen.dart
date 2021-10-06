// ignore_for_file: file_names, prefer_final_fields

import 'package:flutter/material.dart';

import './utilities/utility.dart';
import './utilities/CustomShapeClipper.dart';

import './data/ApiData.dart';

import 'Calender.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  String _email = '';
  TextEditingController _teContEmail = TextEditingController();

  String _password = '';
  TextEditingController _teContPassword = TextEditingController();

  String _errorMsg = "";

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    _teContEmail.text = '';
    _teContPassword.text = '';
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(context: context),
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: size.height * 0.7,
              width: size.width * 0.7,
              margin: const EdgeInsets.only(top: 5, left: 6),
              color: Colors.yellowAccent.withOpacity(0.2),
              child: Text(
                '■',
                style: TextStyle(color: Colors.white.withOpacity(0.1)),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.black.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextField(
                              style: const TextStyle(fontSize: 13),
                              controller: _teContEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Enter MailAddress',
                                labelText: 'MailAddress',
                              ),
                              obscureText: false,
                              autocorrect: true,
                              enableInteractiveSelection: true,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _email = value;
                                  },
                                );
                              },
                            ),
                            TextField(
                              style: const TextStyle(fontSize: 13),
                              controller: _teContPassword,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Enter password',
                                labelText: 'Password',
                              ),
                              autocorrect: false,
                              enableInteractiveSelection: false,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _password = value;
                                  },
                                );
                              },
                            ),
                            Container(
                              height: 50,
                              padding: const EdgeInsets.only(top: 20),
                              alignment: Alignment.topLeft,
                              child: (_errorMsg != "")
                                  ? Text(
                                      _errorMsg,
                                      style: const TextStyle(
                                          color: Colors.yellowAccent),
                                    )
                                  : null,
                            ),
                            ElevatedButton(
                              onPressed: () => _getLoginToken(),
                              child: const Text('login'),
                            ),
                            const Divider(color: Colors.indigo),
                            ElevatedButton(
                              onPressed: () => _setMyAccount(),
                              child: const Text('set my account'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.pinkAccent.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  void _getLoginToken() async {
    await apiData.getAuthOfLogin(email: _email, password: _password);

    // ignore: unnecessary_null_comparison
    if (apiData.AuthOfLogin == null) {
      _errorMsg = "login error";
    } else if (apiData.AuthOfLogin['token'] == "") {
      _errorMsg = "login error";
    } else {
      _teContEmail.text = "";
      _teContPassword.text = "";

      _email = "";
      _password = "";

      _errorMsg = "";

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Calender(),
        ),
      );
    }
    apiData.AuthOfLogin = {};

    setState(() {});
  }

  ///
  void _setMyAccount() {
    _teContEmail.text = "hide.toyoda@gmail.com";
    _teContPassword.text = "Hidechy4819@";

    _email = "hide.toyoda@gmail.com";
    _password = "Hidechy4819@";
  }
}
