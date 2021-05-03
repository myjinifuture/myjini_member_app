import 'package:flutter/material.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Mall_App/Screens/OrderDetailScreen.dart';
import 'package:smart_society_new/Mall_App/Screens/OrderHistoryScreen.dart';

class OrderTab extends StatefulWidget {
  var OrderId;
  OrderTab({this.OrderId});
  @override
  _OrderTabState createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text("Order History",
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        body: Column(
          children: [
            TabBar(
                labelColor: Colors.black,
                labelStyle: TextStyle(fontWeight: FontWeight.w600),
                unselectedLabelColor: Colors.grey,
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
                indicatorColor: appPrimaryMaterialColor,
                tabs: [
                  Tab(text: "Order Detail"),
                  Tab(text: "Order Item"),
                ]),
            Expanded(
              child: TabBarView(children: [
                OrderHistoryScreen(),
                OrderDetailScreen(orderid: widget.OrderId)
              ]),
            )
          ],
        ),
      ),
    );
  }
}
