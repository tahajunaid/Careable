import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logins/hospdash.dart';
import 'colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginPageState extends State<LoginPage> {
  String license, password;
  final _licenseController = TextEditingController();

  final _passwordController = TextEditingController();
  final _unfocusedColor = Colors.grey[600];

  final _licenseFocusNode = FocusNode();

  final _passwordFocusNode = FocusNode();
  bool _passwordVisible;
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  final _key = new GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    getPref();
    _passwordVisible = false;

    _licenseFocusNode.addListener(() {
      setState(() {});
    });

    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  check() {
    //final form = _key.currentState;
    //if (form.validate()) {
    print("valid form");
    // form.save();
    login();
    //}
  }

  login() async {
    var url = "https://careableindia.000webhostapp.com/hospLogin.php";

    final response = await http.post(url, body: {
      "license": _licenseController.text.toString(),
      "password": _passwordController.text.toString()
    });

    int value;
    String message;
    String license;
    String status;
    //var response2 = await http.get(url);
    //final data = jsonDecode(response2.body);
    try {
      final data = jsonDecode(response.body);
      value = data['value'];
      message = data['message'];
      license = data['license'];
      status = data['status'];
      print("$value  $message $license $status");
    } catch (e) {
      print("exception caught : $e");
    }

    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, license);
      });
      print(message);
      //loginToast(message);
    } else {
      print("fail");
      print(message);
      //loginToast(message);
    }
  }

  savePref(int value, String license) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("license", license);
      preferences.commit();
    });
  }

  var value;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("license", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        var width = MediaQuery.of(context).size.width;
        var height = MediaQuery.of(context).size.height;
        return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/fullback3.png"),
                            fit: BoxFit.fill)),
                    child: Scaffold(
                      extendBodyBehindAppBar: true,
                      backgroundColor: Colors.transparent,
                      appBar: new AppBar(
                        leading: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: hospgreen,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        centerTitle: true,
                        //title: ,
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                      ),
                      body: SafeArea(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          children: <Widget>[
                            SizedBox(height: height / 3),
                            TextFormField(
                              controller: _licenseController,
                              cursorColor: hospgreen,
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Please Insert Email";
                                }
                              },
                              onSaved: (e) => license = e,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.note,
                                  color: _licenseFocusNode.hasFocus
                                      ? hospgreen
                                      : _unfocusedColor,
                                ),
                                labelText: 'License Number',
                                labelStyle: TextStyle(
                                    color: _licenseFocusNode.hasFocus
                                        ? hospgreen
                                        : _unfocusedColor),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(color: hospgreen),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(color: hospgreen),
                                ),
                              ),
                              focusNode: _licenseFocusNode,
                            ),
                            SizedBox(
                              height: 17,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              cursorColor: hospgreen,
                              controller: _passwordController,
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Password Can't be Empty";
                                }
                              },
                              onSaved: (e) => password = e,
                              obscureText: !_passwordVisible,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: _passwordFocusNode.hasFocus
                                      ? hospgreen
                                      : _unfocusedColor,
                                ),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    color: _passwordFocusNode.hasFocus
                                        ? hospgreen
                                        : _unfocusedColor),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(color: hospgreen),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(color: hospgreen),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: _passwordFocusNode.hasFocus
                                        ? hospgreen
                                        : _unfocusedColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                              focusNode: _passwordFocusNode,
                            ),
                            SizedBox(
                              height: height / 45,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ButtonTheme(
                                    height: height / 15,
                                    minWidth: width / 3,
                                    child: RaisedButton(
                                      child: Text(
                                        'LOGIN',
                                        textScaleFactor: 1.6,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      elevation: 4.0,
                                      color: hospgreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0)),
                                      ),
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        check();
                                      },
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ))));
        break;

      case LoginStatus.signIn:
        return HospDash(signOut);
        break;
    }
  }
}
