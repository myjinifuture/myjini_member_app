import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/WingFlat.dart';
import '../common/Services.dart';
import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WingDetail extends StatefulWidget {
  var wingName,wingId,societyId,societyCode,noOfWings,mobileNo;
  bool isEdit = false;
  WingDetail({this.wingName,this.wingId,this.societyId,this.societyCode,this.noOfWings,this.mobileNo,this.isEdit});
  @override
  _WingDetailState createState() => _WingDetailState();
}

class _WingDetailState extends State<WingDetail> {
  int _currentindex;
  ProgressDialog pr;
  List<List<String>> format = [
    ["301", "302", "303", "201", "202", "203", "101", "102", "103"],
    ["7", "8", "9", "4", "5", "6", "1", "2", "3"],
    ["201", "202", "203", "101", "102", "103", "G1", "G2", "G3"],
    ["4", "5", "6", "1", "2", "3", "G1", "G2", "G3"],
    ["103", "203", "303", "102", "202", "302", "101", "201", "301"],
    ["3A", "3B", "3C", "2A", "2B", "2C", "1A", "1B", "1C"],
    ["C3", "C2", "C1", "B3", "B2", "B1", "A3", "A2", "A1"],
  ];
  TextEditingController txtname = new TextEditingController();
  TextEditingController txtfloor = new TextEditingController();
  TextEditingController txtUnit = new TextEditingController();
  TextEditingController txtParkingSlots = new TextEditingController();
  bool isLoading=false;
  List wingDetails=[];
  List finalWingDetails=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getWingDetails();

