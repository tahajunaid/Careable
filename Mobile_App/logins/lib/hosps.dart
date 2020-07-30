import 'package:flutter/material.dart';
import 'package:logins/hospdash.dart';
import 'colors.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geocoder/geocoder.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  //final _key = new GlobalKey<FormState>();

  File _image;
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();
  final _licenseController = TextEditingController();
  final _hospnameController = TextEditingController();
  final _addressController = TextEditingController();
  final _bedsController = TextEditingController();
  final _passwordController = TextEditingController();
  final _unfocusedColor = Colors.grey[600];
  final _hospnameFocusNode = FocusNode();
  final _licenseFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _bedsFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _passwordVisible;
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;

    _bedsFocusNode.addListener(() {
      setState(() {});
    });
    _hospnameFocusNode.addListener(() {
      setState(() {});
    });
    _licenseFocusNode.addListener(() {
      setState(() {});
    });
    _addressFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  List<Address> results = [];
  var lat;
  var lon;
  Future search(String address) async {
    try {
      var geocoding = Geocoder.google("YOUR API KEY");
      var results = await geocoding.findAddressesFromQuery(address);
      this.setState(() {
        this.results = results;
        if (this.results[0].coordinates != null) {
          lat = this.results[0].coordinates.latitude;
          lon = this.results[0].coordinates.longitude;
        } else {
          lat = null;
          lon = null;
        }
      });
    } catch (e) {
      print("Error occured: $e");
    } finally {
      print("$lat , $lon");
    }
  }

  Future getFile() async {
    File image = await FilePicker.getFile();

    setState(() {
      _image = image;
    });
  }

  void _uploadFile(filePath) async {
    String fileName = basename(filePath.path);
    print("file base name:$fileName");

    try {
      FormData formData = new FormData.fromMap({
        "license": _licenseController.text,
        "hospname": _hospnameController.text,
        "address": _addressController.text,
        "beds": _bedsController.text,
        "password": _passwordController.text,
        "image":
            await MultipartFile.fromFile(filePath.path, filename: fileName),
        "latitude": lat,
        "longitude": lon,
      });

      Response response = await Dio().post(
          "https://careableindia.000webhostapp.com/hospReg.php",
          data: formData);
      print("File upload response: $response");
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

//added
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
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
                        SizedBox(height: height / 3.2),
                        TextField(
                          controller: _licenseController,
                          cursorColor: hospgreen,
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
                        SizedBox(height: height / 45),
                        TextField(
                          controller: _hospnameController,
                          cursorColor: hospgreen,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.business,
                              color: _hospnameFocusNode.hasFocus
                                  ? hospgreen
                                  : _unfocusedColor,
                            ),
                            labelText: 'Hospital Name',
                            labelStyle: TextStyle(
                                color: _hospnameFocusNode.hasFocus
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
                          focusNode: _hospnameFocusNode,
                        ),
                        SizedBox(height: height / 45),
                        TextField(
                          controller: _addressController,
                          cursorColor: hospgreen,
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 63),
                              child: Icon(
                                Icons.location_on,
                                color: _addressFocusNode.hasFocus
                                    ? hospgreen
                                    : _unfocusedColor,
                              ),
                            ),
                            labelText: 'Address',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(
                                color: _addressFocusNode.hasFocus
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
                          focusNode: _addressFocusNode,
                        ),
                        SizedBox(height: height / 45),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: _bedsController,
                          cursorColor: hospgreen,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.local_hotel,
                              color: _bedsFocusNode.hasFocus
                                  ? hospgreen
                                  : _unfocusedColor,
                            ),
                            labelText: 'Current Number of Beds Available',
                            labelStyle: TextStyle(
                                color: _bedsFocusNode.hasFocus
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
                          focusNode: _bedsFocusNode,
                        ),
                        SizedBox(
                          height: height / 43,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                getFile();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(20),
                                  /* boxShadow: [
                    new BoxShadow(
                        color: Colors.blueGrey,
                        offset: new Offset(10, 10),
                        blurRadius: 8.0,
                        spreadRadius: 0.0)
                  ],*/
                                ),
                                width: 150,
                                height: 150,
                                child: _image == null
                                    ? Center(
                                        child: Icon(
                                          Icons.add_a_photo,
                                          size: 40,
                                        ),
                                      )
                                    : Image.file(
                                        _image,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height / 43,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          cursorColor: hospgreen,
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
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
                                    search(_addressController.text);
                                    _uploadFile(_image);
                                    //check();
                                    //Navigator.pop(context);
                                  },
                                )),
                          ],
                        ),
                        SizedBox(
                          height: height / 30,
                        ),
                      ],
                    ),
                  ),
                ))));
  }
}
