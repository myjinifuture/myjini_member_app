import 'dart:convert';
import 'package:flutter/material.dart';

class OneToOne extends StatefulWidget {

  @override
  _OneToOneState createState() => _OneToOneState();
}

double h = 0, w = 0, xPos = 0, yPos = 0;
List<String> _locations = ['A', 'B', 'C', 'D'];
String header = 'Members to Invite';

class _OneToOneState extends State<OneToOne> {
  GlobalKey actionKey = LabeledGlobalKey('Member to Invite:');
  bool isDropped = false;
  OverlayEntry floatingDropdown;

  @override
  void initState() {
    super.initState();
  }

  void findDropdownSize() {
    RenderBox renderBox =
        actionKey.currentContext.findRenderObject() as RenderBox;
    h = renderBox.size.height;
    w = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPos = offset.dx;
    yPos = offset.dy;
  }

  OverlayEntry createFloatingDropdown() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPos,
        width: w,
        top: yPos + h,
        height:(h * _locations.length)+81,
        child: Container(
          height:(h * _locations.length)+20,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(children: [
              Container(
                  height: h * 5,
                  child: SingleChildScrollView(
                    child: Column(
                      children: _createItems(),
                    ),
                  )
              ),
            ]),
          ),
        ),
      );
    });
  }

  _createItems() {
    return new List<Widget>.generate(_locations.length, (int index) {
      return InkWell(
        onTap: () {
          header = _locations[index].toString();
          floatingDropdown.remove();
          isDropped = false;
          setState(() {
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade200,
            border: Border.all(color: Colors.deepPurple.shade600),
            borderRadius: (index == 0)
                ? BorderRadius.only(
                topLeft: Radius.circular(7), topRight: Radius.circular(7))
                : (index == (_locations.length - 1))
                ? BorderRadius.only(
                bottomLeft: Radius.circular(7),
                bottomRight: Radius.circular(7))
                : BorderRadius.circular(0),
          ),
          height: h,
          width: w,
          child: Text(_locations[index].toString()),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'ONE-TO-ONE SLIP',
              style: TextStyle(
                color: Colors.white,
                  fontFamily: "OpenSans",fontSize: 16
              ),
            ),
            actions: [
              IconButton(
                  padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                  onPressed: () {},
                  icon: Icon(
                    Icons.help_outline_sharp,
                    size: 25,
                    color: Colors.white,
                 ))
            ],
            elevation: 5.0,
            centerTitle: true,
            backgroundColor: Colors.deepPurple,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              TextField(
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintStyle:
                      TextStyle(fontSize: 20, color: Colors.grey),
                  suffixIcon: Icon(
                    Icons.search_sharp,
                    size: 30,
                    color: Colors.deepPurple,
                  ),
                  isDense: true,
                  hintText: 'Met With:',
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(7))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                key: actionKey,
                onTap: () {
                  findDropdownSize();

                  if (isDropped == false) {
                  floatingDropdown =
                      createFloatingDropdown();
                    Overlay.of(context).insert(floatingDropdown);
                  }
                  if(isDropped==true)
                   {
                      floatingDropdown.remove();
                   }
                  isDropped = !isDropped;
                  setState(() {});
                },
                child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade600,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            header,
                            style: TextStyle(
                                fontSize: 22, color: Colors.white),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          )
                        ])),
              ),
              SizedBox(
                height: 40,
              ),
              TextField(
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintStyle:
                      TextStyle(fontSize: 20, color: Colors.grey),
                  isDense: true,
                  hintText: 'Place of meeting:',
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(7))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintStyle:
                      TextStyle(fontSize: 20, color: Colors.black),
                  isDense: true,
                  hintText: dateFormatter(DateTime.now()),
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(7))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(fontSize: 20),
                maxLines: 4,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintStyle:
                      TextStyle(fontSize: 20, color: Colors.grey),
                  isDense: true,
                  hintText: 'Agenda',
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(7))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  height: 40,
                  child: Text(
                    'Submit',
                    style:
                        TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  color: Colors.deepPurple,
                  onPressed: () {},
                ),
              ),
            ]),
          ),
        ));
  }

  String dateFormatter(DateTime date) {
    dynamic dayData =
        '{ "1" : "Monday", "2" : "Tuesday", "3" : "Wednesday", "4" : "Thursday", "5" : "Friday", "6" : "Saturday", "7" : "Sunday" }';

    dynamic monthData =
        '{ "1" : "January", "2" : "February", "3" : "March", "4" : "April", "5" : "May", "6" : "June", "7" :'
        ' "July", "8" : "August", "9" : "September", "10" : "October", "11" : "November", "12" : "December" }';

    return json.decode(dayData)['${date.weekday}'] +
        " " +
        json.decode(monthData)['${date.month}'] +
        ", " +
        date.day.toString() +
        ", " +
        date.year.toString();
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

