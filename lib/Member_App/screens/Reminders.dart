// import 'package:flutter/material.dart';
// import '../common/constant.dart' as cnst;
//
// class Reminders extends StatefulWidget {
//   @override
//   _RemindersState createState() => _RemindersState();
// }
//
// class _RemindersState extends State<Reminders> {
//   List reminderImages = [
//     "images/drop.png",
//     "images/medicine.png",
//     "images/pencil.png"
//   ];
//   List reminderTitles = ["Water Intake", "Meds/Pills", "Custom"];
//   List reminderColors = [
//     Colors.blueAccent.withOpacity(0.5),
//     Colors.greenAccent.withOpacity(0.7),
//     Colors.amberAccent.withOpacity(0.6),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reminders'),
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_rounded,
//           ),
//           onPressed: () {
//             Navigator.pushNamedAndRemoveUntil(
//                 context, '/HomeScreen', (route) => false);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 5,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Add New Reminder',
//                 style: TextStyle(
//                   color: cnst.appPrimaryMaterialColor,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               SizedBox(
//                 width: 5,
//               ),
//               Icon(
//                 Icons.add_alarm,
//                 color: cnst.appPrimaryMaterialColor,
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           GridView.builder(
//               physics: BouncingScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: 3,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 // childAspectRatio: 1.3,
//                 mainAxisSpacing: 5, crossAxisSpacing: 5,
//               ),
//               itemBuilder: (BuildContext context, int index) {
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.pushNamed(context, '/AddReminderScreen');
//                   },
//                   child: Container(
//                     width: MediaQuery.of(context).size.width * 0.3,
//                     child: Card(
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       color: reminderColors[index],
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Image.asset(
//                             reminderImages[index],
//                             height: MediaQuery.of(context).size.height * 0.085,
//                             fit: BoxFit.fill,
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           Text(
//                             reminderTitles[index],
//                             style: TextStyle(
//                               // color: Colors.cyanAccent,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width - 10,
//             child: RaisedButton(
//               elevation: 3,
//               onPressed: () {
//                 Navigator.pushNamed(context, '/AllRemindersScreen');
//               },
//               color: cnst.appPrimaryMaterialColor,
//               child: Text(
//                 'My Reminders',
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_society_new/Member_App/src/global_bloc.dart';
import 'package:smart_society_new/Member_App/src/models/medicine.dart';
import 'package:smart_society_new/Member_App/src/ui/medicine_details/medicine_details.dart';
import 'package:smart_society_new/Member_App/src/ui/new_entry/new_entry.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class Reminders extends StatefulWidget {
  @override
  _RemindersState createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: constant.appPrimaryMaterialColor,
        elevation: 0.0,
      ),
      body: Container(
        color: Color(0xFFF6F8FC),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 3,
              child: TopContainer(),
            ),
            SizedBox(
              height: 10,
            ),
            Flexible(
              flex: 7,
              child: Provider<GlobalBloc>.value(
                child: BottomContainer(),
                value: _globalBloc,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: constant.appPrimaryMaterialColor,
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewEntry(),
            ),
          );
        },
      ),
    );
  }
}

class TopContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(50, 27),
          bottomRight: Radius.elliptical(50, 27),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.grey[400],
            offset: Offset(0, 3.5),
          )
        ],
        color: constant.appPrimaryMaterialColor,
      ),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              bottom: 10,
            ),
            child: Text(
              "Reminders",
              style: TextStyle(
                fontFamily: "Angel",
                fontSize: 64,
                color: Colors.white,
              ),
            ),
          ),
          Divider(
            color: Color(0xFFB0F3CB),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Center(
              child: Text(
                "Number of Reminders",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          StreamBuilder<List<Medicine>>(
            stream: globalBloc.medicineList$,
            builder: (context, snapshot) {
              return Padding(
                padding: EdgeInsets.only(),
                child: Center(
                  child: Text(
                    !snapshot.hasData ? '0' : snapshot.data.length.toString(),
                    style: TextStyle(
                      fontFamily: "Neu",
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BottomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return StreamBuilder<List<Medicine>>(
      stream: _globalBloc.medicineList$,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else if (snapshot.data.length == 0) {
          return Container(
            color: Color(0xFFF6F8FC),
            child: Center(
              child: Text(
                "Press + to add a Reminder",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFFC9C9C9),
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        } else {
          return Container(
            color: Color(0xFFF6F8FC),
            child: GridView.builder(
              padding: EdgeInsets.only(top: 12),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return MedicineCard(snapshot.data[index]);
              },
            ),
          );
        }
      },
    );
  }
}

class MedicineCard extends StatelessWidget {
  final Medicine medicine;

  MedicineCard(this.medicine);

  Hero makeIcon(double size) {
    if (medicine.medicineType == "Bottle") {
      return Hero(
        tag: medicine.medicineName + medicine.medicineType,
        child: Icon(
          IconData(0xe900, fontFamily: "Ic"),
          color: constant.appPrimaryMaterialColor,
          size: size,
        ),
      );
    } else if (medicine.medicineType == "Pill") {
      return Hero(
        tag: medicine.medicineName + medicine.medicineType,
        child: Icon(
          IconData(0xe901, fontFamily: "Ic"),
          color: constant.appPrimaryMaterialColor,
          size: size,
        ),
      );
    } else if (medicine.medicineType == "Custom") {
      return Hero(
        tag: medicine.medicineName + medicine.medicineType,
        child: Icon(
          IconData(0xe902, fontFamily: "Ic"),
          color: constant.appPrimaryMaterialColor,
          size: size,
        ),
      );
    } else if (medicine.medicineType == "Tablet") {
      return Hero(
        tag: medicine.medicineName + medicine.medicineType,
        child: Icon(
          IconData(0xe903, fontFamily: "Ic"),
          color: constant.appPrimaryMaterialColor,
          size: size,
        ),
      );
    }
    return Hero(
      tag: medicine.medicineName + medicine.medicineType,
      child: Icon(
        Icons.error,
        color: constant.appPrimaryMaterialColor,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: InkWell(
        highlightColor: Colors.white,
        splashColor: Colors.grey,
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder<Null>(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return AnimatedBuilder(
                    animation: animation,
                    builder: (BuildContext context, Widget child) {
                      return Opacity(
                        opacity: animation.value,
                        child: MedicineDetails(medicine),
                      );
                    });
              },
              transitionDuration: Duration(milliseconds: 500),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                medicine.medicineType == "Bottle"
                    ? Container(
                        height: 50,
                        width: 50,
                        child: Image(
                          image: AssetImage("images/water.png"),
                        ),
                      )
                    : medicine.medicineType == "Pill"
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
                Hero(
                  tag: medicine.medicineName,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      medicine.medicineName,
                      style: TextStyle(
                          fontSize: 22,
                          color: constant.appPrimaryMaterialColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Text(
                  medicine.interval == 1
                      ? "Every " + medicine.interval.toString() + " hour"
                      : "Every " + medicine.interval.toString() + " hours",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFC9C9C9),
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
