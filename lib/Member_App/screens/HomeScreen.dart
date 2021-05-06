import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_society_new/Member_App/screens/Events.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:smart_society_new/Member_App/screens/DocumentScreen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:smart_society_new/Admin_App/Screens/Gallary.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:smart_society_new/Member_App/component/NotificationPopup.dart';
import 'package:smart_society_new/Member_App/screens/CustomerProfile.dart';
import 'package:smart_society_new/Member_App/screens/GalleryScreen.dart';
import 'package:smart_society_new/Member_App/screens/getPendingApprovals.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Screens/HomeScreen.dart' as home;
import 'package:smart_society_new/Mall_App/transitions/fade_route.dart';
import 'package:smart_society_new/Member_App/Model/ModelClass.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/common/join.dart';
import 'package:smart_society_new/Member_App/screens/BannerScreen.dart';
import 'package:smart_society_new/Member_App/screens/SOSDailog.dart';
import 'package:vibration/vibration.dart';
import '../screens/SOSpage.dart';
import '../screens/AdDetailPage.dart';
import 'LoginScreen.dart';
import 'NoticeBoard.dart';
import 'Ringing.dart';
import 'SOS.dart';
import 'VerifiedOrNot.dart';
import 'fromMemberScreen.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';

const APP_STORE_URL = 'http://tinyurl.com/wz2aeao';
const PLAY_STORE_URL = 'http://tinyurl.com/wz2aeao';

class HomeScreen extends StatefulWidget {
  GlobalKey<NavigatorState> navigatorKey;
  bool isAppOpenedAfterNotification;

  HomeScreen({this.navigatorKey, this.isAppOpenedAfterNotification});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool _isInForeground;
  AppLifecycleState _notification;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
    print("_isInForeground during didchangeapplifecycle");
    initOneSignalNotification(_isInForeground);
    // print(_isInForeground);
    switch (state) {
      case AppLifecycleState.paused:
        print('paused');
        break;
      case AppLifecycleState.inactive:
        print('inactive');
        break;
      case AppLifecycleState.resumed:
        print('resumed');
        break;
      case AppLifecycleState.detached:
        print('detached');
        break;
    }
  }

  GlobalKey<NavigatorState> navigatorKey;

  bool isFCMtokenLoading = false;

  @override
  bool get wantKeepAlive => true;


  // FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  StreamSubscription iosSubscription;
  String fcmToken = "";
  String searchedText = "";
  String SocietyId,
      Name,
      Wing,
      FlatNo,
      Profile,
      ContactNo,
      Address,
      ResidenceType,
      BloodGroup,
      mapLink;

  String serviceReqId;

  List ReviewList = [];

  final List<Menu> _allMenuList = Menu.allMenuItems();

  bool dialVisible = true;
  int _current = 0;

  List _advertisementData = [];
  bool isLoading = true;
  List _addData = [];
  ProgressDialog pr;

  double serviceRating;

  TextEditingController resultText = new TextEditingController();
  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  TextEditingController txtdescription = new TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool isButtonPressed = false;

