import 'package:flutter/material.dart';
import 'colors.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:page_transition/page_transition.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _unfocusedColor = Colors.grey[600];
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _passwordVisible;
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;

    _emailFocusNode.addListener(() {
      setState(() {});
    });
    _nameFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  void _reguser() async {
    try {
      FormData formData = new FormData.fromMap({
        "email": _emailController.text,
        "name": _nameController.text,
        "password": _passwordController.text,
      });

      Response response = await Dio().post(
          "https://careableindia.000webhostapp.com/userReg.php",
          data: formData);
      print(response.data['message']);
      _showSnackBarMsg(response.data['message']);
    } catch (e) {
      print("exception caught : $e");
    }
  }

  void _showSnackBarMsg(String msg) {
    _scaffoldstate.currentState.showSnackBar(new SnackBar(
      content: new Text(msg),
    ));
  }

  @override
  Widget build(BuildContext context) {
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
                    //title: ,
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                  ),
                  body: SafeArea(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      children: <Widget>[
                        SizedBox(height: height / 3.3),
                        TextField(
                          controller: _nameController,
                          cursorColor: hospgreen,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: _nameFocusNode.hasFocus
                                  ? hospgreen
                                  : _unfocusedColor,
                            ),
                            labelText: 'Full Name',
                            labelStyle: TextStyle(
                                color: _nameFocusNode.hasFocus
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
                          focusNode: _nameFocusNode,
                        ),
                        SizedBox(height: height / 45),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
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
                                    'SIGN UP',
                                    textScaleFactor: 1.6,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  elevation: 4.0,
                                  color: hospgreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    _showSnackBarMsg(
                                        "Please Wait...Signing Up...");
                                    _reguser();
                                  },
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ))));
  }
}
