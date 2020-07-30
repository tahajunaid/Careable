import 'dart:convert';
import 'package:careable/watsonassistant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'hospitals.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:carousel_slider/carousel_slider.dart';

class UserDash extends StatefulWidget {
  final VoidCallback signOut;

  UserDash(this.signOut);
  @override
  _UserDashState createState() => _UserDashState();
}

_newsdata() async {
  var url = "https://careableindia.000webhostapp.com/news.php";
  final response = await http.get(url);
  try {
    jsonDecode(response.body);
  } catch (e) {
    print("exception caught : $e");
  } finally {
    print(response.body);
  }
  //print(jsonDecode(response.body));
  return jsonDecode(response.body);
}

void _launchurl(String newsurl) async {
  var url = newsurl;
  print(url);
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: FutureBuilder(
                  future: _newsdata(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              List list = snapshot.data;
                              return GestureDetector(
                                child: Stack(children: <Widget>[
                                  Image.network(
                                    list[index]['image'],
                                    fit: BoxFit.cover,
                                    width: 1000,
                                  ),
                                  Positioned(
                                    bottom: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(200, 0, 0, 0),
                                            Color.fromARGB(0, 0, 0, 0)
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 17.0, horizontal: 20.0),
                                      child: Text(
                                        "${list[index]['headline']}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                                onTap: () {
                                  _launchurl(list[index]['link'].toString());
                                },
                              );
                            })
                        : Container(
                            child: Center(
                                child: Container(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(),
                          )));
                  }),

              //
            ),
          ),
        ))
    .toList();
final List<String> imgList = ['1', '2', '3'];

class _UserDashState extends State<UserDash> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  Map worldData;
  fetchWorldWideData() async {
    http.Response response =
        await http.get('https://api.rootnet.in/covid19-in/stats/latest');
    setState(() {
      worldData = json.decode(response.body);
      worldData = worldData["data"];
      worldData = worldData["summary"];
      print(worldData);
    });
  }

  Map countryData;
  List statesData;
  fetchCountryData() async {
    http.Response response =
        await http.get('https://api.covid19india.org/data.json');
    setState(() {
      countryData = json.decode(response.body);
      statesData = countryData["statewise"] as List;
      print(statesData);
    });
  }

  @override
  void initState() {
    fetchWorldWideData();
    fetchCountryData();

    super.initState();
  }

  void choiceAction(choice) {
    if (choice == "Contact Us") {
      print('ContactUs');
    } else if (choice == "Sign Out") {
      signOut();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: hospgreen,
            ),
            onSelected: choiceAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Sign Out"),
                value: "Sign Out",
              ),
            ],
          ),
        ],
        title: Image.asset('assets/fulllogo.png', fit: BoxFit.cover),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          children: <Widget>[
            SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Column(
                  children: <Widget>[
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2.2,
                        enlargeCenterPage: true,
                      ),
                      items: imageSliders,
                    ),
                  ],
                )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Cases Count :',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: hospgreen),
                      ),
                    ],
                  ),
                ),
                worldData == null
                    ? Center(
                        widthFactor: width,
                        heightFactor: 200,
                        child: CircularProgressIndicator())
                    : WorldWidePanel(
                        worldData: worldData,
                      ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 1730,
                  child: statesData == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              height: 48,
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[100],
                                        blurRadius: 10,
                                        offset: Offset(0, 10)),
                                  ]),
                              child: Container(
                                height: height / 7,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        width: width / 3.8,
                                        child: statesData[index]['state'] !=
                                                "Total"
                                            ? Text(
                                                statesData[index]['state'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  Container(
                                                    alignment: Alignment.center,
                                                    child: Text("States",
                                                        style: TextStyle(
                                                            fontSize: 12.3,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: hospgreen)),
                                                  ),
                                                  Divider()
                                                ],
                                              )),
                                    Container(
                                      width: width / 6.3,
                                      child: statesData[index]['state'] !=
                                              "Total"
                                          ? Text(
                                              statesData[index]['confirmed']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Text("Confirmed",
                                                      style: TextStyle(
                                                          fontSize: 12.3,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: hospgreen)),
                                                ),
                                                Divider()
                                              ],
                                            ),
                                      alignment: Alignment.center,
                                    ),
                                    VerticalDivider(
                                      width: 6,
                                      thickness: 1,
                                      indent: 10,
                                      endIndent: 10,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      width: width / 7.5,
                                      child: statesData[index]['state'] !=
                                              "Total"
                                          ? Text(
                                              statesData[index]['active']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green),
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Text("Active",
                                                      style: TextStyle(
                                                          fontSize: 12.3,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: hospgreen)),
                                                ),
                                                Divider()
                                              ],
                                            ),
                                      alignment: Alignment.center,
                                    ),
                                    VerticalDivider(
                                      width: 6,
                                      thickness: 1,
                                      indent: 10,
                                      endIndent: 10,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      width: width / 5.95,
                                      child: statesData[index]['state'] !=
                                              "Total"
                                          ? Text(
                                              statesData[index]['recovered']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue),
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Text("Recovered",
                                                      style: TextStyle(
                                                          fontSize: 12.3,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: hospgreen)),
                                                ),
                                                Divider()
                                              ],
                                            ),
                                      alignment: Alignment.center,
                                    ),
                                    VerticalDivider(
                                      width: 6,
                                      thickness: 1,
                                      indent: 10,
                                      endIndent: 10,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      width: width / 8,
                                      child: statesData[index]['state'] !=
                                              "Total"
                                          ? Text(
                                              statesData[index]['deaths']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[700]),
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Text("Deaths",
                                                      style: TextStyle(
                                                          fontSize: 12.3,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: hospgreen)),
                                                ),
                                                Divider()
                                              ],
                                            ),
                                      alignment: Alignment.center,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: statesData == null ? 0 : statesData.length,
                        ),
                ),
                InfoPanel(),
                SizedBox(
                  height: 20,
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class InfoPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 500),
                      child: Hospitals()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              color: hospgreen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      height: 18,
                      child: Image.asset('assets/Asset 15.png',
                          fit: BoxFit.fitHeight)),
                  Text('COVID Assistance Centres Nearby',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 500),
                      child: Watson()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              color: hospgreen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.question_answer,
                    color: Colors.white,
                  ),
                  Text('Ask Watson ',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 500),
                      child: FAQPage()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              color: hospgreen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.library_books,
                    color: Colors.white,
                  ),
                  Text('FAQs',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              launch('https://covid19responsefund.org/en/');
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              color: hospgreen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.monetization_on,
                    color: Colors.white,
                  ),
                  Text('Donate To WHO ',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              launch(
                  'https://www.who.int/emergencies/diseases/novel-coronavirus-2019/advice-for-public/myth-busters');
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              color: hospgreen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.record_voice_over,
                    color: Colors.white,
                  ),
                  Text('Myth Busters',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          Divider(
            height: 30,
            color: Colors.grey[600],
          ),
          Text("Reach us at : careableindia@gmail.com ")
        ],
      ),
    );
  }
}

