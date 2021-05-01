import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/constant.dart' as cnst;

class AddReminderScreen extends StatefulWidget {
  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  double _height;
  double _width;

  String _setTime, _setDate;

  String _hour, _minute, _time;

  String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  List days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  List<bool> dayBool = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  bool allDays = false;
  bool hourly = false;

  int dayIndex = -1;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController reminderTitle = TextEditingController();
  TextEditingController reminderDescription = TextEditingController();
  TextEditingController hourDuration = TextEditingController();
  TextEditingController repeatCount = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  setAllDays() {
    for (int i = 0; i < days.length; i++) {
      setState(() {
        dayBool[i] = !dayBool[i];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reminder'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Title of Reminder',
                  style: TextStyle(
                    fontSize: 16,
                    color: cnst.appPrimaryMaterialColor,
                  ),
                ),
              ],
            ),
            Card(
              elevation: 3,
              child: TextFormField(
                controller: reminderTitle,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      left: 10,
                    ),
                    hintText: "Start typing here..."),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  'What is this Reminder About?',
                  style: TextStyle(
                    fontSize: 16,
                    color: cnst.appPrimaryMaterialColor,
                  ),
                ),
              ],
            ),
            Card(
              elevation: 3,
              child: TextFormField(
                controller: reminderDescription,
                maxLines: 4,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10, top: 5),
                    hintText: "Description here... (Optional)"),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Choose Date',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            color: cnst.appPrimaryMaterialColor),
                      ),
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                            enabled: false,
                            keyboardType: TextInputType.text,
                            controller: _dateController,
                            onSaved: (String val) {
                              _setDate = val;
                            },
                            decoration: InputDecoration(
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                // labelText: 'Time',
                                contentPadding: EdgeInsets.only(top: 0.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Choose Time',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            color: cnst.appPrimaryMaterialColor),
                      ),
                      InkWell(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                            onSaved: (String val) {
                              _setTime = val;
                            },
                            enabled: false,
                            keyboardType: TextInputType.text,
                            controller: _timeController,
                            decoration: InputDecoration(
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                // labelText: 'Time',
                                contentPadding: EdgeInsets.all(5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            //days list view
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                GestureDetector(
                  onTap: () {
                    setState(() {
                      dayBool[0] = !dayBool[0];
                    });
                  },
                  child: Card(
                    elevation: 2,
                    color: dayBool[0] == true
                        ? cnst.appPrimaryMaterialColor
                        : Colors.grey[400],
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: Text(
                          days[0],
                          style: TextStyle(
                              color: dayBool[0] == true ? Colors.white : null),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      dayBool[1] = !dayBool[1];
                    });
                  },
                  child: Card(
                    elevation: 2,
                    color: dayBool[1] == true
                        ? cnst.appPrimaryMaterialColor
                        : Colors.grey[400],
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: Text(
                          days[1],
                          style: TextStyle(
                              color: dayBool[1] == true ? Colors.white : null),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      dayBool[2] = !dayBool[2];
                    });
                  },
                  child: Card(
                    elevation: 2,
                    color: dayBool[2] == true
                        ? cnst.appPrimaryMaterialColor
                        : Colors.grey[400],
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: Text(
                          days[2],
                          style: TextStyle(
                              color: dayBool[2] == true ? Colors.white : null),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      dayBool[3] = !dayBool[3];
                    });
                  },
                  child: Card(
                    elevation: 2,
                    color: dayBool[3] == true
                        ? cnst.appPrimaryMaterialColor
                        : Colors.grey[400],
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: Text(
                          days[3],
                          style: TextStyle(
                              color: dayBool[3] == true ? Colors.white : null),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      dayBool[4] = !dayBool[4];
                    });
                  },
                  child: Card(
                    elevation: 2,
                    color: dayBool[4] == true
                        ? cnst.appPrimaryMaterialColor
                        : Colors.grey[400],
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: Text(
                          days[4],
                          style: TextStyle(
                              color: dayBool[4] == true ? Colors.white : null),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      dayBool[5] = !dayBool[5];
                    });
                  },
                  child: Card(
                    elevation: 2,
                    color: dayBool[5] == true
                        ? cnst.appPrimaryMaterialColor
                        : Colors.grey[400],
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: Text(
                          days[5],
                          style: TextStyle(
                              color: dayBool[5] == true ? Colors.white : null),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      dayBool[6] = !dayBool[6];
                    });
                  },
                  child: Card(
                    elevation: 2,
                    color: dayBool[6] == true
                        ? cnst.appPrimaryMaterialColor
                        : Colors.grey[400],
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: Text(
                          days[6],
                          style: TextStyle(
                              color: dayBool[6] == true ? Colors.white : null),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: allDays,
                          onChanged: (value) {
                            setState(() {
                              allDays = value;
                            });
                            setAllDays();
                          },
                        ),
                        Text('All'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: hourly,
                          onChanged: (value) {
                            setState(() {
                              hourly = value;
                            });
                          },
                        ),
                        Text('Hourly'),
                      ],
                    ),
                  ],
                ),
                hourly == true
                    ? Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 55,
                                      width: 55,
                                      child: Card(
                                        child: TextFormField(
                                          textAlign: TextAlign.center,
                                          controller: hourDuration,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Hour\nDuration',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 55,
                                      width: 55,
                                      child: Card(
                                        child: TextFormField(
                                          textAlign: TextAlign.center,
                                          controller: repeatCount,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Repeat\nCount',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 45,
              width: 200,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: cnst.appPrimaryMaterialColor,
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Add Reminder',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Icon(
                      Icons.add_alarm,
                      color: Colors.white,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
