import 'dart:async';
import 'dart:io' show InternetAddress, Platform, SocketException;

import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' as S;
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Screens/AddAmenitiesScreen.dart';
import 'package:smart_society_new/Admin_App/Screens/AddDocument.dart';
import 'package:smart_society_new/Admin_App/Screens/AddEvent.dart';


//admin App screens
import 'package:smart_society_new/Admin_App/Screens/AddGallary.dart';
import 'package:smart_society_new/Admin_App/Screens/AddNotice.dart';
import 'package:smart_society_new/Admin_App/Screens/AddRules.dart';
import 'package:smart_society_new/Admin_App/Screens/BalanceSheet.dart';
import 'package:smart_society_new/Admin_App/Screens/Complaints.dart';
import 'package:smart_society_new/Admin_App/Screens/Dashboard.dart';
import 'package:smart_society_new/Admin_App/Screens/DirectoryMember.dart';
import 'package:smart_society_new/Admin_App/Screens/Document.dart';
import 'package:smart_society_new/Admin_App/Screens/VendorsAdminScreen.dart';
import 'package:smart_society_new/Admin_App/Screens/EditDocument.dart';
import 'package:smart_society_new/Admin_App/Screens/EventsAdmin.dart';
import 'package:smart_society_new/Admin_App/Screens/Expense.dart';
import 'package:smart_society_new/Admin_App/Screens/ViewGalleryPhotos.dart';
import 'package:smart_society_new/Admin_App/Screens/ExpenseByMonth.dart';
import 'package:smart_society_new/Admin_App/Screens/Gallary.dart';
import 'package:smart_society_new/Admin_App/Screens/Income.dart';
import 'package:smart_society_new/Admin_App/Screens/IncomeByMonth.dart';
import 'package:smart_society_new/Admin_App/Screens/MemberProfile.dart';
import 'package:smart_society_new/Admin_App/Screens/Notice.dart';
import 'package:smart_society_new/Admin_App/Screens/Polling.dart';
import 'package:smart_society_new/Admin_App/Screens/RulesAndRegulations.dart';
import 'package:smart_society_new/Admin_App/Screens/StaffInOut.dart';
import 'package:smart_society_new/Admin_App/Screens/VisitorByWing.dart';
import 'package:smart_society_new/Admin_App/Screens/getAmenitiesScreen.dart';
import 'package:smart_society_new/DigitalScreens/AddCard.dart';
import 'package:smart_society_new/DigitalScreens/AddOffer.dart';
import 'package:smart_society_new/DigitalScreens/AddService.dart';
import 'package:smart_society_new/DigitalScreens/ChangeTheme.dart';
import 'package:smart_society_new/DigitalScreens/DashBoard.dart';
import 'package:smart_society_new/DigitalScreens/EditOffer.dart';
import 'package:smart_society_new/DigitalScreens/EditService.dart';
import 'package:smart_society_new/DigitalScreens/Home.dart';
import 'package:smart_society_new/DigitalScreens/More.dart';
import 'package:smart_society_new/DigitalScreens/OfferDetail.dart';
import 'package:smart_society_new/DigitalScreens/Offers.dart';
import 'package:smart_society_new/DigitalScreens/ProfileDetail.dart';
import 'package:smart_society_new/DigitalScreens/Services.dart';
import 'package:smart_society_new/DigitalScreens/ShareHistory.dart';
import 'package:smart_society_new/IntroScreen.dart';
import 'package:smart_society_new/Member_App/DigitalCard/Screens/RegistrationDC.dart';
import 'package:smart_society_new/Member_App/Mall/Screens/Cart.dart';
import 'package:smart_society_new/Member_App/Mall/Screens/Mall.dart';
import 'package:smart_society_new/Member_App/Services/AdvertisementList.dart';
import 'package:smart_society_new/Member_App/Services/MyServiceRequests.dart';
import 'package:smart_society_new/Member_App/Services/ServicesScreen.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/join.dart';
import 'package:smart_society_new/Member_App/component/NotificationPopup.dart';
import 'package:smart_society_new/Member_App/screens/AddDailyResource.dart';
import 'package:smart_society_new/Member_App/screens/AddFamilyMember.dart';
import 'package:smart_society_new/Member_App/screens/AddGuest.dart';
import 'package:smart_society_new/Member_App/screens/AdvertisementScreen.dart';
import 'package:smart_society_new/Member_App/screens/OffersScreen.dart';
import 'package:smart_society_new/Member_App/screens/OffersListingScreen.dart';
import 'package:smart_society_new/Member_App/screens/ViewOfferScreen.dart';
import 'package:smart_society_new/Member_App/screens/AdvertisementCreate.dart';
import 'package:smart_society_new/Member_App/screens/AdvertisementManage.dart';
import 'package:smart_society_new/Member_App/screens/Amenities.dart';
import 'package:smart_society_new/Member_App/screens/Approval_Pending.dart';
import 'package:smart_society_new/Member_App/screens/BankDetails.dart';
import 'package:smart_society_new/Member_App/screens/BannerScreen.dart';
import 'package:smart_society_new/Member_App/screens/DailyServicesScreen.dart';
import 'package:smart_society_new/Member_App/screens/Bills.dart';
import 'package:smart_society_new/Member_App/screens/BuildingInfo.dart';
import 'package:smart_society_new/Member_App/screens/Committees.dart';
import 'package:smart_society_new/Member_App/screens/ComplaintScreen.dart';
import 'package:smart_society_new/Member_App/screens/ContactList.dart';
import 'package:smart_society_new/Member_App/screens/ContactUs.dart';
import 'package:smart_society_new/Member_App/screens/DailyServicesStaffListing.dart';
import 'package:smart_society_new/Member_App/screens/DailyServicesStaffProfileScreen.dart';
import 'package:smart_society_new/Member_App/screens/StaffReviewListingScreen.dart';
import 'package:smart_society_new/Member_App/screens/RateNowScreen.dart';
import 'package:smart_society_new/Member_App/screens/CreateBuildingScreen.dart';
import 'package:smart_society_new/Member_App/screens/CreateBuildingSlider.dart';
import 'package:smart_society_new/Member_App/screens/CreateSociety.dart';
import 'package:smart_society_new/Member_App/screens/CustomerProfile.dart';
import 'package:smart_society_new/Member_App/screens/DailyHelp.dart';
import 'package:smart_society_new/Member_App/screens/DirectoryScreen.dart';
import 'package:smart_society_new/Member_App/screens/DocumentScreen.dart';
import 'package:smart_society_new/Member_App/screens/EmergencyNumber.dart';
import 'package:smart_society_new/Member_App/screens/EventDetail.dart';
import 'package:smart_society_new/Member_App/screens/Events.dart';
import 'package:smart_society_new/Member_App/screens/FamilyMemberDetail.dart';
import 'package:smart_society_new/Member_App/screens/GalleryScreen.dart';
import 'package:smart_society_new/Member_App/screens/MyStaffScreen.dart';
import 'package:smart_society_new/Member_App/screens/Reminders.dart';
import 'package:smart_society_new/Member_App/screens/AllRemindersScreen.dart';
import 'package:smart_society_new/Member_App/screens/AddReminderScreen.dart';
import 'package:smart_society_new/Member_App/screens/GetPass.dart';
import 'package:smart_society_new/Member_App/screens/GlobalSearchMembers.dart';
import 'package:smart_society_new/Member_App/screens/HomeScreen.dart';
import 'package:smart_society_new/Member_App/screens/JoinCreateBuildingScreen.dart';
import 'package:smart_society_new/Member_App/screens/LoginScreen.dart';
import 'package:smart_society_new/Member_App/screens/MaintainanceScreen.dart';
import 'package:smart_society_new/Member_App/screens/MemberVehicleDetail.dart';
import 'package:smart_society_new/Member_App/screens/MyComplaints.dart';
import 'package:smart_society_new/Member_App/screens/MyGuestList.dart';
import 'package:smart_society_new/Member_App/screens/MyProfile.dart';
import 'package:smart_society_new/Member_App/screens/MySociety.dart';
import 'package:smart_society_new/Member_App/screens/MyWishList.dart';
import 'package:smart_society_new/Member_App/screens/ViewVisitorPopUpImage.dart';
import 'package:smart_society_new/Member_App/screens/NoRouteScreen.dart';
import 'package:smart_society_new/Member_App/screens/NoticeScreen.dart';
import 'package:smart_society_new/Member_App/screens/PollingScreen.dart';
import 'package:smart_society_new/Member_App/screens/PrivacyPolicy.dart';
import 'package:smart_society_new/Member_App/screens/RegisterScreen.dart';
import 'package:smart_society_new/Member_App/screens/SOSpage.dart';
import 'package:smart_society_new/Member_App/screens/BloodPlasma.dart';
import 'package:smart_society_new/Member_App/screens/AddPlasmaDonor.dart';
import 'package:smart_society_new/Member_App/screens/AddMemberSOSContacts.dart';
import 'package:smart_society_new/Member_App/screens/SetupWingScreen.dart';
import 'package:smart_society_new/Member_App/screens/SetupWings.dart';
import 'package:smart_society_new/Member_App/screens/Society_Rules.dart';
import 'package:smart_society_new/Member_App/screens/Splashscreen.dart';
import 'package:smart_society_new/Member_App/screens/Statistics.dart';
import 'package:smart_society_new/Member_App/screens/TermsAndConditions.dart';
import 'package:smart_society_new/Member_App/screens/UpdateProfileScreen.dart';
import 'package:smart_society_new/Member_App/screens/VisitorSuccess.dart';
import 'package:smart_society_new/Member_App/screens/WingDetail.dart';
import 'package:smart_society_new/Member_App/screens/WingFlat.dart';
import 'package:smart_society_new/Member_App/screens/getPendingApprovals.dart';
import 'package:smart_society_new/Member_App/screens/AddStaff.dart';
import 'package:vibration/vibration.dart';
import 'package:smart_society_new/Member_App/screens/BroadcastMessagePopUp.dart';

