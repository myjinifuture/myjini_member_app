import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smart_society_new/Member_App/Services/AdList.dart';
import 'package:smart_society_new/Member_App/Services/ProductList.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

class AdvertisementList extends StatefulWidget {
  @override
  _AdvertisementListState createState() => _AdvertisementListState();
}

class _AdvertisementListState extends State<AdvertisementList>with TickerProviderStateMixin {
  TabController _tabController;
  ProgressDialog pr;



  @override
  void initState() {

    _tabController = new TabController(vsync: this, length: 2);
    super.initState();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait..",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            //backgroundColor: cnst.appPrimaryMaterialColor,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigator.pushReplacementNamed(context, "/HomeScreen");
              Navigator.pop(context);
            }),
        centerTitle: true,
        title: Text(
          'Advertisement',
          style: TextStyle(fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body:  Column(
        children: <Widget>[
          TabBar(
            unselectedLabelColor: Colors.grey[500],
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            controller: _tabController,
            tabs: [
              Tab(
                child: Text(
                  "Ad",
                ),
              ),
              Tab(
                child: Text(
                  "Product",
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                AdList(),
                ProductList()

              ],
            ),
          ),
        ],
      ),
    );
  }
}
