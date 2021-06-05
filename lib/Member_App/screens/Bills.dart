import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/BillDetail.dart';

class Bills extends StatefulWidget {
  @override
  _BillsState createState() => _BillsState();
}

class _BillsState extends State<Bills> with TickerProviderStateMixin {
  TabController _tabController;
  List<Tab> tabList = List();
  int selectedTab = 0;

  @override
  void initState() {
    tabList.add(
      Tab(text: 'Unpaid'),
    );
    tabList.add(
      Tab(text: 'Paid'),
    );
    _tabController = new TabController(vsync: this, length: tabList.length);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
Navigator.of(context).pop();
},
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          centerTitle: true,
          title: Text(
            "My Bills",
            style: TextStyle(fontSize: 17),
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              color: constant.appPrimaryMaterialColor,
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(bottom: 15),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                      padding:
                          EdgeInsets.only(top: 8, bottom: 8, left: 6, right: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "${constant.Inr_Rupee} 100",
                            style: TextStyle(
                                color: Colors.red[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Total Due",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                      padding:
                          EdgeInsets.only(top: 8, bottom: 8, left: 6, right: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "${constant.Inr_Rupee} 520",
                            style: TextStyle(
                                color: Colors.green[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Current Balance",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: constant.appPrimaryMaterialColor,
              child: TabBar(
                controller: _tabController,
                unselectedLabelColor: Colors.white,
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                unselectedLabelStyle:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                indicatorColor: Colors.white,
                onTap: (index) {
                  setState(() {
                    selectedTab = index;
                  });
                },
                tabs: tabList,
              ),
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: <Widget>[
                Container(
                  color: Colors.grey[200],
                  child: ListView.separated(
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              "Annual Maintenance For 2019",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )),
                            Column(
                              children: <Widget>[
                                Text(
                                  "${constant.Inr_Rupee} 12000",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange),
                                ),
                                Text(
                                  "10 Dec 2019",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                      fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  child: ListView.separated(
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BillDetail(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                "Annual Maintenance For 2019",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "${constant.Inr_Rupee} 12000",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                  Text(
                                    "10 Dec 2019",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                        fontSize: 12),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  ),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
