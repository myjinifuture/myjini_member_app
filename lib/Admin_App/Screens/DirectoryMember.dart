import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Admin_App/Component/DirectoryMemberComponent.dart';
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Admin_App/Component/NoDataComponent.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';

class DirectoryMember extends StatefulWidget {
  @override
  _DirectoryMemberState createState() => _DirectoryMemberState();
}

class _DirectoryMemberState extends State<DirectoryMember> {
  bool isLoading = false, isFilter = false, isMemberLoading = false;
  List memberData = [];
  List _wingList = [];
  List filterMemberData = [];

  TextEditingController _controller = TextEditingController();

  Widget appBarTitle = new Text(
    "Member Directory",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  );

  List searchMemberData = new List();
  bool _isSearching = false, isfirst = false;
  String selectedWing = "";

  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  void initState() {
    getLocaldata();
  }

  showHHMsg(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String SocietyId,MobileNo;
  _getDirectoryListing(String seletecedWing) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId" : SocietyId
        };
        // setState(() {
        //   isLoading = true;
        // });
        Services.responseHandler(apiName: "admin/directoryListing",body: data).then((data) async {
          memberData.clear();
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              // memberData = data.Data;
              for(int i=0;i<data.Data.length;i++){
                if(data.Data[i]["society"]["wingId"] == selectedWing){
                  memberData.add(data.Data[i]);
                }
              }
              // isLoading = false;
            });
            print("memberData");
            print(memberData);
          } else {
            // setState(() {
            //   isLoading = false;
            // });
          }
        }, onError: (e) {
          showHHMsg("Something Went Wrong Please Try Again","");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.","");
    }
  }

  _getWing(String societyId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId" : societyId
        };

        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "admin/getAllWingOfSociety",body: data).then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              for(int i=0;i<data.Data.length;i++){
                if(data.Data[i]["totalFloor"].toString()!="0"){
                  _wingList.add(data.Data[i]);
                }
              };
              // _wingList = data.Data;
              isLoading = false;
              selectedWing = data.Data[0]["_id"].toString();
            });
            _getDirectoryListing(selectedWing);
            // _getotherListing(SocietyId,_fromDate.toString(),_toDate.toString());
            // S.Services.getStaffData(DateTime.now().toString(), DateTime.now().toString(),
            //     data[0]["Id"].toString());
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      MobileNo = prefs.getString(Session.session_login);
      SocietyId = prefs.getString(Session.SocietyId);
    });
    _getWing(SocietyId);
  }

  showMsg(String msg, {String title = 'MYJINI'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/Dashboard");
      },
      child: Scaffold(
        appBar: buildAppBar(context),
        body: isLoading
            ? LoadingComponent()
            : Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < _wingList.length; i++) ...[
                        GestureDetector(
                          onTap: () {
                            if (selectedWing != _wingList[i]["_id"].toString()) {
                              setState(() {
                                selectedWing = _wingList[i]["_id"].toString();
                                _getDirectoryListing(selectedWing);
                              });
                              setState(() {
                                memberData = [];
                                filterMemberData = [];
                                searchMemberData = [];
                                isFilter = false;
                                _isSearching = false;
                              });
                            }
                          },
                          child: Container(
                            width: selectedWing == _wingList[i]["_id"].toString()
                                ? 60
                                : 45,
                            height:
                                selectedWing == _wingList[i]["_id"].toString()
                                    ? 60
                                    : 45,
                            margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                            decoration: BoxDecoration(
                                color: selectedWing ==
                                        _wingList[i]["_id"].toString()
                                    ? cnst.appPrimaryMaterialColor
                                    : Colors.white,
                                border: Border.all(
                                    color: cnst.appPrimaryMaterialColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            alignment: Alignment.center,
                            child: Text(
                              "${_wingList[i]["wingName"]}",
                              style: TextStyle(
                                  color: selectedWing ==
                                          _wingList[i]["_id"].toString()
                                      ? Colors.white
                                      : cnst.appPrimaryMaterialColor,
                                  fontSize: 19),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: FlatButton(
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.end,
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: <Widget>[
                  //         Text(
                  //           "Filter",
                  //           style: TextStyle(
                  //               fontSize: 16,
                  //               color: cnst.appPrimaryMaterialColor,
                  //               fontWeight: FontWeight.bold),
                  //         ),
                  //         SizedBox(
                  //           width: 6,
                  //         ),
                  //         Icon(
                  //           Icons.filter_list,
                  //           size: 19,
                  //           color: cnst.appPrimaryMaterialColor,
                  //         ),
                  //       ],
                  //     ),
                  //     onPressed: () {
                  //       showDialog(
                  //           context: context,
                  //           builder: (context) {
                  //             return showFilterDailog(
                  //               onSelect: (gender, isOwned, isOwner, isRented) {
                  //                 String owned = isOwned ? "Owned" : "";
                  //                 String owner = isOwner ? "Owner" : "";
                  //                 String rented = isRented ? "Rented" : "";
                  //                 setState(() {
                  //                   isFilter = true;
                  //                   filterMemberData.clear();
                  //                 });
                  //                 for (int i = 0; i < memberData.length; i++) {
                  //                   if (memberData[i]["Gender"] ==
                  //                           gender ||
                  //                       memberData[i]["MemberData"]
                  //                               ["ResidenceType"] ==
                  //                           owned ||
                  //                       memberData[i]["MemberData"]
                  //                               ["ResidenceType"] ==
                  //                           owner ||
                  //                       memberData[i]["MemberData"]
                  //                               ["ResidenceType"] ==
                  //                           rented) {
                  //                     print("matched");
                  //                     filterMemberData.add(memberData[i]);
                  //                   }
                  //                 }
                  //                 setState(() {});
                  //               },
                  //             );
                  //           });
                  //     },
                  //   ),
                  // ),
                  isMemberLoading
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Expanded(
                          child: isFilter
                              ? filterMemberData.length > 0
                                  ? AnimationLimiter(
                                      child: ListView.builder(
                                        padding: EdgeInsets.all(0),
                                        itemCount: filterMemberData.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return DirectoryMemberComponent(
                                              filterMemberData[index],
                                              index);
                                        },
                                      ),
                                    )
                                  : Container(
                                      child: Center(
                                          child: Text("No Member Found")),
                                    )
                              : memberData.length > 0 && memberData != null
                                  ? searchMemberData.length != 0
                                      ? AnimationLimiter(
                                          child: ListView.builder(
                                            padding: EdgeInsets.all(0),
                                            itemCount: searchMemberData.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return DirectoryMemberComponent(
                                                  searchMemberData[index],
                                                  index);
                                            },
                                          ),
                                        )
                                      : _isSearching && isfirst
                                          ? AnimationLimiter(
                                              child: ListView.builder(
                                                padding: EdgeInsets.all(0),
                                                itemCount:
                                                    searchMemberData.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return DirectoryMemberComponent(
                                                      searchMemberData[index],
                                                      index);
                                                },
                                              ),
                                            )
                                          : AnimationLimiter(
                                              child: ListView.builder(
                                                padding: EdgeInsets.all(0),
                                                itemCount: memberData.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return DirectoryMemberComponent(
                                                      memberData[index],
                                                      index);
                                                },
                                              ),
                                            )
                                  : Center(child: CircularProgressIndicator(),),
                        ),
                ],
              ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
      title: appBarTitle,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/Dashboard");
        },
      ),
      actions: <Widget>[
        new IconButton(
          icon: icon,
          onPressed: () {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _controller,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white)),
                onChanged: searchOperation,
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          },
        ),
      ],
    );
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        'Member Directory'  ,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      );
      _isSearching = false;
      isfirst = false;
      searchMemberData.clear();
      _controller.clear();
    });
  }

  void searchOperation(String searchText) {
    if (_isSearching != null) {
      searchMemberData.clear();
      setState(() {
        isfirst = true;
      });
      for (int i = 0; i < memberData.length; i++) {
        String name = memberData[i]["Name"];
        String flat = memberData[i]["FlatData"][0]["flatNo"].toString();
        String wing = memberData[i]["WingData"][0]["wingName"].toString();
        String contactNo = memberData[i]["ContactNo"].toString();
        if (name.toLowerCase().contains(searchText.toLowerCase()) ||
            flat.toLowerCase().contains(searchText.toLowerCase())  ||
            wing.toLowerCase().contains(searchText.toLowerCase())||
            contactNo.toLowerCase().contains(searchText.toLowerCase())) {
          searchMemberData.add(memberData[i]);
        }
      }
    }
  }
}