class WorldWidePanel extends StatelessWidget {
  final Map worldData;

  const WorldWidePanel({Key key, this.worldData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 2),
        children: <Widget>[
          StatusPanel(
            title: 'CONFIRMED',
            panelColor: Colors.red[100],
            textColor: Colors.red,
            count: worldData['total'].toString(),
          ),
          StatusPanel(
            title: 'ACTIVE',
            panelColor: Colors.blue[100],
            textColor: Colors.blue[900],
            count: (worldData['total'] -
                    (worldData['discharged'] + worldData['deaths']))
                .toString(),
          ),
          StatusPanel(
            title: 'RECOVERED',
            panelColor: Colors.green[100],
            textColor: Colors.green,
            count: worldData['discharged'].toString(),
          ),
          StatusPanel(
            title: 'DEATHS',
            panelColor: Colors.grey[500],
            textColor: Colors.grey[900],
            count: worldData['deaths'].toString(),
          ),
        ],
      ),
    );
  }
}

class StatusPanel extends StatelessWidget {
  final Color panelColor;
  final Color textColor;
  final String title;
  final String count;

  const StatusPanel(
      {Key key, this.panelColor, this.textColor, this.title, this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(10),
        child: Container(
          //margin: EdgeInsets.all(10),
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: panelColor,
          ),
          width: width / 2,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor),
              ),
              Text(
                count,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor),
              )
            ],
          ),
        ));
  }
}

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('FAQs', style: TextStyle(color: hospgreen)),
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: hospgreen,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ListView.builder(
          itemCount: DataSource.questionAnswers.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(
                DataSource.questionAnswers[index]['question'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    DataSource.questionAnswers[index]['answer'],
                    style: TextStyle(fontSize: 15),
                  ),
                )
              ],
            );
          }),
    );
  }
}

class DataSource {
  static String quote =
      "Nothing in life is to be feared, it is only to be understood. Now is the time to understand more, so that we may fear less.";