import 'package:smart_society_new/Member_App/screens/Networking.dart';

import './Member_App/./screens/Ringing.dart';
import './Member_App/screens/SOS.dart';
import 'Admin_App/Screens/AddAMC.dart';
import 'Admin_App/Screens/AddExpense.dart';
import 'Admin_App/Screens/AddIncome.dart';
import 'Admin_App/Screens/AddPolling.dart';
import 'Admin_App/Screens/EditGallery.dart';
import 'Admin_App/Screens/RulesAndRegulations.dart';
import 'Admin_App/Screens/amcList.dart';
import 'AllAdvertisementData.dart';
import 'Mall_App/Providers/CartProvider.dart';
import 'Member_App/common/Services.dart';
import 'Member_App/screens/AddEmergencySocietyWise.dart';
import 'Member_App/screens/DirectoryProfileFamily.dart';
import 'Member_App/screens/DirectoryProfileVehicle.dart';
import 'Member_App/screens/NoticeBoard.dart';
import 'Member_App/screens/VerifiedOrNot.dart';
import 'Member_App/screens/addEmergencyNumberSocietyWise.dart';
import 'Member_App/screens/fromMemberScreen.dart';
import 'Member_App/src/global_bloc.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Platform.isAndroid
      ? OneSignal.shared.init(
          "d48ee1f9-8f00-4208-bb5c-057f7e5fe0dc",
          iOSSettings: {
            OSiOSSettings.autoPrompt: false,
            OSiOSSettings.inAppLaunchUrl: false,
          },
        )
      : OneSignal.shared.init(
          "d48ee1f9-8f00-4208-bb5c-057f7e5fe0dc",
          iOSSettings: {
            OSiOSSettings.autoPrompt: true,
            OSiOSSettings.inAppLaunchUrl: true,
          },
        );
  OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.none);
  runApp(
    // MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(
    //       create: (_) => HomeScreen(),
    //     ),
    //   ],
    //   child:
    MyApp(),
  );
  // );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
    print("notification on main page");
    rejectCall();
    print(_notification);
  }

  String MemberId = "";

  rejectCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MemberId = prefs.getString(cnst.Session.Member_Id);
    onRejectCall();
  }

  onRejectCall() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // if(commonId==null){
        //   Navigator.pushAndRemoveUntil(
        //       context, SlideLeftRoute(page: HomeScreen()), (route) => false);
        // }
        // else {
        var body = {"memberId": MemberId, "watchmanId": ""};
        print("body");
        print(body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Services.responseHandler(
                apiName: "member/rejectCallForMemberWatchman", body: body)
            .then((data) async {
          if (data.Data.toString() == '1') {
            // Navigator.pushReplacementNamed(context, "/HomeScreen");
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => DirecotryScreen(),
            //   ),
            // );
          } else {
            print("else called");
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => DirecotryScreen(),
            // ),
            // );
          }
        }, onError: (e) {
          // showHHMsg("Something Went Wrong Please Try Again", "");
        });
      }
    } on SocketException catch (_) {
      // showHHMsg("No Internet Connection.", "");
    }
  }

  // FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const platform = const MethodChannel('com.myjini_member.app');

  String Title;
  String bodymessage;

  // void initPlayer() {
  //   advancedPlayer = new AudioPlayer();
  //   audioCache = new AudioCache(fixedPlayer: advancedPlayer);
  // }

  GlobalBloc globalBloc;

  @override
  void initState() {
    globalBloc = GlobalBloc();
    WidgetsBinding.instance.addObserver(this);
    // this.initState();
    // initPlayer();
    // setNotification(context);
    debugPrint("main initstate called");
    initOneSignalNotification();
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'Easy Permission Validator',
    );
    permissionValidator.microphone();
    _handleSendNotification();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  var playerId;

  void _handleSendNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    playerId = status.subscriptionStatus.userId;
    print("playerid++++++++");
    prefs.setString(cnst.Session.playId,playerId);
    print("playerid+++++++++++End");
    print(prefs.getString(cnst.Session.playId));

    print(playerId);
  }

  bool isAppOpenedAfterNotification = false;

  Future<void> initOneSignalNotification() async {
    debugPrint("initOneSignalNotification called");
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      // will be called whenever a notification is received
      isAppOpenedAfterNotification = true;
      debugPrint(isAppOpenedAfterNotification.toString());
      print("Received body");
      //print(notification.jsonRepresentation().replaceAll("\\n", "\n"));
      print(notification.payload.body);
      print("Received title");
      //print(notification.jsonRepresentation().replaceAll("\\n", "\n"));
      print(notification.payload.title);
      print("Received sound");
      //print(notification.jsonRepresentation().replaceAll("\\n", "\n"));
      print(notification.payload.sound);
      print("received notification.payload.additionalData");
      print(notification.payload.additionalData);
      print("_notification.toString() on main page");
      print(_notification.toString());
      dynamic data = notification.payload.additionalData;
      print("data came from notification 123");
      print(data);
      print("value of _isinforeground");
      Vibration.vibrate(
        duration: 700,
      );
      if (data["notificationType"].toString() == "AddEvent") {
        Get.to(() => Events());
      } else if (data["NotificationType"].toString() == "CallAlreadyAccepted") {
        Get.to(() => BroadcastMessagePopUp(
              broadcastMessage: data["Message"],
            ));
      } else if (data["NotificationType"].toString() ==
          "BroadcastMessageFromSociety") {
        Get.to(() => BroadcastMessagePopUp(
              broadcastMessage: data["Message"],
            ));
      }
      if (data["notificationType"].toString() == "JoinSociety") {
        Get.to(() => getPendingApprovals());
      } else if (data["notificationType"].toString() == "AddDocument") {
        Get.to(() => DocumentScreen());
      } else if (data["notificationType"].toString() == "AddGallery") {
        Get.to(() => GalleryScreen());
      } else if (data["notificationType"].toString() == "StaffEntry" ||
          data["notificationType"].toString() == "StaffLeave") {
        Get.to(() => NoticeBoard(message: data));
      } else if (data["notificationType"] == 'Visitor') {
        Get.to(() => NotificationPopup(data, unknownEntry: true));
      } else if (data["notificationType"] == 'SendComplainToAdmin') {
        Get.to(() => NotificationPopup(data, unknownEntry: false));
      } else if (data["NotificationType"] == "SOS") {
        Get.to(() => SOS(
              data,
              body: notification.payload.body,
            ));
        //for vibration
      } else if (data["CallResponseIs"] == "Accepted" &&
          data["NotificationType"] == "VideoCalling") {
        print('data');
        print(data);
        Get.to(() => JoinPage(
            unknownEntry: false,
            againPreviousScreen: false,
            fromMemberData: notification.payload.additionalData));
      } else if (data["CallResponseIs"] == "Accepted" &&
          data["NotificationType"] == "VoiceCall") {
        print('data');
        print(data);
        Get.to(() => JoinPage(
            unknownEntry: false,
            againPreviousScreen: false,
            fromMemberData: notification.payload.additionalData));
      } else if (data["CallResponseIs"] == "Rejected" &&
          data["NotificationType"] == "VideoCalling") {
        print('data');
        print(data);
        Get.to(() => FromMemberScreen(
            fromMemberData: notification.payload.additionalData,
            rejected: "rejected"));
      } else if (data["CallResponseIs"] == "Rejected" &&
          data["NotificationType"] == "VoiceCall") {
        print('data');
        print(data);
        Get.to(() => FromMemberScreen(
            fromMemberData: notification.payload.additionalData,
            rejected: "rejected"));
      } else if (data["NotificationType"] == "VideoCalling") {
        print('data');
        print(data);
        Get.to(
          () => Ringing(
            fromMemberData: notification.payload.additionalData,
          ),
        );
      } else if (data["notificationType"] == "UnknownVisitor" &&
          data["CallStatus"] == "Accepted") {
        print('data');
        print(data);
        Get.to(
          () => JoinPage(
              unknownEntry: false,
              againPreviousScreen: false,
              fromMemberData: notification.payload.additionalData),
        );
      } else if (data["notificationType"] == "UnknownVisitor" &&
          data["CallStatus"] == "Rejected") {
        print('data');
        print(data);
        Get.to(() => FromMemberScreen(
            fromMemberData: notification.payload.additionalData,
            rejected: "rejected"));
      } else if (data["notificationType"] == "UnknownVisitor") {
        print('data');
        print(data);
        Get.to(
          () => Ringing(fromMemberData: notification.payload.additionalData),
        );
      } else if (data["NotificationType"] == "RejectVideoCallingBySender") {
        print('data');
        print(data);
        Get.to(
          () => FromMemberScreen(
              fromMemberData: notification.payload.additionalData,
              rejected: "rejected"),
        );
      } else if (data["NotificationType"] == "RejectVideoCallingByReceiver") {
        print('data');
        print(data);
        Get.to(
          () => FromMemberScreen(
              fromMemberData: notification.payload.additionalData,
              rejected: "rejected"),
        );
      } else if (data["NotificationType"] == "RejectVoiceCallBySender") {
        print('data');
        print(data);
        Get.to(
          () => FromMemberScreen(
              fromMemberData: notification.payload.additionalData,
              rejected: "rejected"),
        );
      } else if (data["NotificationType"] == "RejectVoiceCallByReceiver") {
        print('data');
        print(data);
        Get.to(
          () => FromMemberScreen(
              fromMemberData: notification.payload.additionalData,
              rejected: "rejected"),
        );
      } else if (data["NotificationType"] == "VoiceCall") {
        print('data');
        print(data);
        Get.to(
          () => Ringing(fromMemberData: notification.payload.additionalData),
        );
      }
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
      print("PERMISSION STATE CHANGED");
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // will be called whenever the subscription changes
      //(ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
  }

  //  setNotification(BuildContext context) async {
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
  //           Get.to(NoticeBoard(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "NoticeBoard") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "NewAmenity") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "AddGallery") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "AddStaff") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "StaffEntry") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["NotificationType"].toString() == "MemberVerify") {
  //           print('message');
  //           print(message);
  //           Get.to(VerifiedOrNot(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "SendComplainToAdmin") {
  //           print('message');
  //           print(message);
  //           Get.to(NotificationPopup(message,));
  //           // audioCache.play('notification.mp3');
  //           //for vibration
  //           Vibration.vibrate(
  //             duration: 5000,
  //           );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "UnknownVisitor") {
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
  //         }else if (message["data"]["NotificationType"] == "VoiceCall") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(
  //             Ringing(fromMemberData: message["data"]),
  //           );
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["notification"]["title"].toString().split(" ")[0] == "SOS") {
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
  //           Get.to(
  //             Ringing(fromMemberData: message["data"]),
  //           );
  //
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
  //         }
  //         else if (message["data"]["Type"] == "Rejected") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(
  //             FromMemberScreen(
  //               fromMemberData: message["data"], rejected: "rejected",
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
  //           }
  //           else if (message["data"]["notificationType"] == "StaffEntry" || message["data"]["notificationType"] == "StaffLeave") {
  //             print('message["data"]');
  //             print(message["data"]);
  //             Get.to(NoticeBoard(message : message));
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
  //
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
  //           Get.to(NoticeBoard(message : message,),
  //
  //           );
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "NoticeBoard") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "NewAmenity") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "AddGallery") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "StaffEntry") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["NotificationType"].toString() == "MemberVerify") {
  //           print('message');
  //           print(message);
  //           Get.to(VerifiedOrNot(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "SendComplainToAdmin") {
  //           print('message');
  //           print(message);
  //           Get.to(NotificationPopup(message,));
  //           // audioCache.play('notification.mp3');
  //           //for vibration
  //           Vibration.vibrate(
  //             duration: 5000,
  //           );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "UnknownVisitor") {
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
  //         }else if (message["data"]["NotificationType"] == "VoiceCall") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(
  //             Ringing(fromMemberData: message["data"]),
  //           );
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["notification"]["title"].toString().split(" ")[0] == "SOS") {
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
  //           Get.to(
  //             Ringing(fromMemberData: message["data"]),
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
  //         }
  //         else if (message["data"]["Type"] == "Rejected") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(
  //             FromMemberScreen(
  //               fromMemberData: message["data"], rejected: "rejected",
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
  //           }
  //           else if (message["data"]["notificationType"] == "StaffEntry" || message["data"]["notificationType"] == "StaffLeave") {
  //             print('message["data"]');
  //             print(message["data"]);
  //             Get.to(NoticeBoard(message : message));
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
  //
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
  //           Get.to(NoticeBoard(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "NoticeBoard") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "NewAmenity") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "AddGallery") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "StaffEntry") {
  //           print('message');
  //           print(message);
  //           Get.to(NoticeBoard(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["NotificationType"].toString() == "MemberVerify") {
  //           print('message');
  //           print(message);
  //           Get.to(VerifiedOrNot(message : message));
  //           // audioCache.play('Sound.mp3');
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "SendComplainToAdmin") {
  //           print('message');
  //           print(message);
  //           Get.to(NotificationPopup(message,));
  //           //for vibration
  //           Vibration.vibrate(
  //             duration: 5000,
  //           );
  //         }
  //         else if (message["data"]["notificationType"].toString() == "UnknownVisitor") {
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
  //         }else if (message["data"]["NotificationType"] == "VoiceCall") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(
  //             Ringing(fromMemberData: message["data"]),
  //           );
  //           //for vibration
  //           // Vibration.vibrate(
  //           //   duration: 15000,
  //           // );
  //         } else if (message["notification"]["title"].toString().split(" ")[0] == "SOS") {
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
  //           Get.to(
  //             Ringing(fromMemberData: message["data"],isVideoCallingInBackground : true),
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
  //         }
  //         else if (message["data"]["Type"] == "Rejected") {
  //           print('message["data"]');
  //           print(message["data"]);
  //           Get.to(
  //             FromMemberScreen(
  //               fromMemberData: message["data"], rejected: "rejected",
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
  //           }
  //           else if (message["data"]["notificationType"] == "StaffEntry" || message["data"]["notificationType"] == "StaffLeave") {
  //             print('message["data"]');
  //             print(message["data"]);
  //             Get.to(NoticeBoard(message : message));
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
  //
  //     },
  //   );
  //
  //   //For Ios Notification
  //   // _firebaseMessaging.requestNotificationPermissions(
  //   //     const IosNotificationSettings(sound: true, badge: true, alert: true));
  //   //
  //   // _firebaseMessaging.onIosSettingsRegistered
  //   //     .listen((IosNotificationSettings settings) {
  //   //   print("Setting reqistered : $settings");
  //   // });
  //
  //   flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  //   var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
  //   var iOS = new IOSInitializationSettings();
  //   var initSetttings = new InitializationSettings(android: android, iOS: iOS);
  //   flutterLocalNotificationsPlugin.initialize(initSetttings);
  // }

  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>.value(
      value: globalBloc,
      child: MaterialApp(
        navigatorKey: Get.key,
        // navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: "MYJINI",
        initialRoute: '/',
        routes: {
          '/': (context) => Splashscreen(
                isAppOpenedAfterNotification: isAppOpenedAfterNotification,
                navigatorKey: Get.key,
              ),
          '/LoginScreen': (context) => LoginScreen(playerId: playerId,PlayId: playerId,),
          '/GetPass': (context) => GetPass(),
          '/HomeScreen': (context) => HomeScreen(),
          '/getEmergencyNumberSocietyWise': (context) =>
              getEmergencyNumberSocietyWise(),
          '/Notice': (context) => NoticeScreen(),
          '/WaitingScreen': (context) => Approval_admin(),
          '/Complaints': (context) => MyComplaints(),
          '/AllAdvertisements': (context) => AllAdvertisementData(),
          '/AddComplaints': (context) => ComplaintScreen(),
          '/Directory': (context) => DirecotryScreen(),
          '/RegisterScreen': (context) => RegisterScreen(),
          '/MyProfile': (context) => MyProfileScreen(),
          '/Documents': (context) => DocumentScreen(),
          '/Emergency': (context) => EmergencyNumber(),
          '/Gallery': (context) => GalleryScreen(),
          '/Reminders': (context) => Reminders(),
          '/DailyServicesScreen': (context) => DailyServicesScreen(),
          '/DailyServicesStaffListing': (context) =>
              DailyServicesStaffListing(),
          '/DailyServicesStaffProfileScreen': (context) =>
              DailyServicesStaffProfileScreen(),
          '/StaffReviewListingScreen': (context) => StaffReviewListingScreen(),
          '/RateNowScreen': (context) => RateNowScreen(),
          '/EditDocument': (context) => EditDocument(),
          '/AllRemindersScreen': (context) => AllRemindersScreen(),
          '/AddReminderScreen': (context) => AddReminderScreen(),
          '/Advertisements': (context) => Advertisements(),
          '/UpdateProfile': (context) => UpdateProfile(),
          '/AddGuest': (context) => AddGuest(),
          '/AddStaff': (context) => AddStaff(),
          '/MyGuestList': (context) => MyGuestList(),
          '/EditGallery': (context) => EditGallery(),
          '/Rules': (context) => SocietyRules(),
          '/FamilyMemberDetail': (context) => FamilyMemberDetail(),
          '/AddFamily': (context) => AddFamilyMember(),
          '/GetMyVehicle': (context) => GetMyvehicle(),
          '/DirectoryProfileVehicle': (context) => DirectoryProfileVehicle(),
          '/DirectoryProfileFamily': (context) => DirectoryProfileFamily(),
          '/Polling': (context) => PollingScreen(),
          '/ViewGalleryPhotos': (context) => ViewGalleryPhotos(),
          '/Maintainence': (context) => Maintainance(),
          '/OffersScreen': (context) => OffersScreen(),
          '/OffersListingScreen': (context) => OffersListingScreen(),
          '/ViewOfferScreen': (context) => ViewOfferScreen(),
          '/GlobalSearch': (context) => GlobalSearchMembers(),
          '/AdvertisementCreate': (context) => AdvertisementCreate(),
          '/NoticeBoard': (context) => NoticeBoard(),
          '/Vendors': (context) => ServicesScreen(
                initialIndex: 0,
              ),
          '/MyServiceRequests': (context) => MyServiceRequests(),
          '/Advertisement': (context) => AdvertisementList(),
          '/MyWishList': (context) => MyWishList(),
          '/IntroScreen': (context) => IntroScreen(),
          '/VendorsAdminScreen': (context) => VendorsAdminScreen(),
          '/VisitorSuccess': (context) => VisitorSuccess(),
          '/CreateSociety': (context) => CreateSociety(),
          '/SetupWings': (context) => SetupWings(),
          '/WingDetail': (context) => WingDetail(),
          '/ViewVisitorPopUpImage': (context) => ViewVisitorPopUpImage(),
          '/WingFlat': (context) => WingFlat(),
          '/CustomerProfile': (context) => CustomerProfile(),
          '/AddDailyResource': (context) => AddDailyResource(),


          '/AdvertisementManage': (context) => AdvertisementManage(),
          '/ContactList': (context) => ContactList(),
          '/Committee': (context) => Committees(),
          '/Amenities': (context) => Amenities(),
          '/DailyHelp': (context) => DailyHelp(),
          '/Mall': (context) => Mall(),
          '/Cart': (context) => Cart(),
          '/Bills': (context) => Bills(),
          '/TermsAndConditions': (context) => TermsAndConditions(),
          '/PrivacyPolicy': (context) => PrivacyPolicy(),
          '/Statistics': (context) => Statistics(),
          '/ContactUs': (context) => ContactUs(),
          '/MySociety': (context) => MySociety(),
          '/BankDetails': (context) => BankDetails(),
          '/BuildingInfo': (context) => BuildingInfo(),
          '/Events': (context) => Events(),
          '/EventDetail': (context) => EventDetail(),
          '/Networking': (context) => Networking(),

          //---------------- Digital Card  -------------------------------
          '/RegistrationDC': (context) => RegistrationDC(),

          //----------------  Admin App    -----------------------------
          '/Dashboard': (context) => Dashboard(),
          '/AddNotice': (context) => AddNotice(),
          '/AddDocument': (context) => AddDocument(),
          '/DirectoryMember': (context) => DirectoryMember(),
          '/AllNotice': (context) => Notice(),
          '/Document': (context) => Document(),
          '/Visitor': (context) => VisitorByWing(),
          '/Staff': (context) => StaffInOut(),
          '/RulesAndRegulations': (context) => RulesAndRegulations(),
          '/AddRules': (context) => AddRules(),
          '/AllComplaints': (context) => Complaints(),
          '/MemberProfile': (context) => MemberProfile(),
          '/Gallary': (context) => Gallary(),
          '/AddGallary': (context) => AddGallary(),
          '/Income': (context) => Income(),
          '/Expense': (context) => Expense(),
          '/BalanceSheet': (context) => BalanceSheet(),
          '/ExpenseByMonth': (context) => ExpenseByMonth(),
          '/IncomeByMonth': (context) => IncomeByMonth(),
          '/AddIncome': (context) => AddIncome(),
          '/AddExpense': (context) => AddExpense(),
          '/AllPolling': (context) => Polling(),
          '/AddPolling': (context) => AddPolling(),
          '/MyStaffScreen': (context) => MyStaffScreen(),
          '/amcList': (context) => amcList(),
          '/AddAMC': (context) => AddAMC(),
          '/StaffInOut': (context) => StaffInOut(),
          '/EventsAdmin': (context) => EventsAdmin(),
          '/AddEvent': (context) => AddEvent(),
          '/AddMemberSOSContacts': (context) => AddMemberSOSContacts(),
          '/AddAmenitiesScreen': (context) => AddAmenitiesScreen(),
          '/getAmenitiesScreen': (context) => getAmenitiesScreen(),
          '/JoinCreateBuildingScreen': (context) => JoinCreateBuildingScreen(),
          '/CreateBuildingScreen': (context) => CreateBuildingScreen(),
          '/CreateBuildingSlider': (context) => CreateBuildingSlider(),
          '/SetupWingScreen': (context) => SetupWingScreen(),
          '/BannerScreen': (context) => BannerScreen(),
          //===============digital card screen=============
          '/AddCard': (context) => AddCard(),
          '/ChangeTheme': (context) => ChangeTheme(),
          '/DashBoard1': (context) => DashBoard1(),
          '/EditOffer': (context) => EditOffer(),
          '/EditService': (context) => EditService(),
          '/Home': (context) => Home(),
          '/getPendingApprovals': (context) => getPendingApprovals(),
          '/More': (context) => More(),
          '/OfferDetail': (context) => OfferDetail(),
          '/Offers': (context) => Offers(),
          '/MemberServices': (context) => MemberServices(),
          '/ShareHistory': (context) => ShareHistory(),
          '/ProfileDetail': (context) => ProfileDetail(),
          '/AddService': (context) => AddService(),
          '/AddOffer': (context) => AddOffer(),
          '/AddEmergencySocietyWise': (context) => AddEmergencySocietyWise(),
          '/Ringing': (context) => Ringing(),
          '/SOSPage': (context) => SOSpage(),
          '/BloodPlasma': (context) => BloodPlasma(),
          '/AddPlasmaDonor': (context) => AddPlasmaDonor(),
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) => NoRouteScreen(
                  routeName: settings.name,
                )),
        theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: constant.appPrimaryMaterialColor,
        ),
      ),
    );
  }

  showNotification(String title, String body) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.high, importance: Importance.max, playSound: false);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(0, '$title', '$body', platform);
  }
}