class showFilterDailog extends StatefulWidget {
  Function onSelect;

  showFilterDailog({this.onSelect});

  @override
  _showFilterDailogState createState() => _showFilterDailogState();
}

class _showFilterDailogState extends State<showFilterDailog> {
  String _gender;

  bool ownerSelect = false, rentedSelect = false, ownedSelect = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Filter Your Criteria"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Gender",
            style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Row(
              children: <Widget>[
                Radio(
                    value: 'Male',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    }),
                Text("Male", style: TextStyle(fontSize: 13)),
                Radio(
                    value: 'Female',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    }),
                Text("Female", style: TextStyle(fontSize: 13))
              ],
            ),
          ),
          Text(
            "Residential Type",
            style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600),
          ),
          Row(
            children: <Widget>[
              Checkbox(
                  activeColor: Colors.green,
                  value: ownedSelect,
                  onChanged: (bool value) {
                    setState(() {
                      ownedSelect = value;
                    });
                  }),
              Text(
                "Owned",
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Checkbox(
                  activeColor: Colors.green,
                  value: rentedSelect,
                  onChanged: (bool value) {
                    setState(() {
                      rentedSelect = value;
                    });
                  }),
              Text(
                "Rented",
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Checkbox(
                  activeColor: Colors.green,
                  value: ownerSelect,
                  onChanged: (bool value) {
                    setState(() {
                      ownerSelect = value;
                    });
                  }),
              Text(
                "Owner",
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onSelect(_gender, ownedSelect, ownerSelect, rentedSelect);
          },
          child: Text("Done"),
        )
      ],
    );
  }
}
