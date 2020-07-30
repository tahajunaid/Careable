import 'package:careable/colors.dart';
import 'package:flutter/material.dart';
import 'package:watson_assistant_v2/watson_assistant_v2.dart';

class Watson extends StatefulWidget {
  @override
  _WatsonState createState() => _WatsonState();
}

class _WatsonState extends State<Watson> {
  String _text;
  WatsonAssistantV2Credential credential = WatsonAssistantV2Credential(
    version: '2019-02-28',
    username: 'apikey',
    apikey: 'YOUR API KEY',
    assistantID: 'YOUR ASSISTANT ID',
    url: 'YOUR URL',
  );

  WatsonAssistantApiV2 watsonAssistant;
  WatsonAssistantResponse watsonAssistantResponse;
  WatsonAssistantContext watsonAssistantContext =
      WatsonAssistantContext(context: {});

  TextEditingController myController = TextEditingController();
  bool _uinput = false;
  String _uques;
  void _callWatsonAssistant() async {
    _uinput = true;
    watsonAssistantResponse = await watsonAssistant.sendMessage(
        myController.text, watsonAssistantContext);
    setState(() {
      _text = watsonAssistantResponse.resultText;
      _uques = myController.text;
    });
    watsonAssistantContext = watsonAssistantResponse.context;
    myController.clear();
  }

  @override
  void initState() {
    super.initState();
    watsonAssistant =
        WatsonAssistantApiV2(watsonAssistantCredential: credential);
    _callWatsonAssistant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/fulllogo.png', fit: BoxFit.cover),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: hospgreen,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.restore,
              color: hospgreen,
            ),
            onPressed: () {
              watsonAssistantContext.resetContext();
              setState(() {
                _text = '';
                _uinput = false;
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              cursorColor: hospgreen,
              controller: myController,
              decoration: InputDecoration(
                hintText: 'Ask me something...',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: hospgreen, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: hospgreen, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Visibility(
                visible: _uinput,
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.bottomRight,
                    child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: EdgeInsets.fromLTRB(30, 6, 0, 6),
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Wrap(
                                alignment: WrapAlignment.end,
                                children: <Widget>[
                                  Text(
                                    '$_uques',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  )
                                ]))))),
            Card(
                color: hospgreen,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: EdgeInsets.fromLTRB(0, 6, 30, 6),
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      _text != null ? '$_text' : 'Watson Here...Ask something?',
                      style: TextStyle(fontSize: 20, color: Colors.grey[50]),
                    ))),
            SizedBox(
              height: 24.0,
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: hospgreen,
        onPressed: () {
          FocusScope.of(context).unfocus();
          _callWatsonAssistant();
        },
        child: Icon(Icons.send),
      ),
    );
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }
}