class OverlayScreen extends StatefulWidget {
  var data;

  OverlayScreen(this.data);

  @override
  _OverlayScreenState createState() => _OverlayScreenState();
}

class _OverlayScreenState extends State<OverlayScreen> {
  @override
  void initState() {
    print(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(18, 17, 17, 0.8),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Delivery Boy Waiting At Gate",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      )),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    ),
                  ),
                  widget.data["data"]["Image"] == null &&
                          widget.data["data"]["Image"] == ""
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 45.0,
                            backgroundImage: NetworkImage(constant.Image_Url +
                                "${widget.data["data"]["Image"]}"),
                            backgroundColor: Colors.transparent,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'images/user.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                  Column(
                    children: <Widget>[
                      Text(
                        "${widget.data["data"]["Name"]}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.grey[800]),
                      ),
                      Image.network(
                        constant.Image_Url +
                            '${widget.data["data"]["CompanyImage"]}',
                        width: 90,
                        height: 40,
                      )
                    ],
                  ),
                  Text(
                    "${widget.data["data"]["CompanyName"]}",
                    style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: <Widget>[
                              Image.asset('images/success.png',
                                  width: 45, height: 45),
                              Text(
                                "APPROVE",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Image.asset('images/callvisitor.png',
                                width: 45,
                                height: 45,
                                color: constant.appPrimaryMaterialColor),
                            Text("CALL",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12))
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Image.asset('images/deny.png',
                                width: 45, height: 45),
                            Text("DENY",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12))
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
