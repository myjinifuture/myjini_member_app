import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/LoadingComponent.dart';
import 'package:smart_society_new/Mall_App/Screens/SetFilterScreen.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List filterList = [];
  bool isFilterLoading = true;
  List selecteList = [];
  List expansionList = [];

  @override
  void initState() {
    _getFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title:
            Text("Filter", style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        child: isFilterLoading == true
            ? LoadingComponent()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListView.separated(
                    padding: EdgeInsets.only(top: 10),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filterList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  expansionList[index] = !expansionList[index];
                                });
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      "${filterList[index]["Title"]}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: expansionList[index] == false
                                          ? Icon(Icons.arrow_drop_down)
                                          : Icon(Icons.arrow_drop_up)),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: expansionList[index],
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: filterList[index]["values"].length,
                              itemBuilder: (BuildContext context, int vindex) {
                                return Container(
                                  height: 48,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: CheckboxListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(
                                        filterList[index]["values"][vindex],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                      value: selecteList.contains(
                                          "${filterList[index]["values"][vindex]}" +
                                              "#${filterList[index]["Title"]}#"),
                                      activeColor: appPrimaryMaterialColor,
                                      onChanged: (bool val) {
                                        setState(() {
                                          String value = filterList[index]
                                                  ["values"][vindex] +
                                              "#${filterList[index]["Title"]}#";
                                          if (val) {
                                            selecteList.add(value);
                                          } else {
                                            selecteList.remove(value);
                                          }
                                        });
                                      }, //  <-- leading Checkbox
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                      //   FilterScreenComponent(
                      //   filterdata: filterList[index],
                      // );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Container(
                      color: Colors.grey[400],
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12.0, right: 12, top: 35),
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                        color: appPrimaryMaterialColor,
                        onPressed: () {
                          Map<String, String> map = {};
                          for (int i = 0; i < selecteList.length; i++) {
                            for (int j = 0; j < filterList.length; j++) {
                              String title =
                                  selecteList[i].toString().split("#")[1];
                              String txtValue =
                                  selecteList[i].toString().split("#")[0];
                              if (title == filterList[j]["Title"]) {
                                if (map.containsKey(title)) {
                                  map.update(
                                      title, (value) => value + "," + txtValue);
                                } else {
                                  map.addAll({title: txtValue});
                                }
                              }
                            }
                          }
                          print(map);
                          if (map.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please select any one");
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new SetFilterScreen(
                                          filterdata: map,
                                        )));
                          }
                        },
                        child: Text(
                          "APPLY",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  _getFilter() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isFilterLoading = true;
        });

        Services.postforlist(apiname: 'getFilter').then((ResponseList) async {
          setState(() {
            isFilterLoading = false;
          });
          if (ResponseList.length > 0) {
            setState(() {
              filterList = ResponseList;
              expansionList = [
                for (int i = 0; i < ResponseList.length; i++) false
              ];
            });
          } else {
            Fluttertoast.showToast(msg: "Product Not Found");
          }
        }, onError: (e) {
          setState(() {
            isFilterLoading = false;
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "Something Went Wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }
}
