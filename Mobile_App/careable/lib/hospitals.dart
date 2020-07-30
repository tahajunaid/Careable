import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'colors.dart';

class Hospitals extends StatefulWidget {
  @override
  _HospitalsState createState() => _HospitalsState();
}

class _HospitalsState extends State<Hospitals> {
  Icon _searchIcon = Icon(
    Icons.search,
    color: hospgreen,
    size: 30,
  );
  final Location location = Location();

  LocationData _location;
  String _error;
  var ulat, ulon;

  _getLocation() async {
    setState(() {
      _error = null;
    });
    try {
      LocationData _locationResult = await location.getLocation();
      setState(() {
        _location = _locationResult;
      });
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
      });
    } finally {
      print(" ${_location.latitude} , ${_location.longitude}");
      this.ulat = _location.latitude;
      this.ulon = _location.longitude;
    }
  }

  Future allPerson() async {
    await Future.delayed(Duration(seconds: 3));
    print("${this.ulat},${this.ulon}");
    var url = "https://careableindia.000webhostapp.com/fetchHosps.php";
    //var response = await http.get(url);
    //return jsonDecode(response.body);
    //print("$ulat, $ulon");

    final response = await http.post(url,
        body: {"lat": this.ulat.toString(), "lon": this.ulon.toString()});
    try {
      jsonDecode(response.body);
    } catch (e) {
      print("exception caught : $e");
    } finally {
      print("hospitals in 30km radius");
    }
    //print(jsonDecode(response.body));
    return jsonDecode(response.body);
  }

  bool isSearchClicked = false;
  final TextEditingController _filter = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getPref();
    _getLocation();
  }

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();
  void _showSnackBarMsg(String msg) {
    _scaffoldstate.currentState.showSnackBar(new SnackBar(
      content: new Text(msg),
    ));
  }

  int currentIndex = 0;
  String email;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString("email");
    });
    print("email :" + email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
              return <Widget>[createSilverAppBar()];
            },
            body: FutureBuilder(
                future: isSearchClicked ? _searchHosps() : allPerson(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            List list = snapshot.data;
                            return _buildListItem(
                                list[index]['image'],
                                list[index]['hospname'],
                                list[index]['address'],
                                list[index]['beds'],
                                list[index]['latitude'],
                                list[index]['longitude']);
                          })
                      : Container(
                          child: Center(
                              child: Container(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(),
                        )));
                })));
  }

  SliverAppBar createSilverAppBar() {
    return SliverAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: hospgreen),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: _searchIcon,
          onPressed: () {
            _searchPressed();
          },
        ),
      ],
      expandedHeight: 0,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(top: 7, bottom: 7),
          centerTitle: true,
          title: isSearchClicked
              ? Container(
                  //padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(minHeight: 40, maxHeight: 40),
                  width: 300,
                  child: CupertinoTextField(
                    controller: _filter,
                    autofocus: true,
                    onChanged: (text) {
                      setState(() {});
                    },
                    keyboardType: TextInputType.text,
                    placeholder: "Search Hospitals",
                    placeholderStyle: TextStyle(
                      color: Color(0xffC4C6CC),
                      fontSize: 17.0,
                      fontFamily: 'Brutal',
                    ),
                    prefix: Padding(
                      padding: const EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
                      child: Icon(
                        Icons.search,
                        color: hospgreen,
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: hospgreen)),
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(5),
                  child: Image.asset(
                    'assets/logoflat.png',
                    fit: BoxFit.contain,
                    width: 300,
                    height: 35,
                  ))),
    );
  }

  _searchHosps() async {
    var url = "https://careableindia.000webhostapp.com/searchHosps.php";
    final response = await http.post(url, body: {"search": _filter.text});
    try {
      jsonDecode(response.body);
    } catch (e) {
      print("exception caught : $e");
    } finally {
      print("searched hospital");
    }
    //print(jsonDecode(response.body));
    return jsonDecode(response.body);
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(
          Icons.close,
          color: hospgreen,
        );
        isSearchClicked = true;
      } else {
        this._searchIcon = Icon(
          Icons.search,
          color: hospgreen,
        );
        isSearchClicked = false;
        _filter.clear();
      }
    });
  }

  Widget _buildListItem(String imageLink, String name, String address,
      String beds, String hlat, String hlon) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
                width: 115.0,
                height: 125.0,
                child: CachedNetworkImage(
                  imageUrl: imageLink,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 115.0,
                    height: 125.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                      child: Center(
                          child: Container(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ))),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )),
            SizedBox(width: 2.0),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              height: 135.0,
              width: width / 1.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: <Widget>[
                      Text(
                        address,
                        style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Montserrat',
                            // fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "Beds Available : " + beds,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Montserrat',
                        // fontWeight: FontWeight.bold,
                        color: Colors.redAccent),
                  ),
                ],
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.directions,
                  color: hospgreen,
                ),
                onPressed: () {
                  print("$hlat,$hlon");
                  _launchMapsUrl(double.parse(hlat), double.parse(hlon));
                })
          ],
        ),
      ],
    );
  }

  void _launchMapsUrl(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
