import 'package:flutter/material.dart';
import '../common/constant.dart' as cnst;

class Reminders extends StatefulWidget {
  @override
  _RemindersState createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  List reminderImages = [
    "images/drop.png",
    "images/medicine.png",
    "images/pencil.png"
  ];
  List reminderTitles = ["Water Intake", "Meds/Pills", "Custom"];
  List reminderColors = [
    Colors.blueAccent.withOpacity(0.5),
    Colors.greenAccent.withOpacity(0.7),
    Colors.amberAccent.withOpacity(0.6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
          ),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/HomeScreen', (route) => false);
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add New Reminder',
                style: TextStyle(
                  color: cnst.appPrimaryMaterialColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.add_alarm,
                color: cnst.appPrimaryMaterialColor,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          GridView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                // childAspectRatio: 1.3,
                mainAxisSpacing: 5, crossAxisSpacing: 5,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/AddReminderScreen');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: reminderColors[index],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            reminderImages[index],
                            height: MediaQuery.of(context).size.height * 0.085,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            reminderTitles[index],
                            style: TextStyle(
                              // color: Colors.cyanAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 10,
            child: RaisedButton(
              elevation: 3,
              onPressed: () {
                Navigator.pushNamed(context, '/AllRemindersScreen');
              },
              color: cnst.appPrimaryMaterialColor,
              child: Text(
                'My Reminders',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
