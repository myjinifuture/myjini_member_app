import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Screens/HomeScreen.dart';
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';
import 'package:smart_society_new/Member_App/common/settings.dart';
import 'package:smart_society_new/Member_App/screens/DirectoryScreen.dart';
import 'package:vibration/vibration.dart';
import 'dart:ui' as ui;

import 'Services.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:wakelock/wakelock.dart';

class JoinPage extends StatefulWidget {
  Map fromMemberData;
  String videoCall = "", entryIdWhileGuestEntry = "";
  String unknownVisitorEntryId = "";
  bool unknownEntry,againPreviousScreen;
  bool isAudioCallAccepted;

  JoinPage(
      {this.fromMemberData,
        this.videoCall,
        this.entryIdWhileGuestEntry,
        this.unknownVisitorEntryId,
        this.unknownEntry,
        this.isAudioCallAccepted,
      this.againPreviousScreen
      });

  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  static final _users = <int>[];
  bool muted = false;
  AgoraRtmChannel _channel;
  bool completed = false;
  bool accepted = false;
  bool loading = true;

  @override
  void initState() {
    initialize();
    _getContactPermission();
    Vibration.cancel();
    super.initState();
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.camera);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.camera]);
      return permissionStatus[PermissionGroup.camera] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
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

  var commonId;

  Future<void> initialize() async {
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // await AgoraRtcEngine.enableWebSdkInteroperability(true);
    if (widget.unknownVisitorEntryId != null) {
      commonId = widget.unknownVisitorEntryId;
    } else if (widget.entryIdWhileGuestEntry != null) {
      commonId = widget.entryIdWhileGuestEntry.toString();
    } else {
      commonId = widget.fromMemberData["CallingId"].toString();
    }
    widget.fromMemberData["NotificationType"] == "VoiceCall" ||
        widget.videoCall == "false"
        ? await AgoraRtcEngine.disableVideo()
        : null;
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(null, commonId, null, 0).then((value) {
      setState(() {
        loading = false;
      });
    }, onError: (error) {
      log("ss => $error");
    });
  }

  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    widget.fromMemberData["NotificationType"] == "VoiceCall"
        ? await AgoraRtcEngine.disableVideo()
        : await AgoraRtcEngine.enableVideo();
  }

  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onJoinChannelSuccess = (
        String channel,
        int uid,
        int elapsed,
        ) {
    };

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
          ],
        );
        break;
      default:
        return Container();
    }
  }

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

  onRejectCall() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if(commonId==null){
          Navigator.pushAndRemoveUntil(
              context, SlideLeftRoute(page: HomeScreen()), (route) => false);
        }
        else {
          var body = {
            "callingId": commonId,
            "rejectBy": true
          };
          print("body");
          print(body);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('commonId', commonId);
          Services.responseHandler(apiName: "member/rejectCall", body: body)
              .then(
                  (data) async {
                    if(widget.againPreviousScreen){
                      Navigator.of(context).pop();
                    }
                else if (data.Data.toString() == '1') {
                  print('call declined successfully');
                  AgoraRtcEngine.destroy();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DirecotryScreen(),
                    ),
                  );
                } else {
                  print("else called");
                  AgoraRtcEngine.destroy();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DirecotryScreen(),
                  ),
                  );
                }
              }, onError: (e) {
            showHHMsg("Something Went Wrong Please Try Again", "");
          });
        }
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
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
              onRejectCall();
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

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  ScreenshotController screenshotController = ScreenshotController();
  GlobalKey _globalKey = new GlobalKey();

  Future<void> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
      _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
    } catch (e) {
      print(e);
    }  }

  GlobalKey _containerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    print("widget.memberdata");
    print(widget.fromMemberData);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('MYJINI'),
          leading: Container(),
        ),
        body: RepaintBoundary(
          key: _containerKey,
          child: GestureDetector(
            onDoubleTap: () => _capturePng(),
            child: Screenshot(
              controller : screenshotController,
              child: Center(
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
          ),
        ),
      ),
    );
  }
}
