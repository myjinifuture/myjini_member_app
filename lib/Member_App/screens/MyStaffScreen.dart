import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/screens/MyStaffOthersListing.dart';
import 'package:smart_society_new/Member_App/screens/MyStaffMaidListing.dart';

class MyStaffScreen extends StatefulWidget {
  const MyStaffScreen({Key key}) : super(key: key);

  @override
  _MyStaffScreenState createState() => _MyStaffScreenState();
}

class _MyStaffScreenState extends State<MyStaffScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text(
                  "Maid",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Tab(
                child: Text(
                  "Others",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          title: Text(
            'My Staff',
            style: TextStyle(fontSize: 18),
          ),

        ),
        body: TabBarView(
          children: [
            MyStaffMaidListing(),
            MyStaffOthersListing(),
          ],
        ),
      ),
    );
  }
}
