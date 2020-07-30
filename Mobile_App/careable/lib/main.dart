import 'dart:async';
import 'package:careable/ulogin.dart';
import 'package:careable/usignup.dart';

import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';

import 'colors.dart';

void main() => runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen()));

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        () => Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                duration: Duration(seconds: 2),
                child: MyHomePage())));
  }
//

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/Asset 29.png"), fit: BoxFit.cover)),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Hero(
                      transitionOnUserGestures: true,
                      tag: 'logo',
                      child: Image.asset("assets/Asset 17.png"),
                    )),
              ],
            )),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var devwidth = MediaQuery.of(context).size.width;
    var devheight = MediaQuery.of(context).size.height;
    print("$devwidth     $devheight");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Asset 29.png"), fit: BoxFit.fill)),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: Hero(
                          transitionOnUserGestures: true,
                          tag: 'logo',
                          child: Image.asset("assets/Asset 17.png"),
                        )),
                    SizedBox(
                      height: devheight / 2,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: devwidth / 5,
                        ),
                        Expanded(
                          child: ButtonTheme(
                              height: devheight / 15,
                              child: RaisedButton(
                                elevation: 0.8,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                color: hospgreen,
                                textColor: Colors.white,
                                child: Text(
                                  'SIGN UP',
                                  textScaleFactor: 1.8,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 500),
                                          child: SignUpPage()));
                                },
                              )),
                        ),
                        SizedBox(width: devwidth / 5),
                      ],
                    ),
                    SizedBox(
                      height: devwidth / 33,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: devwidth / 5,
                        ),
                        Expanded(
                          child: ButtonTheme(
                              height: devheight / 15,
                              child: RaisedButton(
                                elevation: 0.8,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                color: seagreen,
                                textColor: Colors.white,
                                child: Text(
                                  'LOGIN',
                                  textScaleFactor: 1.8,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 500),
                                          child: LoginPage()));
                                },
                              )),
                        ),
                        SizedBox(
                          width: devwidth / 5,
                        ),
                      ],
                    ),
                  ],
                ),
              ))),
    );
  }
}
