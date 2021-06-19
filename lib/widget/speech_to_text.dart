import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:smart_society_new/Member_App/screens/fromMemberScreen.dart';

class SpeechToText extends StatefulWidget {
  @override
  _SpeechToTextState createState() => _SpeechToTextState();
}

class _SpeechToTextState extends State<SpeechToText> {

  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Tap the button and start speaking';
  // double _confidence = 1.0;
  VoiceController controller = FlutterTextToSpeech.instance.voiceController();
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    controller.init();
    getLocaldata();
  }

  String SocietyId,MobileNo;

  getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      SocietyId = prefs.getString(Session.SocietyId);
    });
    _getDirectoryListing(SocietyId);
  }

  List memberData= [];
  _getDirectoryListing(String SocietyId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId" : SocietyId
        };
        // setState(() {
        //   isLoading = true;
        // });
        Services.responseHandler(apiName: "admin/directoryListing",body: data).then((data) async {
          memberData.clear();
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              memberData = data.Data;
              // for(int i=0;i<data.Data.length;i++){
              //   if(data.Data[i]["society"]["wingId"] == selectedWing){
              //     memberData.add(data.Data[i]);
              //   }
              // }
              // isLoading = false;
            });
            print("memberData");
            print(memberData);
          } else {
            // setState(() {
            //   isLoading = false;
            // });
          }
        }, onError: (e) {
          showHHMsg("Something Went Wrong Please Try Again","");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.","");
    }
  }

  String selectedWing = "";

  showHHMsg(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

  bool spoke = false;
  speak(String name){
    spoke = true;
    controller.speak("MYJINI"+ "please call to " + "${name}");
  }
  memberToMemberCalling(bool isVideoCall,var dataofMember) async {
    try {
      speak(dataofMember["Name"]);
      print("tapped");
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        var body ={
          "societyId" : prefs.getString(Session.SocietyId),
          "callerMemberId" : prefs.getString(Session.Member_Id),
          "callerWingId" : prefs.getString(Session.WingId),
          "callerFlatId" : prefs.getString(Session.FlatId),
          "receiverMemberId" : dataofMember["_id"].toString(),
          "receiverWingId" : dataofMember["WingData"][0]["_id"].toString(),
          "receiverFlatId" : dataofMember["FlatData"][0]["_id"].toString(),
          "contactNo" : dataofMember["ContactNo"].toString(),
          "AddedBy" : "Member",
          "isVideoCall" : isVideoCall,
          "callFor" : 0,
          "deviceType" : Platform.isAndroid ? "Android" : "IOS"
        };
        print("memberToMemberCalling Data = ${body}");
        Services.responseHandler(apiName: "member/memberCalling",body: body).then((data) async {
          if (data.Data.length > 0 && data.IsSuccess == true && spoke) {
            SharedPreferences preferences =
            await SharedPreferences.getInstance();
            // await preferences.setString('data', data.Data);
            // await for camera and mic permissions before pushing video page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FromMemberScreen(fromMemberData: dataofMember,isVideoCall:isVideoCall.toString()),
              ),
            );
            /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JoinPage(),
                    ),
                  );*/
          } else {

          }
        }, onError: (e) {
          showHHMsg("Try Again.","MyJini");
        });
      } else
        showHHMsg("No Internet Connection.","MyJini");
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.","MyJini");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(
      //     child: 
      //     Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%', 
      //       style: TextStyle(
      //         fontFamily: 'Stolzl',
      //       )
      //     )
      //   ),
      // ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 50.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: TextHighlight(
            text: _text,
            words: _highlights,
            textStyle: const TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w100,
              fontFamily: 'Stolzl'
            ),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            textController.text = _text;
            if (val.hasConfidenceRating && val.confidence > 0) {
              // _confidence = val.confidence;
              // if(val.recognizedWords.contains("video call To Arpit Shah")){
              //   memberToMemberCalling(true);
              //
              // }
              print(_text.length);
              for(int i=0;i<memberData.length;i++){
                print(_text.toUpperCase().trim().replaceAll(" ", ""));
                print(memberData[i]["ContactNo"].toString().toUpperCase());
                if(_text.toUpperCase().
                contains(memberData[i]["Name"].toString().toUpperCase()) ||
                    _text.toUpperCase().trim().replaceAll(" ", "").
                    contains(memberData[i]["ContactNo"].toString().toUpperCase())
                ){
                  print("successfully called");
                  memberToMemberCalling(true,memberData[i]);
                }
                }

              // if(val.recognizedWords == "Arpit Shah"){
              //   memberToMemberCalling(true);
              // }
              // if(identical(val.recognizedWords,ore)){
              //   print("true called");
              // }
              // if(rubi.compareTo(ore).toString() == "1"){
              //   memberToMemberCalling(true);
              // }
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}