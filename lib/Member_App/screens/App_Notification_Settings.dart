import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class App_Notification_Settings extends StatefulWidget {
  @override
  _App_Notification_SettingsState createState() =>
      _App_Notification_SettingsState();
}

class _App_Notification_SettingsState extends State<App_Notification_Settings> {
  bool isIntercom = false;
  bool isEntryNotification = false;
  bool isExitNotification = false;
  bool isNotifyEntry = false;
  bool isExitNotify = false;
  bool isNotifyEntry1 = false;
  bool isExitNotify1 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "App Notification Settings",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: "OpenSans"),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              stops: [0.1, 7.0],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
            margin: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width,
            child: notificationSenttingUI()),
      ),
    );
  }

  notificationSenttingUI() {
    return Column(
      children: [
        Card(
          elevation: 8.0,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width,
                child: Container(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(Icons.phonelink_ring,color: Colors.white,size: 18,)
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10.0)),
                            Text(
                              "e-intercom",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "OpenSans"),
                            ),
                            Padding(padding: EdgeInsets.only(left: 115)),
                            Text(
                              "ON",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontFamily: "OpenSans"),
                            ),
                            Padding(padding: EdgeInsets.only(left: 20.0)),
                            FlutterSwitch(
                              height: 20.0,
                              width: 40.0,
                              padding: 4.0,
                              activeColor: Colors.deepPurple,
                              toggleSize: 15.0,
                              borderRadius: 10.0,
                              value: isIntercom,
                              onToggle: (value) {
                                setState(() {
                                  isIntercom = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.only(left: 40.0)),
                            Text(
                              "Explore and configure visitor\napproval notification",
                              style: TextStyle(
                                  fontSize: 12, fontFamily: "OpenSans"),
                            ),
                            Padding(padding: EdgeInsets.only(left: 60)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Setup",
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontFamily: "OpenSans"),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.deepPurple,
                                  size: 15,
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications_none,
                              color: Colors.grey,
                            )),
                        Text(
                          "App Notification",
                          style: TextStyle(fontFamily: "OpenSans"),
                        ),
                        Padding(padding: EdgeInsets.only(left: 40)),
                        Text(
                          "Change Ringtone",
                          style: TextStyle(
                              color: Colors.deepPurple, fontFamily: "OpenSans"),
                        ),
                        Icon(
                          Icons.music_note,
                          color: Colors.deepPurple,
                        )
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.phone_android,
                              color: Colors.grey,
                            )),
                        Text(
                          "IVR Call",
                          style: TextStyle(fontFamily: "OpenSans"),
                        ),
                        Padding(padding: EdgeInsets.only(left: 38)),
                        Text(
                          "9484447798,9879208321",
                          style: TextStyle(
                              color: Colors.deepPurple, fontFamily: "OpenSans"),
                        ),
                        Icon(
                          Icons.mode_edit,
                          color: Colors.deepPurple,
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Card(
          elevation: 8.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green[400],
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                             child: Icon(Icons.volume_up_rounded,color: Colors.white,size: 20,)
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 20.0)),
                        Text(
                          "Entry/Exit Notification",
                          style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.only(left: 70.0)),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.volume_up,
                              color: Colors.deepPurple,
                            )),
                      ]),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                Padding(padding: EdgeInsets.only(top: 10.0)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow[800],
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                             child: Icon(Icons.help_outline_outlined,color: Colors.white,size: 20,)
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 20.0)),
                        Text(
                          "Daily Helps",
                          style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.only(left: 50.0)),
                        Text(
                          "Maid,Cook,Driver etc.",
                          style: TextStyle(fontFamily: "OpenSans"),
                        ),
                      ]),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.login)),
                        Padding(padding: EdgeInsets.only(left: 20.0)),
                        Text(
                          "Entry Notification",
                          style: TextStyle(fontFamily: "OpenSans"),
                        ),
                        Padding(padding: EdgeInsets.only(left: 45.0)),
                        Text(
                          "ON",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: "OpenSans"),
                        ),
                        Padding(padding: EdgeInsets.only(left: 20.0)),
                        FlutterSwitch(
                          height: 20.0,
                          width: 40.0,
                          activeColor: Colors.deepPurple,
                          padding: 4.0,
                          toggleSize: 15.0,
                          borderRadius: 10.0,
                          value: isEntryNotification,
                          onToggle: (value) {
                            setState(() {
                              isEntryNotification = value;
                            });
                          },
                        ),
                      ]),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.login)),
                        Padding(padding: EdgeInsets.only(left: 20.0)),
                        Text(
                          "Exit Notification",
                          style: TextStyle(fontFamily: "OpenSans"),
                        ),
                        Padding(padding: EdgeInsets.only(left: 58.0)),
                        Text(
                          "ON",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: "OpenSans"),
                        ),
                        Padding(padding: EdgeInsets.only(left: 20.0)),
                        FlutterSwitch(
                          height: 20.0,
                          width: 40.0,
                          padding: 4.0,
                          activeColor: Colors.deepPurple,
                          toggleSize: 15.0,
                          borderRadius: 10.0,
                          value: isExitNotification,
                          onToggle: (value) {
                            setState(() {
                              isExitNotification = value;
                            });
                          },
                        ),
                      ]),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                Padding(padding: EdgeInsets.only(top: 10.0)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.person_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 20.0)),
                        Text(
                          "Your Guests",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "OpenSans"),
                        ),
                        Padding(padding: EdgeInsets.only(left: 180))
                      ]),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.login)),
                    Padding(padding: EdgeInsets.only(left: 20.0)),
                    Text(
                      "Notify on Entry",
                      style: TextStyle(fontFamily: "OpenSans"),
                    ),
                    Padding(padding: EdgeInsets.only(left: 60.0)),
                    Text(
                      "ON",
                      style: TextStyle(
                          fontFamily: "OpenSans",
                          color: Colors.grey,
                          fontSize: 14),
                    ),
                    Padding(padding: EdgeInsets.only(left: 20.0)),
                    FlutterSwitch(
                      height: 20.0,
                      activeColor: Colors.deepPurple,
                      width: 40.0,
                      padding: 4.0,
                      toggleSize: 15.0,
                      borderRadius: 10.0,
                      value: isNotifyEntry,
                      onToggle: (value) {
                        setState(() {
                          isNotifyEntry = value;
                        });
                      },
                    ),
                  ]),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.login)),
                    Padding(padding: EdgeInsets.only(left: 20.0)),
                    Text(
                      "Notify on Exit",
                      style: TextStyle(fontFamily: "OpenSans"),
                    ),
                    Padding(padding: EdgeInsets.only(left: 70.0)),
                    Text(
                      "ON",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontFamily: "OpenSans"),
                    ),
                    Padding(padding: EdgeInsets.only(left: 20.0)),
                    FlutterSwitch(
                      height: 20.0,
                      width: 40.0,
                      padding: 4.0,
                      activeColor: Colors.deepPurple,
                      toggleSize: 15.0,
                      borderRadius: 10.0,
                      value: isExitNotify,
                      onToggle: (value) {
                        setState(() {
                          isExitNotify = value;
                        });
                      },
                    ),
                  ]),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                Padding(padding: EdgeInsets.only(top: 10.0)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.delivery_dining,color: Colors.white,size: 20,)
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 20.0)),
                        Text(
                          "Delivery,Cabes and others",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "OpenSans"),
                        ),
                        Padding(padding: EdgeInsets.only(left: 80))
                      ]),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.login)),
                    Padding(padding: EdgeInsets.only(left: 20.0)),
                    Text(
                      "Notify on Entry",
                      style: TextStyle(fontFamily: "OpenSans"),
                    ),
                    Padding(padding: EdgeInsets.only(left: 60.0)),
                    Text(
                      "ON",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontFamily: "OpenSans"),
                    ),
                    Padding(padding: EdgeInsets.only(left: 20.0)),
                    FlutterSwitch(
                      height: 20.0,
                      activeColor: Colors.deepPurple,
                      width: 40.0,
                      padding: 4.0,
                      toggleSize: 15.0,
                      borderRadius: 10.0,
                      value: isNotifyEntry1,
                      onToggle: (value) {
                        setState(() {
                          isNotifyEntry1 = value;
                        });
                      },
                    ),
                  ]),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.login)),
                    Padding(padding: EdgeInsets.only(left: 20.0)),
                    Text(
                      "Notify on Exit",
                      style: TextStyle(fontFamily: "OpenSans"),
                    ),
                    Padding(padding: EdgeInsets.only(left: 70.0)),
                    Text(
                      "ON",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontFamily: "OpenSans"),
                    ),
                    Padding(padding: EdgeInsets.only(left: 20.0)),
                    FlutterSwitch(
                      height: 20.0,
                      width: 40.0,
                      padding: 4.0,
                      activeColor: Colors.deepPurple,
                      toggleSize: 15.0,
                      borderRadius: 10.0,
                      value: isExitNotify1,
                      onToggle: (value) {
                        setState(() {
                          isExitNotify1 = value;
                        });
                      },
                    ),
                  ]),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
