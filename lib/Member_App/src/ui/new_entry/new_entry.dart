import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_society_new/Member_App/src/common/convert_time.dart';
import 'package:smart_society_new/Member_App/src/global_bloc.dart';
import 'package:smart_society_new/Member_App/src/models/errors.dart';
import 'package:smart_society_new/Member_App/src/models/medicine.dart';
import 'package:smart_society_new/Member_App/src/models/medicine_type.dart';
import 'package:smart_society_new/Member_App/src/ui/homepage/homepage.dart';
import 'package:smart_society_new/Member_App/src/ui/success_screen/success_screen.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

import 'new_entry_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewEntry extends StatefulWidget {
  @override
  _NewEntryState createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {
  TextEditingController nameController;
  TextEditingController dosageController;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NewEntryBloc _newEntryBloc;

  GlobalKey<ScaffoldState> _scaffoldKey;

  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
    _newEntryBloc.dispose();
  }

  void initState() {
    super.initState();
    _newEntryBloc = NewEntryBloc();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    initializeNotifications();
    initializeErrorListen();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: constant.appPrimaryMaterialColor,
        ),
        centerTitle: true,
        title: Text(
          "Add New Reminder",
          style: TextStyle(
            color: constant.appPrimaryMaterialColor,
            fontSize: 18,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        child: Provider<NewEntryBloc>.value(
          value: _newEntryBloc,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 25,
            ),
            children: <Widget>[
              PanelTitle(
                title: "Name",
                isRequired: true,
              ),
              TextFormField(
                maxLength: 12,
                style: TextStyle(
                  fontSize: 16,
                ),
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                ),
              ),
              // PanelTitle(
              //   title: "Dosage in mg",
              //   isRequired: false,
              // ),
              // TextFormField(
              //   controller: dosageController,
              //   keyboardType: TextInputType.number,
              //   style: TextStyle(
              //     fontSize: 16,
              //   ),
              //   textCapitalization: TextCapitalization.words,
              //   decoration: InputDecoration(
              //     border: UnderlineInputBorder(),
              //   ),
              // ),
              SizedBox(
                height: 15,
              ),
              PanelTitle(
                title: "Reminder Type",
                isRequired: false,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: StreamBuilder<MedicineType>(
                  stream: _newEntryBloc.selectedMedicineType,
                  builder: (context, snapshot) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          MedicineTypeColumn(
                              type: MedicineType.Bottle,
                              name: "Water Intake",
                              iconValue: 0xe900,
                              isSelected: snapshot.data == MedicineType.Bottle
                                  ? true
                                  : false),
                          MedicineTypeColumn(
                            type: MedicineType.Pill,
                            name: "Meds/Pills",
                            iconValue: 0xe901,
                            isSelected: snapshot.data == MedicineType.Pill
                                ? true
                                : false,
                          ),
                          MedicineTypeColumn(
                            type: MedicineType.Custom,
                            name: "Custom",
                            iconValue: 0xe902,
                            isSelected: snapshot.data == MedicineType.Custom
                                ? true
                                : false,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              PanelTitle(
                title: "Interval Selection",
                isRequired: true,
              ),
              //ScheduleCheckBoxes(),
              IntervalSelection(),
              PanelTitle(
                title: "Starting Time",
                isRequired: true,
              ),
              SelectTime(),
              SizedBox(
                height: 35,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.11,
                  right: MediaQuery.of(context).size.height * 0.11,
                ),
                child: Container(
                  // width: 140,
                  height: 50,
                  child: FlatButton(
                    color: constant.appPrimaryMaterialColor,
                    shape: StadiumBorder(),
                    child: Center(
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onPressed: () {
                      print(_newEntryBloc.selectedMedicineType.value);
                      if(_newEntryBloc.selectedMedicineType.value==MedicineType.None){
                        displayError("Please select Reminder Type");
                      }
                      else{
                        String medicineName;
                        int dosage;
                        //--------------------Error Checking------------------------
                        //Had to do error checking in UI
                        //Due to unoptimized BLoC value-grabbing architecture
                        if (nameController.text == "") {
                          _newEntryBloc.submitError(EntryError.NameNull);
                          return;
                        }
                        if (nameController.text != "") {
                          medicineName = nameController.text;
                        }
                        // if (dosageController.text == "") {
                        //   dosage = 0;
                        // }
                        // if (dosageController.text != "") {
                        //   dosage = int.parse(dosageController.text);
                        // }
                        for (var medicine in _globalBloc.medicineList$.value) {
                          print("144545");
                          if (medicineName == medicine.medicineName) {
                            _newEntryBloc.submitError(EntryError.NameDuplicate);
                            return;
                          }
                        }
                        if (_newEntryBloc.selectedInterval$.value == 0) {
                          print("14454css");
                          _newEntryBloc.submitError(EntryError.Interval);
                          return;
                        }
                        if (_newEntryBloc.selectedTimeOfDay$.value == "None") {
                          print("144545dvd");
                          _newEntryBloc.submitError(EntryError.StartTime);
                          return;
                        }
                        //---------------------------------------------------------
                        String medicineType = _newEntryBloc
                            .selectedMedicineType.value
                            .toString()
                            .substring(13);
                        int interval = _newEntryBloc.selectedInterval$.value;
                        String startTime = _newEntryBloc.selectedTimeOfDay$.value;

                        List<int> intIDs =
                        makeIDs(24 / _newEntryBloc.selectedInterval$.value);
                        List<String> notificationIDs = intIDs
                            .map((i) => i.toString())
                            .toList(); //for Shared preference
                        print("dfef");
                        Medicine newEntryMedicine = Medicine(
                          notificationIDs: notificationIDs,
                          medicineName: medicineName,
                          // dosage: dosage,
                          medicineType: medicineType,
                          interval: interval,
                          startTime: startTime,
                        );
                        print("dfdfd");
                        _globalBloc.updateMedicineList(newEntryMedicine);
                        scheduleNotification(newEntryMedicine);
                        Fluttertoast.showToast(
                          msg: "Reminder Saved Successfully!!!",
                          gravity: ToastGravity.TOP,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        Navigator.pushNamed(context, '/Reminders');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initializeErrorListen() {
    _newEntryBloc.errorState$.listen(
      (EntryError error) {
        switch (error) {
          case EntryError.NameNull:
            displayError("Please enter the medicine's name");
            break;
          case EntryError.NameDuplicate:
            displayError("Medicine name already exists");
            break;
          case EntryError.Dosage:
            displayError("Please enter the dosage required");
            break;
          case EntryError.Interval:
            displayError("Please select the reminder's interval");
            break;
          case EntryError.StartTime:
            displayError("Please select the reminder's starting time");
            break;
          default:
        }
      },
    );
  }

  void displayError(String error) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(error),
        duration: Duration(milliseconds: 2000),
      ),
    );
  }

  List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }

  initializeNotifications() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  Future<void> scheduleNotification(Medicine medicine) async {
    var hour = int.parse(medicine.startTime[0] + medicine.startTime[1]);
    var ogValue = hour;
    var minute = int.parse(medicine.startTime[2] + medicine.startTime[3]);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      'repeatDailyAtTime description',
      importance: Importance.max,
      // sound: 'sound',
      ledColor: Color(0xFF3EB16F),
      ledOffMs: 1000,
      ledOnMs: 1000,
      enableLights: true,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    for (int i = 0; i < (24 / medicine.interval).floor(); i++) {
      if ((hour + (medicine.interval * i) > 23)) {
        hour = hour + (medicine.interval * i) - 24;
      } else {
        hour = hour + (medicine.interval * i);
      }
      await flutterLocalNotificationsPlugin.showDailyAtTime(
          int.parse(medicine.notificationIDs[i]),
          'Reminder: ${medicine.medicineName}',
          medicine.medicineType.toString() != MedicineType.None.toString()
              ? 'It is time to take your ${medicine.medicineType.toLowerCase()}, according to schedule'
              : 'It is time to take your medicine, according to schedule',
          Time(hour, minute, 0),
          platformChannelSpecifics);
      hour = ogValue;
    }
    //await flutterLocalNotificationsPlugin.cancelAll();
  }
}

class IntervalSelection extends StatefulWidget {
  @override
  _IntervalSelectionState createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  var _intervals = [
    6,
    8,
    12,
    24,
  ];
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context);
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Remind me every  ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            DropdownButton<int>(
              iconEnabledColor: constant.appPrimaryMaterialColor,
              hint: _selected == 0
                  ? Text(
                      "Select an Interval",
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    )
                  : null,
              elevation: 4,
              value: _selected == 0 ? null : _selected,
              items: _intervals.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  _selected = newVal;
                  _newEntryBloc.updateInterval(newVal);
                });
              },
            ),
            Text(
              _selected == 1 ? " hour" : " hours",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectTime extends StatefulWidget {
  @override
  _SelectTimeState createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final NewEntryBloc _newEntryBloc =
        Provider.of<NewEntryBloc>(context, listen: false);
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;
        _newEntryBloc.updateTime("${convertTime(_time.hour.toString())}" +
            "${convertTime(_time.minute.toString())}");
      });
    }
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0, bottom: 4),
        child: FlatButton(
          color: constant.appPrimaryMaterialColor,
          shape: StadiumBorder(),
          onPressed: () {
            _selectTime(context);
          },
          child: Center(
            child: Text(
              _clicked == false
                  ? "Pick Time"
                  : "${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MedicineTypeColumn extends StatelessWidget {
  final MedicineType type;
  final String name;
  final int iconValue;
  final bool isSelected;

  MedicineTypeColumn(
      {Key key,
      @required this.type,
      @required this.name,
      @required this.iconValue,
      @required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context);
    return GestureDetector(
      onTap: () {
        _newEntryBloc.updateSelectedMedicine(type);
      },
      child: Column(
        children: <Widget>[
          Container(
            width: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:
                  isSelected ? constant.appPrimaryMaterialColor : Colors.white,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: name == "Water Intake"
                    ? Container(
                        height: 50,
                        width: 50,
                        child: Image(
                          image: AssetImage("images/water.png"),
                        ),
                      )
                    : name == "Meds/Pills"
                        ? Container(
                            height: 50,
                            width: 50,
                            child: Image(
                              image: AssetImage("images/pills.png"),
                            ),
                          )
                        : Container(
                            height: 50,
                            width: 50,
                            child: Image(
                              image: AssetImage("images/pencil.png"),
                            ),
                          ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0, left: 5),
            child: Container(
              width: 80,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? constant.appPrimaryMaterialColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected
                        ? Colors.white
                        : constant.appPrimaryMaterialColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  final String title;
  final bool isRequired;

  PanelTitle({
    Key key,
    @required this.title,
    @required this.isRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 4),
      child: Text.rich(
        TextSpan(children: <TextSpan>[
          TextSpan(
            text: title,
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: isRequired ? " *" : "",
            style: TextStyle(
                fontSize: 14, color: constant.appPrimaryMaterialColor),
          ),
        ]),
      ),
    );
  }
}