  static List<dynamic> questionAnswers = [
    {
      "question": "What is a coronavirus?",
      "answer":
          "Coronaviruses are a large family of viruses which may cause illness in animals or humans.  In humans, several coronaviruses are known to cause respiratory infections ranging from the common cold to more severe diseases such as Middle East Respiratory Syndrome (MERS) and Severe Acute Respiratory Syndrome (SARS). The most recently discovered coronavirus causes coronavirus disease COVID-19."
    },
    {
      "question": "What is COVID-19?",
      "answer":
          "COVID-19 is the infectious disease caused by the most recently discovered coronavirus. This new virus and disease were unknown before the outbreak began in Wuhan, China, in December 2019."
    },
    {
      "question": "What are the symptoms of COVID-19?",
      "answer":
          "The most common symptoms of COVID-19 are fever, tiredness, and dry cough. Some patients may have aches and pains, nasal congestion, runny nose, sore throat or diarrhea. These symptoms are usually mild and begin gradually. Some people become infected but don’t develop any symptoms and don't feel unwell. Most people (about 80%) recover from the disease without needing special treatment. Around 1 out of every 6 people who gets COVID-19 becomes seriously ill and develops difficulty breathing. Older people, and those with underlying medical problems like high blood pressure, heart problems or diabetes, are more likely to develop serious illness. People with fever, cough and difficulty breathing should seek medical attention."
    },
    {
      "question": "How does COVID-19 spread?",
      "answer":
          "People can catch COVID-19 from others who have the virus. The disease can spread from person to person through small droplets from the nose or mouth which are spread when a person with COVID-19 coughs or exhales. These droplets land on objects and surfaces around the person. Other people then catch COVID-19 by touching these objects or surfaces, then touching their eyes, nose or mouth. People can also catch COVID-19 if they breathe in droplets from a person with COVID-19 who coughs out or exhales droplets. This is why it is important to stay more than 1 meter (3 feet) away from a person who is sick. \nWHO is assessing ongoing research on the ways COVID-19 is spread and will continue to share updated findings."
    },
    {
      "question":
          "Can the virus that causes COVID-19 be transmitted through the air?",
      "answer":
          "Studies to date suggest that the virus that causes COVID-19 is mainly transmitted through contact with respiratory droplets rather than through the air"
    },
    {
      "question": "Can CoVID-19 be caught from a person who has no symptoms?",
      "answer":
          "The main way the disease spreads is through respiratory droplets expelled by someone who is coughing. The risk of catching COVID-19 from someone with no symptoms at all is very low. However, many people with COVID-19 experience only mild symptoms. This is particularly true at the early stages of the disease. It is therefore possible to catch COVID-19 from someone who has, for example, just a mild cough and does not feel ill.  WHO is assessing ongoing research on the period of transmission of COVID-19 and will continue to share updated findings.    "
    },
    {
      "question":
          "Can I catch COVID-19 from the feces of someone with the disease?",
      "answer":
          "The risk of catching COVID-19 from the feces of an infected person appears to be low. While initial investigations suggest the virus may be present in feces in some cases, spread through this route is not a main feature of the outbreak. WHO is assessing ongoing research on the ways COVID-19 is spread and will continue to share new findings. Because this is a risk, however, it is another reason to clean hands regularly, after using the bathroom and before eating."
    },
    {
      "question": "How likely am I to catch COVID-19?",
      "answer":
          "The risk depends on where you  are - and more specifically, whether there is a COVID-19 outbreak unfolding there.\nFor most people in most locations the risk of catching COVID-19 is still low. However, there are now places around the world (cities or areas) where the disease is spreading. For people living in, or visiting, these areas the risk of catching COVID-19 is higher. Governments and health authorities are taking vigorous action every time a new case of COVID-19 is identified. Be sure to comply with any local restrictions on travel, movement or large gatherings. Cooperating with disease control efforts will reduce your risk of catching or spreading COVID-19.\nCOVID-19 outbreaks can be contained and transmission stopped, as has been shown in China and some other countries. Unfortunately, new outbreaks can emerge rapidly. It’s important to be aware of the situation where you are or intend to go. WHO publishes daily updates on the COVID-19 situation worldwide."
    },
    {
      "question": "Who is at risk of developing severe illness?",
      "answer":
          "While we are still learning about how COVID-2019 affects people, older persons and persons with pre-existing medical conditions (such as high blood pressure, heart disease, lung disease, cancer or diabetes)  appear to develop serious illness more often than others. "
    },
    {
      "question": "Should I wear a mask to protect myself?",
      "answer":
          "Only wear a mask if you are ill with COVID-19 symptoms (especially coughing) or looking after someone who may have COVID-19. Disposable face mask can only be used once. If you are not ill or looking after someone who is ill then you are wasting a mask. There is a world-wide shortage of masks, so WHO urges people to use masks wisely.\nWHO advises rational use of medical masks to avoid unnecessary wastage of precious resources and mis-use of masks\nThe most effective ways to protect yourself and others against COVID-19 are to frequently clean your hands, cover your cough with the bend of elbow or tissue and maintain a distance of at least 1 meter (3 feet) from people who are coughing or sneezing"
    },
    {
      "question":
          "Are antibiotics effective in preventing or treating the COVID-19?",
      "answer":
          "No. Antibiotics do not work against viruses, they only work on bacterial infections. COVID-19 is caused by a virus, so antibiotics do not work. Antibiotics should not be used as a means of prevention or treatment of COVID-19. They should only be used as directed by a physician to treat a bacterial infection. "
    }
  ];
}