//onesignal function for notifications
  Future<void> initOneSignalNotification(bool isInForeground) async {
    OneSignal.shared.setNotificationOpenedHandler(
            (OSNotificationOpenedResult result) async {
          isButtonPressed = true;
          print("Opened notification");
          print(result.notification.jsonRepresentation().replaceAll("\\n", "\n"));
          print(result.notification.payload.additionalData);
          dynamic data = result.notification.payload.additionalData;
          print("data came from notification 123");
          print(data);
          print("value of _isinforeground");
          Vibration.vibrate(
            duration: 1500,
          );
          if (data["notificationType"].toString() == "AddEvent") {
            Get.to(() => Events());
          }
          if (data["notificationType"].toString() == "JoinSociety") {
            Get.to(() => getPendingApprovals());
          }
          else if (data["notificationType"].toString() == "RevokeAdminRole") {
            Get.to(() => LoginScreen());
          }
          else if (data["notificationType"].toString() == "AssignAdminRole") {
            Get.to(() => LoginScreen());
          }
          else if (data["notificationType"].toString() == "AddDocument") {
            Get.to(() => DocumentScreen());

          }
          else if (data["notificationType"].toString() == "AddGallery") {
            Get.to(() => GalleryScreen());
          }
          else if (data["notificationType"].toString() == "StaffEntry" ||
              data["notificationType"].toString() == "StaffLeave") {
            Get.to(() => NoticeBoard(message: data));

          }
          else if (data["notificationType"] == 'Visitor') {
            Get.to(() => NotificationPopup(data,unknownEntry: true,));
          }
          else if (data["notificationType"] == 'SendComplainToAdmin') {
            Get.to(() => NotificationPopup(data,unknownEntry : false));
          }
          else if (data["NotificationType"] == "SOS") {
            Get.to(() => SOS(data,
              body: result.notification.payload.body,));
            //for vibration
          } else if (data["CallResponseIs"] == "Accepted" &&
              data["NotificationType"] == "VideoCalling") {
            print('data');
            print(data);
            Get.to(() => JoinPage(
              unknownEntry: false,
                fromMemberData:
                result.notification.payload.additionalData));
          } else if (data["CallResponseIs"] == "Accepted" &&
              data["NotificationType"] == "VoiceCall") {
            print('data');
            print(data);
            Get.to(() => JoinPage(
                unknownEntry: false,
                fromMemberData:
                result.notification.payload.additionalData));
          } else if (data["CallResponseIs"] == "Rejected" &&
              data["NotificationType"] == "VideoCalling") {
            print('data');
            print(data);
            Get.to(() => FromMemberScreen(
                fromMemberData: result.notification.payload.additionalData,
                rejected: "rejected"));
          } else if (data["CallResponseIs"] == "Rejected" &&
              data["NotificationType"] == "VoiceCall") {
            print('data');
            print(data);
            Get.to(() => FromMemberScreen(
                fromMemberData: result.notification.payload.additionalData,
                rejected: "rejected"));
          } else if (data["NotificationType"] == "VideoCalling") {
            print('data');
            print(data);
            Get.to(() => Ringing(
              fromMemberData: result.notification.payload.additionalData,
            ),);

          } else if (data["notificationType"] == "UnknownVisitor" && data["CallStatus"] == "Accepted") {
            print('data');
            print(data);
            Get.to(() => JoinPage(
                unknownEntry: false,
                fromMemberData:
                result.notification.payload.additionalData),);
          }
          else if (data["notificationType"] == "UnknownVisitor") {
            print('data');
            print(data);
            Get.to(() => Ringing(
                fromMemberData: result.notification.payload.additionalData),);
          }
          else if (data["NotificationType"] == "VoiceCall") {
            print('data');
            print(data);
            Get.to(() => Ringing(
                fromMemberData: result.notification.payload.additionalData),);
          }
        });
  }

  changePreferenceAgain() async {
    print("changepreferenceagain called successfully");
    setState(() {
      // _isInForeground = !_isInForeground;
    });
  }

  @override
  Future<void> initState() {
    super.initState();
    getAdvertisementData();
    AppLifecycleState state;
    didChangeAppLifecycleState(state);
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'MYJINI',
    );
    permissionValidator.camera();
    _getLocaldata();
    print("initstate executed");
    // setNotification(context);
    // getApkVersion();
    try {
      versionCheck(context);
    } catch (e) {
      print(e);
    }
    //_getIsReviewed();
    //_showDialog();

    /*if (ReviewList.length > 0) {
      return _showDialog();
    }*/
    getSocietyDetails();
    // initPlayer();
    // getAdvertisementData(); //Tell monil to give Advertisement service - 1 number
    // getAds();
    // initSpeechRecognizer();
    // if (Platform.isIOS) {
    //   iosSubscription =
    //       _firebaseMessaging.onIosSettingsRegistered.listen((data) {
    //     print("FFFFFFFF" + data.toString());
    //     saveDeviceToken();
    //   });
    //   _firebaseMessaging
    //       .requestNotificationPermissions(IosNotificationSettings());
    // } else {
    //   saveDeviceToken();
    // }
  }

  setForegroundValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("sharedpresence value during init foreground");
    setState(() {
      // _isInForeground = prefs.getBool(Session.isInForeground.toString());
    });
    print(prefs.getBool(Session.isInForeground.toString()));
  }

  String Title;
  String bodymessage;

  showNotification(String title, String body) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.high, importance: Importance.max, playSound: false);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(0, '$title', '$body', platform);
  }

  // setNotification(BuildContext context) async {
  //   //_messaging.getToken().then((token) {});
  //   _firebaseMessaging.configure(
  //     //when app is open
  //     onMessage: (Map<String, dynamic> message) async {
  //       // Get.to(NotificationPopup(message));
  //       print("onMessage:---- $message------------------------");
  //       if (Platform.isAndroid) {
  //         Title = message["notification"]["title"];
  //         bodymessage = message["notification"]["body"];
  //         print("message");
  //         print(message["notification"]);
  //         print(message["notification"]["NotificationType"]);
  //         print(message["notification"]["title"]);
  //         print(message["notification"]["body"]);
  //         print(message["notification"]["NotificationType"]);
  //         if (message["data"]["notificationType"].toString() == "AddEvent") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "NoticeBoard") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "NewAmenity") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "AddGallery") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "AddStaff") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "StaffEntry") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["NotificationType"].toString() ==
  //             "MemberVerify") {
  //           print('message');
  //           print(message);
  //           Get.to(VerifiedOrNot(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "SendComplainToAdmin") {
  //           print('message');
  //           print(message);
  //           Get.to(NotificationPopup(
  //             message,
  //           ));
  //           // audioCache.play('notification.mp3');
  //           //for vibration
  //           Vibration.vibrate(
  //             duration: 5000,
  //           );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "UnknownVisitor") {
  //           print('message');
  //           print(message);
  //           // Get.to(NotificationPopup(message));
  //           Get.to(
  //             Ringing(fromMemberData: message["data"]),
  //           );
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           Vibration.vibrate(
  //             duration: 15000,
  //           );
  //         } else if (message["data"]["CallResponseIs"] == "Accepted") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           // Get.to(FromMemberScreen(
  //           //     fromMemberData: message["data"]));
  //           Get.to(JoinPage(fromMemberData: message["data"]));
  //
  //           // audioCache.play('8247_htc_h10.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["CallResponseIs"] == "Rejected") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(FromMemberScreen(
  //               fromMemberData: message["data"], rejected: "rejected"));
  //           // audioCache.play('8247_htc_h10.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["NotificationType"] == "VoiceCall") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(
  //             Ringing(fromMemberData: message["data"]),
  //           );
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["notification"]["title"]
  //                 .toString()
  //                 .split(" ")[0] ==
  //             "SOS") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(SOS(message));
  //           // audioCache.play('ambulance.mp3');
  //           //for vibration
  //           Vibration.vibrate(
  //             duration: 5000,
  //           );
  //         } else if (message["data"]["NotificationType"] == "VideoCalling") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           // Get.to(
  //           //   Ringing(fromMemberData: message["data"]),
  //           // );
  //
  //           // navigatorKey.currentState.push(
  //           //     MaterialPageRoute(builder: (_) => Ringing(fromMemberData: message["data"]))
  //           // );
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => Ringing(fromMemberData: message["data"]),
  //             ),
  //           );
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["Type"] == "Rejected") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(
  //             FromMemberScreen(
  //               fromMemberData: message["data"],
  //               rejected: "rejected",
  //             ),
  //           );
  //           // audioCache.play('8247_htc_h10.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else {
  //           if (message["data"]["notificationType"] == 'Visitor') {
  //             Get.to(NotificationPopup(message));
  //             // audioCache.play('Sound.mp3');
  //             //for vibration
  //             // Vibration.vibrate(
  //             //   duration: 15000,
  //             // );
  //           } else if (message["data"]["Type"] == "SOS") {
  //             print('message["data"]');
  //             print(message["data"]);
  //             Get.to(SOS(message["data"]));
  //             // audioCache.play('ambulance.mp3');
  //             //for vibration
  //             // Vibration.vibrate(
  //             //   duration: 15000,
  //             // );
  //           } else if (message["data"]["notificationType"] == "StaffEntry" ||
  //               message["data"]["notificationType"] == "StaffLeave") {
  //             print('message["data"]');
  //             print(message["data"]);
  //             Get.to(NoticeBoard(message: message));
  //             // Get.to(SOS(message["data"]));
  //             // audioCache.play('ambulance.mp3');
  //             //for vibration
  //             // Vibration.vibrate(
  //             //   duration: 15000,
  //             // );
  //           } else {
  //             Get.toNamed('/' + message["data"]["Type"]);
  //             showNotification('$Title', '$bodymessage');
  //             // audioCache.play('Sound.mp3');
  //             //..
  //             // Vibration.vibrate(
  //             //   duration: 15000,
  //             // );
  //           }
  //         }
  //       }
  //     },
  //     //when app is closed and user click on notification
  //     onLaunch: (Map<String, dynamic> message) async {
  //       // Get.to(NotificationPopup(message));
  //       print("onMessage:---- $message------------------------");
  //       if (Platform.isAndroid) {
  //         Title = message["notification"]["title"];
  //         bodymessage = message["notification"]["body"];
  //         print("message");
  //         print(message["notification"]);
  //         print(message["notification"]["NotificationType"]);
  //         print(message["notification"]["title"]);
  //         print(message["notification"]["body"]);
  //         print(message["notification"]["NotificationType"]);
  //         if (message["data"]["notificationType"].toString() == "AddEvent") {
  //           print('message');
  //           print(message);
  //           Get.to(
  //             NoticeBoard(
  //               message: message,
  //             ),
  //           );
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "NoticeBoard") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "NewAmenity") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "AddGallery") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "StaffEntry") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["NotificationType"].toString() ==
  //             "MemberVerify") {
  //           print('message');
  //           print(message);
  //           Get.to(VerifiedOrNot(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "SendComplainToAdmin") {
  //           print('message');
  //           print(message);
  //           Get.to(NotificationPopup(
  //             message,
  //           ));
  //           // audioCache.play('notification.mp3');
  //           //for vibration
  //           Vibration.vibrate(
  //             duration: 5000,
  //           );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "UnknownVisitor") {
  //           print('message');
  //           print(message);
  //           Get.to(NotificationPopup(message));
  //           // navigatorKey.currentState.push(
  //           //     MaterialPageRoute(builder: (_) => Ringing(fromMemberData: message["data"]))
  //           // );
  //           // S.SchedulerBinding.instance.addPostFrameCallback((_) {
  //           //   Navigator.of(navigatorKey.currentContext)
  //           //       .push(MaterialPageRoute(
  //           //       builder: (context) => Ringing(fromMemberData: message["data"],
  //           //       ),
  //           //   ),
  //           //   );
  //           // });
  //           // Get.to(
  //           //   Ringing(fromMemberData: message["data"]),
  //           // );
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           Vibration.vibrate(
  //             duration: 15000,
  //           );
  //         } else if (message["data"]["CallResponseIs"] == "Accepted") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           // Get.to(FromMemberScreen(
  //           //     fromMemberData: message["data"]));
  //           Get.to(JoinPage(fromMemberData: message["data"]));
  //
  //           // audioCache.play('8247_htc_h10.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["CallResponseIs"] == "Rejected") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(FromMemberScreen(
  //               fromMemberData: message["data"], rejected: "rejected"));
  //           // audioCache.play('8247_htc_h10.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["NotificationType"] == "VoiceCall") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(
  //             Ringing(fromMemberData: message["data"]),
  //           );
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["notification"]["title"]
  //                 .toString()
  //                 .split(" ")[0] ==
  //             "SOS") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(SOS(message));
  //           //for vibration
  //           Vibration.vibrate(
  //             duration: 5000,
  //           );
  //         } else if (message["data"]["NotificationType"] == "VideoCalling") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           // Get.to(
  //           //   Ringing(fromMemberData: message["data"]),
  //           // );
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => Ringing(fromMemberData: message["data"]),
  //             ),
  //           );
  //           // navigatorKey.currentState.push(
  //           //     MaterialPageRoute(builder: (_) => Ringing(fromMemberData: message["data"]))
  //           // );
  //           // Navigator.push(
  //           //   context,
  //           //   MaterialPageRoute(
  //           //     builder: (context) => Ringing(fromMemberData: message["data"]),
  //           //   ),
  //           // );
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["Type"] == "Rejected") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(
  //             FromMemberScreen(
  //               fromMemberData: message["data"],
  //               rejected: "rejected",
  //             ),
  //           );
  //           // audioCache.play('8247_htc_h10.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else {
  //           if (message["data"]["notificationType"] == 'Visitor') {
  //             Get.to(NotificationPopup(message));
  //             // audioCache.play('Sound.mp3');
  //             //for vibration
  //             // Vibration.vibrate(
  //             //   duration: 15000,
  //             // );
  //           } else if (message["data"]["Type"] == "SOS") {
  //             print('message["data"]');
  //             print(message["data"]);
  //             Get.to(SOS(message["data"]));
  //             // audioCache.play('ambulance.mp3');
  //             //for vibration
  //             // Vibration.vibrate(
  //             //   duration: 15000,
  //             // );
  //           } else if (message["data"]["notificationType"] == "StaffEntry" ||
  //               message["data"]["notificationType"] == "StaffLeave") {
  //             print('message["data"]');
  //             print(message["data"]);
  //             Get.to(NoticeBoard(message: message));
  //             // Get.to(SOS(message["data"]));
  //             // audioCache.play('ambulance.mp3');
  //             //for vibration
  //             // Vibration.vibrate(
  //             //   duration: 15000,
  //             // );
  //           } else {
  //             Get.toNamed('/' + message["data"]["Type"]);
  //             showNotification('$Title', '$bodymessage');
  //             // audioCache.play('Sound.mp3');
  //             //..
  //             // Vibration.vibrate(
  //             //   duration: 15000,
  //             // );
  //           }
  //         }
  //       }
  //     },
  //     //when app is in background and user click on notification
  //     onResume: (Map<String, dynamic> message) async {
  //       // Get.to(NotificationPopup(message));
  //       print("onMessage:---- $message------------------------");
  //       if (Platform.isAndroid) {
  //         Title = message["notification"]["title"];
  //         bodymessage = message["notification"]["body"];
  //         print("message");
  //         print(message["notification"]);
  //         print(message["notification"]["NotificationType"]);
  //         print(message["notification"]["title"]);
  //         print(message["notification"]["body"]);
  //         print(message["notification"]["NotificationType"]);
  //         if (message["data"]["notificationType"].toString() == "AddEvent") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "NoticeBoard") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "NewAmenity") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "AddGallery") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "StaffEntry") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["NotificationType"].toString() ==
  //             "MemberVerify") {
  //           print('message');
  //           print(message);
  //           Get.to(VerifiedOrNot(message: message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "SendComplainToAdmin") {
  //           print('message');
  //           print(message);
  //           Get.to(NotificationPopup(
  //             message,
  //           ));
  //           //for vibration
  //           Vibration.vibrate(
  //             duration: 5000,
  //           );
  //         } else if (message["data"]["notificationType"].toString() ==
  //             "UnknownVisitor") {
  //           print('message');
  //           print(message);
  //           // Get.to(NotificationPopup(message));
  //           Get.to(
  //             Ringing(fromMemberData: message["data"]),
  //           );
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           Vibration.vibrate(
  //             duration: 15000,
  //           );
  //         } else if (message["data"]["CallResponseIs"] == "Accepted") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           // Get.to(FromMemberScreen(
  //           //     fromMemberData: message["data"]));
  //           Get.to(JoinPage(fromMemberData: message["data"]));
  //
  //           // audioCache.play('8247_htc_h10.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["CallResponseIs"] == "Rejected") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(FromMemberScreen(
  //               fromMemberData: message["data"], rejected: "rejected"));
  //           // audioCache.play('8247_htc_h10.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["NotificationType"] == "VoiceCall") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(
  //             Ringing(fromMemberData: message["data"]),
  //           );
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["notification"]["title"]
  //                 .toString()
  //                 .split(" ")[0] ==
  //             "SOS") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(SOS(message));
  //           //for vibration
  //           Vibration.vibrate(
  //             duration: 5000,
  //           );
  //         } else if (message["data"]["NotificationType"] == "VideoCalling") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           // Get.to(
  //           //   Ringing(fromMemberData: message["data"],isVideoCallingInBackground : true),
  //           // );
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => Ringing(fromMemberData: message["data"]),
  //             ),
  //           );
  //           // navigatorKey.currentState.push(
  //           //     MaterialPageRoute(builder: (_) => Ringing(fromMemberData: message["data"]))
  //           // );
  //
  //           // Navigator.push(
  //           //   context,
  //           //   MaterialPageRoute(
  //           //     builder: (context) => Ringing(fromMemberData: message["data"]),
  //           //   ),
  //           // );
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["data"]["Type"] == "Rejected") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(
  //             FromMemberScreen(
  //               fromMemberData: message["data"],
  //               rejected: "rejected",
  //             ),
  //           );
  //           // audioCache.play('8247_htc_h10.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else {
  //           if (message["data"]["notificationType"] == 'Visitor') {
  //             Get.to(NotificationPopup(message));
  //             // audioCache.play('Sound.mp3');
  //             //for vibration
  //             // Vibration.vibrate(
  //             //   duration: 15000,
  //             // );
  //           } else if (message["data"]["Type"] == "SOS") {
  //             print('message["data"]');
  //             print(message["data"]);
  //             Get.to(SOS(message["data"]));
  //             // audioCache.play('ambulance.mp3');
  //             //for vibration
  //             // Vibration.vibrate(
  //             //   duration: 15000,
  //             // );
  //           } else if (message["data"]["notificationType"] == "StaffEntry" ||
  //               message["data"]["notificationType"] == "StaffLeave") {
  //             print('message["data"]');
  //             print(message["data"]);
  //             Get.to(NoticeBoard(message: message));
  //             // Get.to(SOS(message["data"]));
  //             // audioCache.play('ambulance.mp3');
  //             //for vibration
  //             // Vibration.vibrate(
  //             //   duration: 15000,
  //             // );
  //           } else {
  //             Get.toNamed('/' + message["data"]["Type"]);
  //             showNotification('$Title', '$bodymessage');
  //             // audioCache.play('Sound.mp3');
  //             //..
  //             // Vibration.vibrate(
  //             //   duration: 15000,
  //             // );
  //           }
  //         }
  //       }
  //     },
  //   );
  //
  //   //For Ios Notification
  //   _firebaseMessaging.requestNotificationPermissions(
  //       const IosNotificationSettings(sound: true, badge: true, alert: true));
  //
  //   _firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings) {
  //     print("Setting reqistered : $settings");
  //   });
  //
  //   flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  //   var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
  //   var iOS = new IOSInitializationSettings();
  //   var initSetttings = new InitializationSettings(android: android, iOS: iOS);
  //   flutterLocalNotificationsPlugin.initialize(initSetttings);
  // }

  versionCheck(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
    double.parse(info.version.trim().replaceAll(".", ""));

    //Get Latest version info from firebase config
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      remoteConfig.getString('force_update_current_version');
      double newVersion = double.parse(remoteConfig
          .getString('force_update_current_version')
          .trim()
          .replaceAll(".", ""));
      print("newversion");
      print(newVersion);
      print("currentVersion");
      print(currentVersion);

      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      }
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  _addServiceReview() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //// pr.show();
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var data = {
          "Id": serviceReqId,
          "Rating": serviceRating,
          "ServiceReview": txtdescription.text,
        };

        print("Save Vendor Data = ${data}");
        Services.AddServiceReview(data).then((data) async {
          //// pr.hide();
          setState(() {
            isLoading = false;
          });

          if (data.Data != "0" && data.IsSuccess == true) {
            /*Fluttertoast.showToast(
                msg: "AMC Paid Successfully !",
                textColor: Colors.black,
                toastLength: Toast.LENGTH_LONG);*/

            showDialog(builder: (context) => Continue(), context: context);

            /*  Navigator.pushNamedAndRemoveUntil(
                context, "/HomeScreen", (Route<dynamic> route) => false);*/
          } else {
            showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          //// pr.hide();
          setState(() {
            isLoading = false;
          });
          showMsg("Try Again.");
        });
      } else
        showMsg("No Internet Connection.");
    } on SocketException catch (_) {
      //// pr.hide();
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  String setDate(String date) {
    String final_date = "";
    var tempDate;
    if (date != "" || date != null) {
      tempDate = date.toString().split("-");
      if (tempDate[2].toString().length == 1) {
        tempDate[2] = "0" + tempDate[2].toString();
      }
      if (tempDate[1].toString().length == 1) {
        tempDate[1] = "0" + tempDate[1].toString();
      }
      final_date = "${tempDate[2].toString().substring(0, 2)}-"
          "${tempDate[1].toString().substring(0, 2)}-${tempDate[0].toString()}"
          .toString();
    }
    return final_date;
  }

  _getIsReviewed() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(constant.Session.Member_Id);
        Future res = Services.GetIsReviewed(id);
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              ReviewList = data;
              serviceReqId = ReviewList[0]["Id"].toString();
              isLoading = false;
            });
            if (ReviewList.length > 0) {
              _showDialog();
            }
            print("gg=> " + ReviewList.toString());
            print("gg=> " + ReviewList.length.toString());
          } else {
            setState(() {
              ReviewList = [];
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on GetAd Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went Wrong!");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _showDialog() async {
    await Future.delayed(Duration(milliseconds: 50));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            // height: MediaQuery.of(context).size.height/1.5,
            child: AlertDialog(
                content: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ReviewList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close))
                            ],
                          ),
                          Center(
                            child: Padding(
                              child: Text(
                                "${ReviewList[index]["VendorName"]}",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 8.0),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  child: Text(
                                    "${ReviewList[index]["ServiceName"]}",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    constant.Inr_Rupee +
                                        " ${ReviewList[index]["ReceivedAmount"]}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            child: Text(
                              "Date - ${setDate(ReviewList[index]["Date"])}",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RatingBar.builder(
                              initialRating: 3.0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 30,
                              itemPadding:
                              EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  serviceRating = rating;
                                });
                                print("hellorating=> " + rating.toString());
                              },
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.trim() == "") {
                                return "Please insert valid reason";
                              }
                            },
                            controller: txtdescription,
                            textInputAction: TextInputAction.next,
                            maxLines: 4,
                            decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  borderSide: new BorderSide(),
                                ),
                                labelText: "Describe your experience",
                                hintStyle: TextStyle(fontSize: 13)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  color: constant.appPrimaryMaterialColor,
                                  textColor: Colors.white,
                                  splashColor: Colors.white,
                                  child: Text("SUBMIT",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                  onPressed: () {
                                    _addServiceReview();

                                    /* if (_formkey.currentState.validate()) {
                                      // Registration();
                                      showDialog(
                                          context: context, child: Continue());
                                      Fluttertoast.showToast(
                                          msg: "Review Submitted !!",
                                          textColor: Colors.black,
                                          backgroundColor: Colors.red,
                                          toastLength: Toast.LENGTH_LONG);
                                      Navigator.pop(context);
                                    }*/

                                    //Navigator.pop(context);
                                  }),
                            ),
                          ),
                        ],
                      );
                    })),
          );
        });
  }

  getAdvertisementData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          // "societyId": SocietyId,
        };

        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "member/getAdvertisement", body: data)
            .then((data) async {
          print("data");
          print(data.Data);
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              _advertisementData = data.Data;
              isLoading = false;
            });
            print("_advertisementData");
            print(_advertisementData);
          } else {
            setState(() {
              isLoading = false;
              // _advertisementData = data.Data;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  bool isAdmin = false;

  updateMemberPlayerId(String memberId, String mobileNo, String playerId,
      String IMEI, String isAdmin) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "MobileNo": mobileNo,
          "playerId": playerId,
          "DeviceType": Platform.isAndroid ? "Android" : "IOS",
          "IMEI": IMEI,
          "memberId": memberId,
          "isAdmin": isAdmin
        };
        print("data during update");
        print(data);
        Services.responseHandler(
            apiName: "member/updateMemberPlayerId", body: data)
            .then((data) async {
          print("data");
          print(data);
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  getMemberRole(String memberId, String societyId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {"memberId": memberId, "societyId": societyId};
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "member/getMemberRole", body: data)
            .then((data) async {
          print("memberrole data");
          print(data.Data);
          if (data.Data[0]["society"]["isAdmin"].toString() == "1") {
            setState(() {
              Profile = data.Data[0]["Image"];
              isAdmin = true;
              isLoading = false;
            });
          } else {
            setState(() {
              Profile = data.Data[0]["Image"];
              isLoading = false;
              // _advertisementData = data;
            });
          }
          if (isAdmin) {
            updateMemberPlayerId(memberId, ContactNo, playerId, uniqueId, "1");
          } else {
            updateMemberPlayerId(memberId, ContactNo, playerId, uniqueId, "0");
          }
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () => launch(APP_STORE_URL),
            ),
            FlatButton(
              child: Text(btnLabelCancel),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        )
            : new AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () => launch(PLAY_STORE_URL),
            ),
            FlatButton(
              child: Text(btnLabelCancel),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  List banners = [];

  getBanner() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "admin/getBanner", body: {}).then(
                (data) async {
              if (data.Data != null && data.Data.length > 0) {
                setState(() {
                  banners = data.Data;
                  isLoading = false;
                });
              } else {
                setState(() {
                  isLoading = false;
                  banners = data.Data;
                });
              }
            }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  getAds() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetAds();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _addData = data;
              isLoading = false;
            });
            print("Meherzan : " + _addData.toString());
          } else {
            setState(() {
              isLoading = false;
              _addData = data;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg, {String title = 'MYJINI'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

/*
  _showProfileUpdateDailog(String pr) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: <Widget>[
              Image.asset(
                "images/profile_update.png",
                width: 60,
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  "Hello, $Name",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          titlePadding: EdgeInsets.only(top: 10),
          content: Text(
            "Your Profile Is ${100 - int.parse(pr)}% completed.\nPlease Complete Your Profile To Get Better Experience",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          actions: <Widget>[
            MaterialButton(
              minWidth: 100,
              child: Text(
                "Update",
                style: TextStyle(color: Colors.white),
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
              color: constant.appPrimaryMaterialColor,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5)),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/MyProfile');
              },
            ),
            MaterialButton(
              minWidth: 100,
              child: Text(
                "Not Now",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.grey[600],
              padding: EdgeInsets.only(left: 10, right: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
*/

  Widget _getMenuItem(BuildContext context, int index) {
    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 375),
      columnCount: 4,
      child: SlideAnimation(
        child: ScaleAnimation(
          child: GestureDetector(
            onTap: () {
              if (_allMenuList[index].IconName == "Bills" ||
                  _allMenuList[index].IconName == "Reminders") {
                Fluttertoast.showToast(
                    msg: "Coming Soon!!!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
              // else if (_allMenuList[index].IconName == "Polling") {
              //   Fluttertoast.showToast(
              //       msg: "Coming Soon!!!",
              //       toastLength: Toast.LENGTH_SHORT,
              //       gravity: ToastGravity.BOTTOM,
              //       backgroundColor: Colors.red,
              //       textColor: Colors.white,
              //       fontSize: 16.0);
              // }
              else {
                Navigator.pushNamed(
                    context, '/${_allMenuList[index].IconName}');
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  //  bottom: BorderSide(width: ,color: Colors.black54),
                    top: BorderSide(width: 0.1, color: Colors.black)),
              ),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(width: 0.2, color: Colors.grey[600]),
                    )),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "images/" + _allMenuList[index].Icon,
                        width: 25,
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          _allMenuList[index].IconLabel,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("MYJINI"),
          content: new Text("Are You Sure You Want To Exit?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();;
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();;
                _logoutFunction();
              },
            ),
          ],
        );
      },
    );
  }

  var playerId;

  void _handleSendNotification() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    playerId = status.subscriptionStatus.userId;
    print("playerid while logout");
    print(playerId);
    initPlatformState();
  }

  String uniqueId = "Unknown";

  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   platformImei =
    //   await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
    //   List<String> multiImei = await ImeiPlugin.getImeiMulti();
    //   print(multiImei);
    //   idunique = await ImeiPlugin.getId();
    // } on PlatformException {
    //   platformImei = 'Failed to get platform version.';
    // }
    String identifier = await UniqueIdentifier.serial;
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      uniqueId = identifier;
    });
    print("uniqueid");
    print(identifier);
    getMemberRole(memberId, SocietyId);
  }

  _logoutFunction() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "memberId": memberId,
          "playerId": playerId,
          "IMEI": uniqueId
        };
        print("data");
        print(data);
        Services.responseHandler(apiName: "member/logout", body: data).then(
                (data) async {
              if (data.Data != null && data.Data.toString() == "1") {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.pushReplacementNamed(context, "/LoginScreen");
              } else {
                // setState(() {});
              }
            }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
          setState(() {});
        });
      } else {
        showMsg("No Internet Connection.");
        setState(() {});
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
      setState(() {});
    }
  }

  String memberId = "";

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      SocietyId = prefs.getString(constant.Session.SocietyId);
      Name = prefs.getString(constant.Session.Name);
      Wing = prefs.getString(constant.Session.Wing).toUpperCase();
      FlatNo = prefs.getString(constant.Session.FlatNo).toUpperCase();
      memberId = prefs.getString(constant.Session.Member_Id);
      // Profile = prefs.getString(constant.Session.Profile);
      ContactNo = prefs.getString(constant.Session.session_login);
      Address = prefs.getString(constant.Session.Address);
      ResidenceType = prefs.getString(constant.Session.ResidenceType);
      mapLink = prefs.getString(constant.Session.mapLink);
    });
    _handleSendNotification();
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press Back Again to Exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  saveDeviceToken() async {
    // _firebaseMessaging.getToken().then((String token) {
    //   print("Original Token:$token");
    //   var tokendata = token.split(':');
    //   setState(() {
    //     fcmToken = token;
    //     // sendFCMTokan(token);
    //   });
    //   log(fcmToken);
    //   // _registration();
    // });
  }

  sendFCMTokan(var FcmToken) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var deviceType = Platform.isAndroid ? "Android" : "Ios";
        Future res = Services.SendTokanToServer(FcmToken, deviceType);
        res.then((data) async {}, onError: (e) {
          print("Error : on Login Call");
        });
      }
    } on SocketException catch (_) {}
  }

  Future<void> requestPermission(PermissionGroup permission) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[
      PermissionGroup.microphone
    ];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
    await PermissionHandler().requestPermissions(permissions);

    setState(() {
      print(permissionRequestResult);
      _permissionStatus = permissionRequestResult[permission];
      print(_permissionStatus);
    });
    if (permissionRequestResult[permission] == PermissionStatus.granted) {
      setState(() {
        resultText.text = "";
      });
    } else
      Fluttertoast.showToast(
          msg: "Permission Not Granted",
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT);
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
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

  String societyName = "", societyAddress = "";
  double lat = 0.0, long = 0.0;
  String societyCode;

  // final Shader linearGradient1 = LinearGradient(
  //   colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  // ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  // final Shader linearGradient2 = LinearGradient(
  //   colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  // ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  // final Shader linearGradient3 = LinearGradient(
  //   colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  // ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  // final Shader linearGradient4 = LinearGradient(
  //   colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  // ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  getSocietyDetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      societyCode = prefs.getString(constant.Session.SocietyCode);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {"societyCode": societyCode};
        Services.responseHandler(
            apiName: "member/getSocietyDetails", body: data)
            .then((data) async {
          setState(() {
            isLoading = false;
          });
          // getBanner();
          if (data.Data != null && data.Data.length > 0) {
            societyName = data.Data["Society"][0]["Name"];
            societyAddress = data.Data["Society"][0]["Address"];
            // lat = double.parse(data.Data["Society"][0]["Location"]["lat"].toString()); // lat long are coming null from backend
            // long = double.parse(data.Data["Society"][0]["Location"]["long"].toString()); // ask monil for latitude and longitude

          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showHHMsg("Try Again.", "");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("Profile Data:");
    // print(Profile);
    // print("banners data:");
    // print(banners);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MYJINI",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: <Widget>[
          // FGBGNotifier(
          //   onEvent: (event) {
          //     print(event); // FGBGType.foreground or FGBGType.background
          //   },
          //   child: Text("event"),
          // ),
          // Text(_isInForeground.toString()),
          IconButton(
            icon: isAdmin
                ? Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Icon(
                Icons.share,
              ),
            )
                : Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Icon(
                Icons.share,
              ),
            ),
            onPressed: () {
              print("maplink :");
              print(mapLink);
              Share.share(
                  "Society Name : $societyName\nAddress : $societyAddress\nGoogle map link : '$mapLink'");
            },
          ),
          // GestureDetector(
          //   onTap: onJoin,
          //   child: Column(
          //     children: <Widget>[
          //       Padding(
          //         padding: const EdgeInsets.only(top: 9.0, right: 2.0),
          //         child: Image.asset(
          //           'images/video_call.png',
          //           width: 23,
          //           height: 23,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          isAdmin
              ? IconButton(
              icon: Padding(
                padding: EdgeInsets.only(left: 13.0),
                child: Icon(Icons.add_to_home_screen),
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/Dashboard");
              })
              : Container(),
          IconButton(
            iconSize: 30,
            icon: Image.asset(
              'images/bloodplasma.png',
              fit: BoxFit.fill,
            ),
            onPressed: () {
              // Navigator.pushNamed(context, '/BloodPlasma');
              Fluttertoast.showToast(
                  msg: "Coming Soon!!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
        ],
        bottom: PreferredSize(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/GlobalSearch");
              },
              child: Container(
                margin:
                EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 10),
                height: 40,
                padding: EdgeInsets.only(left: 10, right: 10),
                //width: MediaQuery.of(context).size.width - 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      size: 15,
                    ),
                    Padding(padding: EdgeInsets.only(left: 4)),
                    Expanded(
                      child: Text(
                        "Search Member or Services..",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    /*IconButton(
                              icon: Icon(
                                Icons.keyboard_voice,
                                color: constant.appPrimaryMaterialColor,
                              ),
                              onPressed: () {
                                requestPermission(PermissionGroup.microphone);
                              })*/
                  ],
                ),
              ),
            ),
            preferredSize: Size.fromHeight(40.0)),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/MyProfile');
                      },
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(100)),
                                    border: Border.all(
                                        color: Colors.grey, width: 0.4)),
                                width: 76,
                                height: 76,
                              ),
                              ClipOval(
                                child: Profile != "null" && Profile != ""
                                    ? FadeInImage.assetNetwork(
                                  placeholder:
                                  "images/image_loading.gif",
                                  image:
                                  constant.Image_Url + '$Profile',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                )
                                    : Image.asset(
                                  "images/man.png",
                                  width: 70,
                                  height: 70,
                                ),
                              ),
                            ],
                            alignment: Alignment.center,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 40.0),
                                    child: Text("$Name".toUpperCase(),
                                        style: TextStyle(
                                          //color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2, left: 0),
                                    child: Text("$Wing" " - " "$FlatNo"),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'My Visitors',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    leading: Icon(
                      Icons.person_pin,
                      color: constant.appPrimaryMaterialColor,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/MyGuestList");
                    },
                  ),
                  // ListTile(
                  //   title: Text(
                  //     'Manage Promotions',
                  //     style: TextStyle(fontWeight: FontWeight.w600),
                  //   ),
                  //   leading: Icon(
                  //     Icons.assessment,
                  //     color: constant.appPrimaryMaterialColor,
                  //   ),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.pushReplacementNamed(
                  //         context, "/AdvertisementManage");
                  //   },
                  // ),
                  // ListTile(
                  //   title: Text(
                  //     "Society Amenities",
                  //     style: TextStyle(fontWeight: FontWeight.w600),
                  //   ),
                  //   leading: Icon(
                  //     Icons.local_laundry_service,
                  //     color: constant.appPrimaryMaterialColor,
                  //   ),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.pushNamed(context, "/Amenities");
                  //   },
                  // ),
                  // ListTile(
                  //   title: Text(
                  //     'My WishList',
                  //     style: TextStyle(fontWeight: FontWeight.w600),
                  //   ),
                  //   leading: Image.asset(
                  //     "images/wishlist.png",
                  //     width: 20,
                  //     height: 20,
                  //     color: constant.appPrimaryMaterialColor,
                  //   ),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.pushNamed(context, "/MyWishList");
                  //   },
                  // ),
                  // ListTile(
                  //   title: Text(
                  //     'Terms & Conditions',
                  //     style: TextStyle(fontWeight: FontWeight.w600),
                  //   ),
                  //   leading: Icon(
                  //     Icons.priority_high,
                  //     color: constant.appPrimaryMaterialColor,
                  //   ),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.pushNamed(context, "/TermsAndConditions");
                  //   },
                  // ),
                  // ListTile(
                  //   title: Text(
                  //     'Privacy Policy',
                  //     style: TextStyle(fontWeight: FontWeight.w600),
                  //   ),
                  //   leading: Icon(
                  //     Icons.label,
                  //     color: constant.appPrimaryMaterialColor,
                  //   ),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.pushNamed(context, "/PrivacyPolicy");
                  //   },
                  // ),
                  ListTile(
                    title: Text(
                      'Share My Address',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    leading: Icon(
                      Icons.add_to_home_screen,
                      color: constant.appPrimaryMaterialColor,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Share.share(
                          "Hello, My Name is $Name\nI reside At $FlatNo - $Wing\nMap Link: $mapLink\nAddress: $Address\n");
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Contact Us',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    leading: Icon(
                      Icons.perm_contact_calendar,
                      color: constant.appPrimaryMaterialColor,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/ContactUs");
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Logout',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    leading: Icon(
                      Icons.exit_to_app,
                      color: constant.appPrimaryMaterialColor,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showConfirmDialog();
                    },
                  ),

                  //========by rinki
                  // ListTile(
                  //   title: Text(
                  //     'Building Maintenance',
                  //     style: TextStyle(fontWeight: FontWeight.w600),
                  //   ),
                  //   leading: Icon(
                  //     Icons.exit_to_app,
                  //     color: constant.appPrimaryMaterialColor,
                  //   ),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.pushNamed(context, "/JoinCreateBuildingScreen");
                  //   },
                  // ),
                ],
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                children: <Widget>[
                  Divider(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            launch("tel:9023803870");
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset("images/call.png",
                                  height: 24, width: 24),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("Call",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600)),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            launch(
                                "https://www.facebook.com/myjinismartsociety/");
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset("images/facebook.png",
                                  height: 24, width: 24),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("Facebook",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600)),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            launch(
                                "https://www.instagram.com/myjinismartsociety/");
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset("images/instagram.png",
                                  height: 24, width: 24),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("Instagram",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            launch("http://www.myjini.in/");
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset("images/applogo.png",
                                  height: 24, width: 24),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("Website",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
          : Column(
        children: <Widget>[
          _advertisementData.length > 0
              ? GestureDetector(
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => AdDetailPage(
            //         data:i,
            //       ),
            //     ),
            //   );
            // },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                CarouselSlider(
                  viewportFraction: 1.0,
                  height:
                  MediaQuery.of(context).size.height * 0.218,
                  autoPlayAnimationDuration:
                  Duration(milliseconds: 1000),
                  reverse: false,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlay: true,
                  onPageChanged: (index) {
                    setState(() {
                      _current = index;
                    });
                  },
                  items: _advertisementData.map((i) {
                    return Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdDetailPage(
                                      data: i,
                                      index:_current
                                  ),
                                ),
                              );
                            },
                            child: Container(
                                width:
                                MediaQuery.of(context).size.width,
                                child: Image.network(
                                    Image_Url + i["Image"][0],
                                    fit: BoxFit.fill)),
                          );
                        });
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: map<Widget>(
                    _advertisementData,
                        (index, url) {
                      return Container(
                        width: 7.0,
                        height: 7.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(5)),
                            color: _current == index
                                ? Colors.white
                                : Colors.grey),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
              : banners.length == 0
              ? Center(
            child: CircularProgressIndicator(),
          )
              : CarouselSlider(
            height: 160,
            viewportFraction: 1.0,
            autoPlayAnimationDuration:
            Duration(milliseconds: 1000),
            reverse: false,
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlay: true,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            items: banners.map((i) {
              return Builder(builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdDetailPage(
                          data: i,
                        ),
                      ),
                    );
                  },
                  child: Container(
                      width:
                      MediaQuery.of(context).size.width,
                      child: Image.network(
                          Image_Url + i["image"],
                          fit: BoxFit.fill)),
                );
              });
            }).toList(),
          ),
          Padding(padding: EdgeInsets.all(0.0)),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey[500], width: 0.3))),
                    child: AnimationLimiter(
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: _getMenuItem,
                        itemCount: _allMenuList.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio:
                          MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height /
                                  2.3),
                        ),
                      ),
                    ),
                  ),
                  _advertisementData.length > 0
                      ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BannerScreen(
                            bannerData: _advertisementData,
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        _advertisementData.length == 0
                            ? CircularProgressIndicator()
                            : CarouselSlider(
                          height: MediaQuery.of(context)
                              .size
                              .height *
                              0.218,
                          viewportFraction: 1.0,
                          autoPlayAnimationDuration:
                          Duration(milliseconds: 1000),
                          reverse: false,
                          autoPlayCurve:
                          Curves.fastOutSlowIn,
                          autoPlay: true,
                          onPageChanged: (index) {
                            setState(() {
                              _current = index;
                            });
                          },
                          items:
                          _advertisementData.map((i) {
                            return Builder(builder:
                                (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AdDetailPage(
                                            data: i,
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                    width: MediaQuery.of(
                                        context)
                                        .size
                                        .width,
                                    child: Image.network(
                                        Image_Url +
                                            i["Image"][0],
                                        fit: BoxFit.fill)),
                              );
                            });
                          }).toList(),
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: map<Widget>(
                            _advertisementData,
                                (index, url) {
                              return Container(
                                width: 7.0,
                                height: 7.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 2.0),
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(5)),
                                    color: _current == index
                                        ? Colors.white
                                        : Colors.grey),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                      : banners.length == 0
                      ? Center(
                    child: CircularProgressIndicator(),
                  )
                      : CarouselSlider(
                    height: 180,
                    viewportFraction: 1.0,
                    autoPlayAnimationDuration:
                    Duration(milliseconds: 1000),
                    reverse: false,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    autoPlay: true,
                    onPageChanged: (index) {
                      setState(() {
                        _current = index;
                      });
                    },
                    items: banners.map((i) {
                      return Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdDetailPage(
                                          data: i,
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                  width: MediaQuery.of(context)
                                      .size
                                      .width,
                                  child: Image.network(
                                      Image_Url + i["image"],
                                      fit: BoxFit.fill)),
                            );
                          });
                    }).toList(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SOSpage()));
        },
        child: Container(
          height: 60,
          width: 60,
          child: Image.asset(
            "images/SOS.png",
            fit: BoxFit.fill,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        notchMargin: 12,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top:10.0,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      child: Image.asset(
                        "images/home.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    GradientText(
                      text: 'HOME',
                      colors: <Color>[ Color(0xff8921aa),Color(0xffDA44bb),],
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                onTap: () {},
              ),
              GestureDetector(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      child: Image.asset(
                        "images/visitors.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    GradientText(
                      text: 'VISITORS',
                      colors: <Color>[ Color(0xff8921aa),Color(0xffDA44bb),],
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/MyGuestList");
                },
              ),
              SizedBox(
                width: 50,
              ),
              GestureDetector(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      child: Image.asset(
                        "images/maid.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    GradientText(
                      text: 'IN-STAFF',
                      colors: <Color>[ Color(0xff8921aa),Color(0xffDA44bb),],
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/MyStaffScreen');
                  //  Navigator.pushNamed(context, '/Mall');
                  // Navigator.pushReplacement(
                  //     context, FadeRoute(page: home.HomeScreen()));
                },
              ),
              GestureDetector(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      child: Image.asset(
                        "images/homescreenprofile.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    GradientText(
                      text: 'PROFILE',
                      colors: <Color>[ Color(0xff8921aa),Color(0xffDA44bb),],
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // Navigator.pushReplacementNamed(context, '/MyProfile');
                  // Navigator.pushNamed(context, '/CustomerProfile');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerProfile(
                            isAdmin: isAdmin,
                          )));
                },
              ),
            ],
          ),
        ),
        color: Colors.white,
      ),
      // Container(
      //   height: MediaQuery.of(context).size.height * 0.085,
      //   decoration: BoxDecoration(
      //     color: Colors.grey[100],
      //     border: Border(
      //       top: BorderSide(
      //         color: Colors.grey,
      //         width: 0.3,
      //       ),
      //     ),
      //   ),
      //   child: Row(
      //     children: <Widget>[
      //
      //     ],
      //   ),
      // ),
      // floatingActionButton: DraggableFab(
      //   child: SizedBox(
      //     height: 50,
      //     width: 50,
      //     child: FloatingActionButton(
      //       onPressed: () {
      //         // Get.to(OverlayScreen({}));
      //         // showDialog(builder: (context) => SOSDailog(), context: context);
      //         Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => SOSpage()));
      //       },
      //       backgroundColor: Colors.red[200],
      //       child: Container(
      //           decoration: BoxDecoration(
      //               color: Colors.red[400],
      //               borderRadius: BorderRadius.circular(100.0)),
      //           width: 40,
      //           height: 40,
      //           child: Center(
      //               child: Text(
      //             "SOS",
      //             style: TextStyle(
      //                 fontSize: 11,
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.white),
      //           ))),
      //     ),
      //   ),
      // ),
    );
  }