    print(widget.societyId);
    print(widget.wingId);
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
  }

  _getWingDetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String societyId = prefs.getString(constant.Session.SocietyId);
        var data = {
          "societyId" : societyId,
        };
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "admin/getAllWingOfSociety",body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              for(int i=0;i<data.Data.length;i++){
                if(data.Data[i]["totalFloor"].toString()!="0"){
                  wingDetails.add(data.Data[i]);
                }
              }
              // wingDetails=data.Data;
            });
            for(int i=0;i<wingDetails.length;i++){
              if(wingDetails[i]['wingName']==widget.wingName){
                finalWingDetails.add(wingDetails[i]);
              }
            }
            setState(() {
              txtname.text=(finalWingDetails[0]['wingName'].toString()==null||finalWingDetails[0]['wingName'].toString()=='')?'':finalWingDetails[0]['wingName'].toString();
              txtfloor.text=(finalWingDetails[0]['totalFloor'].toString()==null||finalWingDetails[0]['totalFloor'].toString()=='')?'':finalWingDetails[0]['totalFloor'].toString();
              txtUnit.text=(finalWingDetails[0]['maxFlatPerFloor'].toString()==null||finalWingDetails[0]['maxFlatPerFloor'].toString()=='')?'':finalWingDetails[0]['maxFlatPerFloor'].toString();
            });
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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("yes");
  }

  List<TextEditingController> _optionList = [];

  Widget setupAlertDialoadContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0,
      child: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            itemCount: _optionList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 45,
                margin: EdgeInsets.only(
                    top: 5, left: 5, right: 5),
                child: TextFormField(
                  controller: _optionList[index],
                  scrollPadding: EdgeInsets.all(0),
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.black),
                          borderRadius: BorderRadius.all(
                              Radius.circular(10))),
                      hintText: "Option ${index + 1}",
                      hintStyle: TextStyle(
                        fontSize: 13,
                      )),
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.black),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: RaisedButton(
              elevation: 3,
              onPressed: () {
                Navigator.of(context).pop();;
              },
              color: constant.appPrimaryMaterialColor,
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController txtOption =
  new TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("finalWingDetails");
    print(finalWingDetails);
    return Scaffold(
      appBar: AppBar(
        title: Text("Wing - " + widget.wingName),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
            child: Row(
              children: <Widget>[
                Text("Name",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
            child: SizedBox(
              height: 50,
              child: TextFormField(
                validator: (value) {
                  if (value.trim() == "") {
                    return 'Please Enter Name';
                  }
                  return null;
                },
                controller: txtname,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide: new BorderSide(),
                    ),
                    // labelText: "Enter Name",
                    hintText: 'Enter Name',
                    hintStyle: TextStyle(fontSize: 13)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
            child: Row(
              children: <Widget>[
                Text("Total Floor",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
            child: SizedBox(
              height: 50,
              child: TextFormField(
                validator: (value) {
                  if (value.trim() == "" || value.length < 10) {
                    return 'Please Enter Total Floor';
                  }
                  return null;
                },
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: txtfloor,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    counterText: "",
                    fillColor: Colors.grey[200],
                    contentPadding:
                    EdgeInsets.only(top: 5, left: 10, bottom: 5),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(width: 0, color: Colors.black)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 0, color: Colors.black)),
                    hintText: 'Enter Total Floor',
                    // labelText: "Total Floor",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
            child: Row(
              children: <Widget>[
                Text("Flats Per Floor",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
            child: SizedBox(
              height: 50,
              child: TextFormField(
                validator: (value) {
                  if (value.trim() == "" || value.length < 10) {
                    return 'Please Enter Maximum Unit';
                  }
                  return null;
                },
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: txtUnit,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    counterText: "",
                    fillColor: Colors.grey[200],
                    contentPadding:
                    EdgeInsets.only(top: 5, left: 10, bottom: 5),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(width: 0, color: Colors.black)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 0, color: Colors.black)),
                    hintText: 'Enter Maximum Units',
                    // labelText: "Maximum Units",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Choose Number Format",
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]))
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  itemCount: format.length,
                  staggeredTileBuilder: (_) => StaggeredTile.fit(1),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentindex = index;
                          });
                          print("wing select-> " + _currentindex.toString());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                              _currentindex == index ? Border.all() : null),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                  .appPrimaryMaterialColor[
                                              500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][0]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                  .appPrimaryMaterialColor[
                                              500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][1]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                  .appPrimaryMaterialColor[
                                              500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][2]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                  .appPrimaryMaterialColor[
                                              500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][3]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                  .appPrimaryMaterialColor[
                                              500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][4]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                  .appPrimaryMaterialColor[
                                              500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][5]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                  .appPrimaryMaterialColor[
                                              500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][6]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                  .appPrimaryMaterialColor[
                                              500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][7]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                  .appPrimaryMaterialColor[
                                              500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][8]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  }),
            ),
          ),
          // RaisedButton(
          //   elevation: 3,
          //   onPressed: () {
          //     if(txtUnit.text == "" || txtUnit.text == null){
          //       Fluttertoast.showToast(
          //           msg: "Please Select Flats Per Floor First",
          //           backgroundColor: Colors.red,
          //           gravity: ToastGravity.TOP,
          //           textColor: Colors.white);
          //     }
          //     else{
          //       _optionList.clear();
          //       for (int i = 0; i < int.parse(txtUnit.text); i++) {
          //         _optionList.add(txtOption);
          //       }
          //       print("_optionList");
          //       print(_optionList);
          //       print(txtUnit.text.length);
          //       showDialog(
          //           context: context,
          //           builder: (BuildContext context) {
          //             return AlertDialog(
          //               title: Text('Select Number Sequence per Floor'),
          //               content: setupAlertDialoadContainer(),
          //             );
          //           });
          //       // showTextField(txtUnit : txtUnit.text);
          //       // showDialog(
          //       //   context: context,
          //       //   builder: (BuildContext context) => showTextField(txtUnit : txtUnit.text),
          //       //
          //       //
          //       // );
          //     }
          //     // Navigator.pushNamed(context, '/AllRemindersScreen');
          //   },
          //   color: constant.appPrimaryMaterialColor,
          //   child: Text(
          //     'Create Custom',
          //     style: TextStyle(
          //       color: Colors.white,
          //     ),
          //   ),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 45,
        child: RaisedButton(
          shape: RoundedRectangleBorder(),
          color: constant.appPrimaryMaterialColor,
          textColor: Colors.white,
          splashColor: Colors.white,
          child: Text("Create",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          onPressed: () {
            print("laugh");
            if(txtname.text==""){
              Fluttertoast.showToast(
                  msg: "Please Fill All Details",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
            }
            else{
              print("navigate");
              print("code before wingflat screen");
              print(widget.societyCode);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => WingFlat(
                    floorData: txtfloor.text,
                    maxUnitData: txtUnit.text,
                    formatData: _currentindex,
                    societyId: widget.societyId,
                    wingId: widget.wingId,
                    wingName: txtname.text,
                    parkingSlots:txtParkingSlots.text,
                    noOfWings:widget.noOfWings,
                    mobileNo:widget.mobileNo,
                    isEdit:widget.isEdit,
                    societyCode:widget.societyCode
                ),
              ));
              // createNewWing(txtname.text, txtfloor.text, txtUnit.text, widget.wingId, widget.societyId,txtParkingSlots.text);
            }
            // Navigator.pushNamed(context, '/WingFlat');
          },
        ),
      ),
    );
  }
}

class showTextField extends StatefulWidget {
  String txtUnit;
  showTextField({this.txtUnit});
  @override
  _showTextFieldState createState() => _showTextFieldState();
}

class _showTextFieldState extends State<showTextField> {

  List<TextEditingController> _optionList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i <
        widget.txtUnit.length; i++) {
      TextEditingController txtOption =
      new TextEditingController();
      _optionList.add(txtOption);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("widget.txtUnit.length");
    print(widget.txtUnit.length);
    return AlertDialog(
      title: new Text("Delete Confirmation"),
      content: new Container(
        height: 50.0 * widget.txtUnit.length,
        child: ListView.builder(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          itemCount: widget.txtUnit.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 45,
              margin: EdgeInsets.only(
                  top: 5, left: 5, right: 5),
              child: TextFormField(
                controller: _optionList[index],
                scrollPadding: EdgeInsets.all(0),
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Colors.black),
                        borderRadius: BorderRadius.all(
                            Radius.circular(10))),
                    hintText: "Option ${index + 1}",
                    hintStyle: TextStyle(
                      fontSize: 13,
                    )),
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
              ),
            );
          },
        ),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text("Ok"),
          onPressed: () {
            // DeleteOffer();
            Navigator.of(context).pop();;
          },
        ),
        new FlatButton(
          child: new Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();;
          },
        ),
      ],
    );
  }
}
