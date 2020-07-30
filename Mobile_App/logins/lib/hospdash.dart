import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class HospDash extends StatefulWidget {
  final VoidCallback signOut;

  HospDash(this.signOut);
  @override
  _HospDashState createState() => _HospDashState();
}

class _HospDashState extends State<HospDash> {
  final _bedsUpdateController = TextEditingController();
  final _unfocusedColor = Colors.grey[600];

  final _bedsUpdateFocusNode = FocusNode();

  //added
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String license;
  void _updatebeds() async {
    try {
      FormData formData = new FormData.fromMap({
        "beds": int.parse(_bedsUpdateController.text),
        "license": license,
      });

      Response response = await Dio().post(
          "https://careableindia.000webhostapp.com/updateBeds.php",
          data: formData);
      print("File upload response: $response");
      _showSnackBarMsg(response.data['message']);
    } catch (e) {
      print("exception caught : $e");
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();
  void _showSnackBarMsg(String msg) {
    _scaffoldstate.currentState.showSnackBar(new SnackBar(
      content: new Text(msg),
    ));
  }

  int currentIndex = 0;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      license = preferences.getString("license");
    });
    print("license :" + license);
  }
  //add ends

  @override
  void initState() {
    super.initState();
    getPref();
    _bedsUpdateFocusNode.addListener(() {
      setState(() {});
    });
  }

  void choiceAction(choice) {
    if (choice == "Contact Us") {
      print('ContactUs');
    } else if (choice == "Sign Out") {
      signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/fullback3.png"),
                    fit: BoxFit.fill)),
            child: Scaffold(
              key: _scaffoldstate,
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
              appBar: new AppBar(
                centerTitle: true,
                actions: <Widget>[
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    onSelected: choiceAction,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text("Contact Us"),
                        value: "Contact Us",
                      ),
                      PopupMenuItem(
                        child: Text("Sign Out"),
                        value: "Sign Out",
                      ),
                    ],
                  ),
                ],
                // title: Image.asset('assets/bklslogo2.png', fit: BoxFit.cover),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: SafeArea(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  children: <Widget>[
                    SizedBox(height: height / 3),
                    TextField(
                      controller: _bedsUpdateController,
                      keyboardType: TextInputType.number,
                      cursorColor: hospgreen,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.local_hotel,
                          color: _bedsUpdateFocusNode.hasFocus
                              ? hospgreen
                              : _unfocusedColor,
                        ),
                        labelText: 'Update Available Beds',
                        labelStyle: TextStyle(
                            color: _bedsUpdateFocusNode.hasFocus
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
                      focusNode: _bedsUpdateFocusNode,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        /*FlatButton(
                  child: Text('BACK'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () {
                    _addressController.clear();
                    _licenseController.clear();
                    _bedsController.clear();
                    _hospnameController.clear();
                    _passwordController.clear();
                  },
                ),*/

                        ButtonTheme(
                            height: height / 15,
                            minWidth: width / 3,
                            child: RaisedButton(
                              child: Text(
                                'UPDATE',
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
                                _updatebeds();
                              },
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
}
