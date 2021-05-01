import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'dart:async';

class FromMemberScreen extends StatefulWidget {

  Map fromMemberData = {};
  String rejected="",isVideoCall="";


  FromMemberScreen({this.fromMemberData,this.rejected,this.isVideoCall});

  @override
  _FromMemberScreenState createState() => _FromMemberScreenState();
}

class _FromMemberScreenState extends State<FromMemberScreen> {

  Duration _duration = new Duration();
  Duration _position = new Duration();
  Duration _slider = new Duration(seconds: 0);
  double durationvalue;
  bool issongplaying = false;

  @override
  void initState() {
    super.initState();
    Vibration.cancel();
    print("memberdata");
   /* audioPlayer.durationHandler = (d) => setState(() {
      _duration = d;
    });

    audioPlayer.positionHandler = (p) => setState(() {
      _position = p;
    });*/
    // audioCache.loop('ringing.mp3');   // 2nd tone
    // widget.fromMemberData["Type"] != "Rejected" ?
    // audioCache.loop('ringing.mp3'):null;
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  // Timer _timer;
  // int _start = 0;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    // _timer = new Timer.periodic(
    //   oneSec,
    //       (Timer timer) {
    //     setState(() {
    //       _start++;
    //     });
    //   },
    // );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top:50.0),
            child: new Center(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset('images/applogo.png',
                        width: 90, height: 90),
                    Text("MYJINI",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width*0.05,
                    ),
                    widget.isVideoCall == "true" ? Text("Video Calling....",
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ):Text("Audio Calling....",
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                      widget.fromMemberData["Image"] == null || widget.fromMemberData["Image"] == "" ? new Container(
                        child:  Image.asset('images/applogo.png',
                            width: 90, height: 90),
                          width: MediaQuery.of(context).size.width*0.3,
                          height: MediaQuery.of(context).size.height*0.3,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              // image: new DecorationImage(
                              //     fit: BoxFit.fill,
                              //     image: new NetworkImage(
                              //         "https://i.imgur.com/BoN9kdC.png")
                              // )
                          )):new Container(
                          child:  CircleAvatar(
                            radius: 45.0,
                            backgroundImage: NetworkImage(constant.Image_Url +
                                "${widget.fromMemberData["Image"]}"),
                            backgroundColor: Colors.transparent,
                          ),
                          width: MediaQuery.of(context).size.width*0.3,
                          height: MediaQuery.of(context).size.height*0.3,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            // image: new DecorationImage(
                            //     fit: BoxFit.fill,
                            //     image: new NetworkImage(
                            //         "https://i.imgur.com/BoN9kdC.png")
                            // )
                          )),
                    widget.rejected == "rejected" ? Container() : Text(
                      widget.fromMemberData["Name"].toString().toUpperCase(),
                      textScaleFactor: 1.5,
                    ),
                    widget.rejected == "rejected" ? Container() :
                    widget.fromMemberData["NotificationType"] == "VoiceCall" ? Container() : Row( // tell monil to send me flatno and wing name also 18 number
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        new Text(
                          widget.fromMemberData["WingData"][0]["wingName"],
                          textScaleFactor: 1.5,
                        ),
                        new Text(
                          "-",
                          textScaleFactor: 1.5,
                        ),
                        new Text(
                          widget.fromMemberData["FlatData"][0]["flatNo"],
                          textScaleFactor: 1.5,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width*0.15,
                    ),
                    // widget.fromMemberData["NotificationType"] == "VoiceCall" ?
                    // Text(_printDuration(Duration(seconds: _start)) + " sec",
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     color: Colors.purple,
                    //   ),
                    // ) : Container(),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.width*0.15,
                    // ),
                    widget.rejected == "rejected" ? Text("Rejected......",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    )
                        :widget.fromMemberData["NotificationType"] == "VoiceCall" ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right:40.0),
                          child: GestureDetector(
                            onTap: () {
                              // _timer.cancel();
                              // Navigator.of(context).pop();
                            },
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    width: 60.0,
                                    height: 60.0,
                                    decoration: new BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Center(
                                  child:Padding(
                                    padding: const EdgeInsets.all(18.0,
                                    ),
                                    child: Icon(
                                      Icons.call_end,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right:40.0),
                          child: Text("End Call"),
                        ),
                      ],
                    )
                    :
                    Text("Ringing......",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),

                    ),
                  ],
                )),
          )
/*
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 400,
              ),
              new RaisedButton(
                onPressed: () => sendVideoCallStatus("Accepted",
                    widget.fromMemberData["EntryId"],
                    widget.fromMemberData["SocietyId"],
                    widget.fromMemberData["EntryId"],
                    widget.fromMemberData["EntryId"],
                    "Accepted"),
                  */
/*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JoinPage(),
                    ),
                  );*//*

                child: new Text("Accept"),
              ),
              new RaisedButton(

                onPressed: () => sendVideoCallStatus("Rejected",
                  widget.fromMemberData["EntryId"],
                  widget.fromMemberData["SocietyId"],
                  widget.fromMemberData["EntryId"],
                  widget.fromMemberData["EntryId"],
                  "Rejected"),
                child: new Text("Reject"),
              ),
            ],
          ),
        ),
*/
      ),
    );
  }
}
