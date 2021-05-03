import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/settings.dart';
import 'package:vibration/vibration.dart';

// import 'package:wakelock/wakelock.dart';

class JoinPage extends StatefulWidget {
  Map fromMemberData;
  String videoCall = "",entryIdWhileGuestEntry="";
  String unknownVisitorEntryId = "";

  JoinPage({
    this.fromMemberData,
    this.videoCall,this.entryIdWhileGuestEntry,this.unknownVisitorEntryId
  });

  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  static final _users = <int>[];
  bool muted = false;
  AgoraRtmChannel _channel;
  bool completed = false;
  bool accepted = false;
  bool loading = true;

  @override
  void initState() {
    initialize();
    Vibration.cancel();
    super.initState();
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  Future<void> initialize() async {
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data;
    // if(widget.fromMemberData==null){
    //   data = preferences.getString('data');
    // }
    // else{
    if(widget.unknownVisitorEntryId != null){
      data = widget.unknownVisitorEntryId;
    }
    else if(widget.entryIdWhileGuestEntry!=null){
      data = widget.entryIdWhileGuestEntry.toString();
    }else{
      data = widget.fromMemberData["CallingId"].toString();
    }
    // }
    print("data on join page");
    print(data);
    widget.fromMemberData["NotificationType"] == "VoiceCall" || widget.videoCall=="false" ? await AgoraRtcEngine.disableVideo() : null;
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(null, data, null, 0).then((value) {
      log("after join $value");
      setState(() {
        loading = false;
      });
    }, onError: (error) {
      log("ss => $error");
    });
  }

  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    widget.fromMemberData["NotificationType"] == "VoiceCall" ? await AgoraRtcEngine.disableVideo():await AgoraRtcEngine.enableVideo();
  }

  void _addAgoraEventHandlers() {
    // AgoraRtcEngine.onError = (dynamic code) {
    //   print("error-> " + code.toString());
    // };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      log("on join -> $channel");
      print("on join2 -> ${uid.toString}");
    };

    // AgoraRtcEngine.onLeaveChannel = () {
    //   setState(() {
    //     _users.clear();
    //   });
    // };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      print("smit8 ${uid}");
      setState(() {
        _users.add(uid);
      });
      print("smit9 ${uid}");
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        _users.remove(uid);
      });
    };
  }

  List<Widget> _getRenderViews() {
    print("smit 6");
    final List<AgoraRenderWidget> list = [];
    //user.add(widget.channelId);
    _users.forEach((int uid) {
      list.add(AgoraRenderWidget(uid));
    });
    list.add(AgoraRenderWidget(0, local: true, preview: true));
    return list;
  }

  Widget _videoView(view) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            child: view,
          ),
        ),
      ],
    );
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    log("${views.length}");

    switch (views.length) {
      case 1:
        return _videoView(views[0]);
      case 2:
        return Column(
          children: <Widget>[
            Expanded(child: views[0]),
            Divider(
              thickness: 2,
              color: Colors.deepPurple,
            ),
            Expanded(child: views[1]),
            // Expanded(child: views[0]),
            // Expanded(child: views[1]),
            // _expandedVideoRow([views[0]]),
            // _expandedVideoRow([views[1]])
          ],
        );
        break;
      default:
        return Container();
    }
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () {
              // Navigator.pushReplacementNamed(
              //     context,'/HomeScreen');
              Navigator.pushReplacementNamed(context, '/HomeScreen');
            },
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/HomeScreen');
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    print("widget.memberdata");
    print(widget.fromMemberData);
    return WillPopScope(
      onWillPop: (){
        Navigator.pushReplacementNamed(context, '/HomeScreen');
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('MYJINI'),
        ),
        body: Center(
          child: loading
              ? CircularProgressIndicator()
              : Stack(
                  children: <Widget>[
                    _viewRows(),
                    _toolbar(),
                  ],
                ),
        ),
      ),
    );
  }
}
