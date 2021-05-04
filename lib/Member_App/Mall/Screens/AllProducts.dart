import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_society_new/Member_App/Mall/Common/MallServices.dart';
import 'package:smart_society_new/Member_App/Mall/Components/ProductComponent.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

class AllProducts extends StatefulWidget {
  String selectedCategory = "";

  AllProducts({this.selectedCategory});

  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts>
    with TickerProviderStateMixin {
  TabController _tabController;
  List categoryData = [];
  bool isLoading = true;
  List<Tab> tabList = List();
  int selectedTab = 0;

  @override
  void initState() {
    _getCategory();
  }

  _getCategory() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        MallServices.GetCateogries().then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.length > 0) {
            for (int i = 0; i < data.length; i++) {
              if (data[i]["parent_id"].toString() != "0") {
                setState(() {
                  tabList.add(Tab(text: '${data[i]["categories_name"]}'));
                  categoryData.add(data);
                });
                if (widget.selectedCategory != null) {}
              }
            }
            setState(() {
              _tabController = new TabController(
                  vsync: this,
                  length: tabList.length,
                  initialIndex: selectedTab);
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Something Went Wrong");
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg, {String title = 'MYJINI'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: <Widget>[
              TabBar(
                controller: _tabController,
                isScrollable: true,
                unselectedLabelColor: Colors.grey[700],
                unselectedLabelStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                labelColor: cnst.appPrimaryMaterialColor,
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                onTap: (index) {
                  setState(() {
                    selectedTab = index;
                  });
                },
                tabs: tabList,
              ),
              Expanded(
                child:
                    TabBarView(controller: _tabController, children: <Widget>[
                  for (int i = 0; i < categoryData.length; i++) ...[
                    Container(
                      color: Colors.grey[200],
                      child: StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        itemCount: 8,
                        itemBuilder: (BuildContext context, int index) {
                          return ProductComponent();
                        },
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.fit(1),
                      ),
                    )
                  ]
                ]),
              ),
            ],
          );
  }
}
