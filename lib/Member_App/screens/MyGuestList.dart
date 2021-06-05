import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/screens/MemeberGuestList.dart';
import 'package:smart_society_new/Member_App/screens/MemeberVisitorList.dart';

class MyGuestList extends StatefulWidget {
  @override
  _MyGuestListState createState() => _MyGuestListState();
}

class _MyGuestListState extends State<MyGuestList> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                  icon: Text(
                "Upcoming",
                style: TextStyle(fontWeight: FontWeight.w600),
              )),
              Tab(
                  icon: Text(
                "Visitors",
                style: TextStyle(fontWeight: FontWeight.w600),
              )),
            ],
          ),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Visitor List',
              style: TextStyle(fontSize: 18),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: TabBarView(children: [MemberGuestList(), MemberVisitorList()]),
      ),
    );
  }
}
