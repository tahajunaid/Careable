import 'package:careable/udash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();
  final _unfocusedColor = Colors.grey[600];

  final _emailFocusNode = FocusNode();

  final _passwordFocusNode = FocusNode();
  bool _passwordVisible;
  @override
  void initState() {
    super.initState();
    getPref();
    _getLocation();
    _passwordVisible = false;

    _emailFocusNode.addListener(() {
      setState(() {});
    });

    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  LoginStatus _loginStatus = LoginStatus.notSignIn;

  check() {
    print("logging in...");
    login();
  }

  login() async {
    var url = "https://careableindia.000webhostapp.com/userLogin.php";

    final response = await http.post(url, body: {
      "email": _emailController.text.toString(),
      "password": _passwordController.text.toString()
    });

    int value;
    String message;
    String email;
    String status;

    try {
      final data = jsonDecode(response.body);
      value = data['value'];
      message = data['message'];
      email = data['email'];
      status = data['status'];
      _showSnackBarMsg(message);
    } catch (e) {
      print("exception caught : $e");
    }

    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, email);
      });
      print(message);
    } else {
      print("fail");
      print(message);
    }
  }

  savePref(int value, String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("email", email);
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
      preferences.setString("email", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  final Location location = Location();

  LocationData _location;
  String _error;
  Future<void> _getLocation() async {
    setState(() {
      _error = null;
    });
    try {
      final LocationData _locationResult = await location.getLocation();
      setState(() {
        _location = _locationResult;
      });
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
      });
    } finally {
      print(" ${_location.latitude} , ${_location.longitude}");
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();
  void _showSnackBarMsg(String msg) {
    _scaffoldstate.currentState.showSnackBar(new SnackBar(
      content: new Text(msg),
    ));
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
                      key: _scaffoldstate,
                      backgroundColor: Colors.transparent,
                      extendBodyBehindAppBar: true,
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
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                      ),
                      body: SafeArea(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          children: <Widget>[
                            SizedBox(height: height / 3),
                            TextField(
                              controller: _emailController,
                              cursorColor: hospgreen,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.alternate_email,
                                  color: _emailFocusNode.hasFocus
                                      ? hospgreen
                                      : _unfocusedColor,
                                ),
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    color: _emailFocusNode.hasFocus
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
                              focusNode: _emailFocusNode,
                            ),
                            SizedBox(
                              height: height / 45,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              cursorColor: hospgreen,
                              controller: _passwordController,
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
                                        _showSnackBarMsg("Please Wait...");
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
        return UserDash(signOut);
        break;
    }
  }
}
