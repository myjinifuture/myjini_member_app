import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/component/MaidComponent.dart';
import 'package:smart_society_new/Member_App/screens/MaidListing.dart';
import 'package:smart_society_new/Member_App/screens/OtherHelpListing.dart';

class DailyHelp extends StatefulWidget {
  @override
  _DailyHelpState createState() => _DailyHelpState();
}

class _DailyHelpState extends State<DailyHelp> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
      },
      child: DefaultTabController(
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
              'Daily Help',
              style: TextStyle(fontSize: 18),
            ),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
          body: TabBarView(
            children: [MaidListing(), OtherHelpListing()],
          ),
        ),
      ),
    );
  }
}
