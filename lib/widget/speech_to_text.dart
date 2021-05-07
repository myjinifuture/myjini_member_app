import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
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

  memberToMemberCalling(bool isVideoCall) async {
    try {
      print("tapped");
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        var data ={
          "societyId": "608fdf9db4cede3cf7558877",
          "callerMemberId": "608fdfcdb4cede3cf75588a3",
          "callerWingId":"608fdf9db4cede3cf7558878", "callerFlatId": "608fdfc1b4cede3cf755889f", "receiverMemberId": "608fe1e9b4cede3cf75588b4", "receiverWingId": "608fdf9db4cede3cf755887a", "receiverFlatId": "608fdfc1b4cede3cf755889f", "contactNo": "9879208321", "AddedBy": "Member", "isVideoCall": true, "callFor": 0, "deviceType": "Android"};

        print("memberToMemberCalling Data = ${data}");
        Services.responseHandler(apiName: "member/memberCalling",body: data).then((data) async {
          if (data.Data.length > 0 && data.IsSuccess == true) {
            SharedPreferences preferences =
            await SharedPreferences.getInstance();
            // await preferences.setString('data', data.Data);
            // await for camera and mic permissions before pushing video page
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => FromMemberScreen(fromMemberData: widget.MemberData,isVideoCall:isVideoCall.toString()),
            //   ),
            // );
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
            if (val.hasConfidenceRating && val.confidence > 0) {
              // _confidence = val.confidence;
              print("_text");
              print(_text);
              // if(val.recognizedWords.contains("video call To Arpit Shah")){
              //   memberToMemberCalling(true);
              //
              // }
              String rubi = val.recognizedWords;
              String ore = "video call To Arpit Shah";
              if(identical(val.recognizedWords,ore)){
                print("true called");
              }
              if(rubi.compareTo(ore) == 0){
                memberToMemberCalling(true);
              }
              print(rubi);
              print(rubi.compareTo(ore));
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