//==================by rinki for mall app registration
//   _registration() async {
//     if (_formkey.currentState.validate()) {
//       try {
//         final result = await InternetAddress.lookup('google.com');
//         if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//           setState(() {
//             isLoading = true;
//           });
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           String CName = prefs.getString(constant.Session.Name);
//           String Cemail = prefs.getString(constant.Session.Email);
//           String Cphone = prefs.getString(constant.Session.session_login);
//           FormData body = FormData.fromMap({
//             "CustomerName": CName,
//             "CustomerEmailId": Cemail,
//             "CustomerPhoneNo": Cphone,
//             "CutomerFCMToken": "${fcmToken}"
//           });
//           serv.Services.postforlist(apiname: 'addCustomer', body: body).then(
//               (responselist) async {
//             if (responselist.length > 0) {
//               saveDataToSession(responselist[0]);
//             } else {
//               Fluttertoast.showToast(msg: " Registration fail");
//             }
//           }, onError: (e) {
//             setState(() {
//               isLoading = false;
//             });
//             print("error on call -> ${e.message}");
//             Fluttertoast.showToast(msg: "something went wrong");
//           });
//         }
//       } on SocketException catch (_) {
//         Fluttertoast.showToast(msg: "No Internet Connection");
//       }
//     } else
//       Fluttertoast.showToast(msg: "Please fill all the fields");
//   }
//
//   saveDataToSession(var data) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString(
//         cnst.Session.customerId, data["CustomerId"].toString());
//     await prefs.setString(cnst.Session.CustomerName, data["CustomerName"]);
//     await prefs.setString(
//         cnst.Session.CustomerEmailId, data["CustomerEmailId"]);
//     await prefs.setString(
//         cnst.Session.CustomerPhoneNo, data["CustomerPhoneNo"]);
//     Navigator.pushAndRemoveUntil(
//         context, SlideLeftRoute(page: HomeScreen()), (route) => false);
//   }
}

class Continue extends StatefulWidget {
  @override
  _ContinueState createState() => _ContinueState();
}

class _ContinueState extends State<Continue> {
  ProgressDialog pr;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image.asset(
                  "images/StarRating.jpg",
                  width: MediaQuery.of(context).size.width,
                  height: 90,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      child: Text(
                        "Thank you for sharing your valuable feedback!",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      padding: const EdgeInsets.all(8.0),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/HomeScreen", (Route<dynamic> route) => false);
                  // Navigator.pop(context);
                },
                child: Center(
                  child: Padding(
                    child: Text(
                      "Done",
                      style: TextStyle(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.justify,
                    ),
                    padding: const EdgeInsets.all(8.0),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
