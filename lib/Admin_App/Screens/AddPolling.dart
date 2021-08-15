import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart';
import '../../Member_App/./common/constant.dart' as constant;
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import '../../Member_App/./common/Services.dart';
import 'package:dio/dio.dart';

class AddPolling extends StatefulWidget {
  var question,wings,polloptions,Id;
  Function onUpdate;

  AddPolling({this.question,this.wings,this.polloptions,this.Id,this.onUpdate});

  @override
  _AddPollingState createState() => _AddPollingState();
}

class _AddPollingState extends State<AddPolling> {
  TextEditingController txtQuestion = new TextEditingController();
  TextEditingController txtOptionCount = new TextEditingController();

  bool isLoading = false;
  bool disableSubmitPolling;

  String _pollingId = "";

  ProgressDialog pr;

  int _enteredCount = 0;

  List<TextEditingController> _optionList = [];

  @override
  void initState() {
    print(widget.question);
    print(widget.wings);
    print(widget.polloptions);
    disableSubmitPolling=false;
    getLocaldata();
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
    if(widget.question!=null) {
      setState(() {
        txtQuestion.text = widget.question;
        txtOptionCount.text = widget.polloptions.length.toString();
        _enteredCount = widget.polloptions.length;
        print("_optionList");
        print(_optionList);
        for (int i = 0; i < widget.polloptions.length; i++) {
          // _optionList[i].text = widget.polloptions[i]["pollOption"];
          TextEditingController txtOption =
          new TextEditingController();
          txtOption.text = widget.polloptions[i]["pollOption"];
          _optionList.add(txtOption);
        }
      });
    }
  }

  String societyId,memberId;
  getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      societyId = prefs.getString(constant.Session.SocietyId);
    memberId = prefs.getString(constant.Session.Member_Id);
    getWingsId(societyId);
    print("memberId");
    print(memberId);
  }

  List optionsData =[];
  _createPolling() async {
    if (txtQuestion.text != "") {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          optionsData.clear();
          for (int i = 0; i < _enteredCount; i++) {
            optionsData.add(_optionList[i].text);
          }
          selectedWingId.clear();
          for (int i = 0; i < selectedWing.length; i++) {
            for(int j=0;j<wingsNameData.length;j++){
              if(selectedWing[i].toString() == wingsNameData[j]["Name"].toString()){
                selectedWingId.add(wingsNameData[j]["Id"].toString());
              }
            }
          }
          var data,apiName;
          if(widget.question!=null){
            apiName = "admin/updatePollQuestion_v1";
            data =
              {
                "pollQuesId": widget.Id,
                "pollQuestion": txtQuestion.text,
                "pollOption": optionsData.toString()
                    .replaceAll(" ", "").replaceAll("[", "")
                    .replaceAll("]", ""),
              };
          }
          else {
            apiName = "admin/addPollingQuestion_v2";
            data = {
              "pollQuestion": txtQuestion.text,
              "societyId": societyId,
              "adminId": memberId,
              "pollOption": optionsData.toString()
                  .replaceAll(" ", "")
                  .replaceAll("[", "")
                  .replaceAll("]", ""),
              "wingIds": selectedWingId.toString()
                  .replaceAll(" ", "")
                  .replaceAll("[", "")
                  .replaceAll("]", "")
            };
          }
          print("data");
          print(data);
          FormData data1;
            data1 = FormData.fromMap(data);
          print(apiName);
          // pr.show();
          // pr.show();
          if(widget.question!=null){
            Services.responseHandler(apiName: apiName,body: data1).then((data) async {
              // pr.hide();
              print("data.message");
              print(data.Message);
              if (data.Data.toString() =="1" && data.IsSuccess == true) {
                  Fluttertoast.showToast(
                      msg: "Polling Updated Successfully",
                      backgroundColor: Colors.green,
                      gravity: ToastGravity.TOP,
                      textColor: Colors.white);
                  Navigator.pop(context);
                  widget.onUpdate();
              } else {
                Fluttertoast.showToast(
                    msg: "Polling Saved Successfully",
                    backgroundColor: Colors.green,
                    gravity: ToastGravity.TOP,
                    textColor: Colors.white);
                Navigator.pop(context);
                // pr.hide();
                // showMsg(data.Message, title: "Error");
              }
            }, onError: (e) {
              // pr.hide();
              showMsg("Try Again.");
            });
          }
          else{
            Services.responseHandler(apiName: apiName,body: data1).then((data) async {
              // pr.hide();
              print("data.message");
              print(data.Message);
              if (data.Data.toString() =="1" && data.IsSuccess == true) {
                  Fluttertoast.showToast(
                      msg: "Polling Saved Successfully",
                      backgroundColor: Colors.green,
                      gravity: ToastGravity.TOP,
                      textColor: Colors.white);
                Navigator.pushReplacementNamed(context, "/AllPolling");
              } else {
                Fluttertoast.showToast(
                    msg: "Polling Saved Successfully",
                    backgroundColor: Colors.green,
                    gravity: ToastGravity.TOP,
                    textColor: Colors.white);
                Navigator.pushReplacementNamed(context, "/AllPolling");
                // pr.hide();
                // showMsg(data.Message, title: "Error");
              }
            }, onError: (e) {
              // pr.hide();
              showMsg("Try Again.");
            });
          }
        }
      } on SocketException catch (_) {
        // pr.hide();
        showMsg("No Internet Connection.");
      }
    } else
      Fluttertoast.showToast(
          msg: "Please Select All Fields",
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP,
          textColor: Colors.white);
  }

  // _editPolling() async {
  //   if (txtQuestion.text != "") {
  //     try {
  //       final result = await InternetAddress.lookup('google.com');
  //       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //         var formData = {
  //           "Id": "$_pollingId",
  //           "Title": txtQuestion.text,
  //         };
  //
  //         // pr.show();
  //         Services.UpdatePolling(formData).then((data) async {
  //           // pr.hide();
  //           if (data.Data != "0" && data.IsSuccess == true) {
  //             setState(() {
  //               _pollingId = data.Data;
  //             });
  //             Fluttertoast.showToast(
  //                 msg: "Create Your Options", gravity: ToastGravity.TOP);
  //           } else {
  //             // pr.hide();
  //             showMsg(data.Message, title: "Error");
  //           }
  //         }, onError: (e) {
  //           // pr.hide();
  //           showMsg("Try Again.");
  //         });
  //       }
  //     } on SocketException catch (_) {
  //       // pr.hide();
  //       showMsg("No Internet Connection.");
  //     }
  //   } else
  //     Fluttertoast.showToast(
  //         msg: "Please Select All Fields",
  //         backgroundColor: Colors.red,
  //         gravity: ToastGravity.TOP,
  //         textColor: Colors.white);
  // }

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
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

  List wingsNameData = [];
  List selectedWingId = [];
  List wingsList = [];
  List selectedWing = [];

  getWingsId(String societyId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {
          "societyId" : societyId
        };
        Services.responseHandler(apiName: "admin/getAllWingOfSociety",body: body).then((data) async {
          if (data !=null) {
            setState(() {
              for(int i=0;i<data.Data.length;i++){
                if(data.Data[i]["totalFloor"].toString()!="0"){
                  wingsList.add(data.Data[i]);
                }
              }
              for(int i=0;i<wingsList.length;i++){
                wingsNameData.add({
                  "Name" : wingsList[i]["wingName"],
                  "Id" : wingsList[i]["_id"],
                });
              }
            });
            if(widget.question!=null){
              setState(() {
                for(int i=0;i<wingsNameData.length;i++){
                  for(int j=0;j<widget.wings.length;j++){
                    if(wingsNameData[i]["Id"] == widget.wings[j]){
                      selectedWing.add(wingsNameData[i]["Name"]);
                    }
                  }
                }
                print("selectedWing");
                print(selectedWing);
              });
            }
          }
        }, onError: (e) {
          showMsg("$e");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/AllPolling");
      },
      child: Scaffold(
        appBar: AppBar(
          title: widget.question!=null ? Text(
            "Update Polling",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ):Text(
            "Add Polling",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/AllPolling");
            },
          ),
        ),
        body: isLoading
            ? LoadingComponent()
            : SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: txtQuestion,
                              scrollPadding: EdgeInsets.all(0),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  prefixIcon: Icon(
                                    Icons.title,
                                  ),
                                  hintText: "Ask Question"),
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: MultiSelectFormField(
                          autovalidate: false,
                          title: Text('Select Wing'),
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return 'Please select one or more options';
                            }
                          },
                          dataSource: wingsNameData,
                          textField: 'Name',
                          valueField: 'Name',
                          okButtonLabel: 'OK',
                          cancelButtonLabel: 'CANCEL',
                          hintWidget: widget.question==null ? Text('No Wing Selected'):Text(selectedWing.toString()),
                          change: () => selectedWing,
                          onSaved: (value) {
                            setState(() {
                              selectedWing = value;
                            });
                          },
                        ),
                      ),
                      Card(
                              margin: EdgeInsets.only(top: 8),
                              child: Container(
                                padding: EdgeInsets.all(7),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "How many Options ?",
                                      style: TextStyle(
                                          color: cnst.appPrimaryMaterialColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          width: 200,
                                          height: 50,
                                          margin: EdgeInsets.only(top: 8),
                                          child: TextFormField(
                                            controller: txtOptionCount,
                                            scrollPadding: EdgeInsets.all(0),
                                            decoration: InputDecoration(
                                                border: new OutlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                prefixIcon: Icon(
                                                  Icons.equalizer,
                                                ),
                                                hintText: "Enter Numbers",
                                                hintStyle:
                                                    TextStyle(fontSize: 12)),
                                            keyboardType: TextInputType.number,
                                            style:
                                                TextStyle(color: Colors.black),
                                            onChanged: (val){
                                              if(txtOptionCount.text.length==0){
                                                setState(() {
                                                  _enteredCount =
                                                      0;
                                                });
                                              }
                                              else if(txtOptionCount.text.length > 4){
                                                Fluttertoast.showToast(
                                                    msg: "Not permitted",
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    gravity: ToastGravity.TOP);
                                                setState(() {
                                                  txtOptionCount.text="";
                                                });
                                              }
                                              else {
                                                setState(() {
                                                  _enteredCount =
                                                      int.parse(val);
                                                });
                                                print(_enteredCount);
                                                for (int i = 0; i <
                                                    _enteredCount; i++) {
                                                  TextEditingController txtOption =
                                                  new TextEditingController();
                                                  _optionList.add(txtOption);
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                        // _enteredCount > 0
                                        //     ? Container(
                                        //         height: 40,
                                        //         width: 70,
                                        //         decoration: BoxDecoration(
                                        //             borderRadius:
                                        //                 BorderRadius.all(
                                        //                     Radius.circular(
                                        //                         10))),
                                        //         child: MaterialButton(
                                        //           shape: RoundedRectangleBorder(
                                        //               borderRadius:
                                        //                   new BorderRadius
                                        //                       .circular(10.0)),
                                        //           color: cnst
                                        //               .appPrimaryMaterialColor,
                                        //           onPressed: () {
                                        //             setState(() {
                                        //               _enteredCount = int.parse(
                                        //                   txtOptionCount.text);
                                        //             });
                                        //             print(_enteredCount);
                                        //             for (int i = 0;
                                        //                 i < _enteredCount;
                                        //                 i++) {
                                        //               TextEditingController
                                        //                   txtOption =
                                        //                   new TextEditingController();
                                        //               _optionList
                                        //                   .add(txtOption);
                                        //             }
                                        //           },
                                        //           child: Text(
                                        //             "Edit",
                                        //             style: TextStyle(
                                        //                 color: Colors.white,
                                        //                 fontSize: 14.0,
                                        //                 fontWeight:
                                        //                     FontWeight.w600),
                                        //           ),
                                        //         ),
                                        //       )
                                        //     : Container()
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      _enteredCount > 0
                          ? Container(
                              height: 50.0 * _enteredCount,
                              child: ListView.builder(
                                padding: EdgeInsets.all(0),
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _enteredCount,
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
                            )
                          : Container(),
                     // Padding(
                     //          padding: EdgeInsets.only(top: 20),
                     //          child: RaisedButton(
                     //            onPressed: () {
                     //              // _createPollingQuation();
                     //              /*setState(() {
                     //                _pollingId = "1";
                     //              });*/
                     //            },
                     //            color: appPrimaryMaterialColor[700],
                     //            textColor: Colors.white,
                     //            shape: StadiumBorder(),
                     //            padding: EdgeInsets.symmetric(
                     //                horizontal: 20, vertical: 10),
                     //            child: Row(
                     //              mainAxisAlignment: MainAxisAlignment.center,
                     //              children: <Widget>[
                     //                Icon(
                     //                  Icons.save,
                     //                  size: 25,
                     //                ),
                     //                Padding(
                     //                  padding: const EdgeInsets.only(left: 10),
                     //                  child: Text(
                     //                    "Create Polling",
                     //                    style: TextStyle(
                     //                      fontSize: 17,
                     //                      fontWeight: FontWeight.w600,
                     //                    ),
                     //                  ),
                     //                )
                     //              ],
                     //            ),
                     //          ),
                     //        ),
                     //      Padding(
                     //              padding: EdgeInsets.only(top: 20),
                     //              child: RaisedButton(
                     //                onPressed: () {
                     //                  setState(() {
                     //                    _enteredCount =
                     //                        int.parse(txtOptionCount.text);
                     //                  });
                     //                  print(_enteredCount);
                     //                  for (int i = 0; i < _enteredCount; i++) {
                     //                    TextEditingController txtOption =
                     //                        new TextEditingController();
                     //                    _optionList.add(txtOption);
                     //                  }
                     //                },
                     //                color: appPrimaryMaterialColor[700],
                     //                textColor: Colors.white,
                     //                shape: StadiumBorder(),
                     //                padding: EdgeInsets.symmetric(
                     //                    horizontal: 20, vertical: 10),
                     //                child: Row(
                     //                  mainAxisAlignment:
                     //                      MainAxisAlignment.center,
                     //                  children: <Widget>[
                     //                    Icon(
                     //                      Icons.save,
                     //                      size: 25,
                     //                    ),
                     //                    Padding(
                     //                      padding:
                     //                          const EdgeInsets.only(left: 10),
                     //                      child: Text(
                     //                        "Create Options",
                     //                        style: TextStyle(
                     //                          fontSize: 17,
                     //                          fontWeight: FontWeight.w600,
                     //                        ),
                     //                      ),
                     //                    )
                     //                  ],
                     //                ),
                     //              ),
                     //            ),
                               Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: RaisedButton(
                                    onPressed: disableSubmitPolling==false?() {
                                      // setState(() {
                                      //   disableSubmitPolling=true;
                                      // });
                                      print("pressed");
                                      bool isRight = true;
                                      for (int i = 0; i < _enteredCount; i++) {
                                        if (_optionList[i].text == "") {
                                          isRight = false;
                                        }
                                      }
                                      print("value of isRgith");
                                      print(isRight);
                                      if (isRight) {
                                        _createPolling();
                                      }else
                                        Fluttertoast.showToast(
                                            msg: "Please Fill All The Options",
                                            gravity: ToastGravity.TOP);
                                    }:null,
                                    color: appPrimaryMaterialColor[700],
                                    textColor: Colors.white,
                                    shape: StadiumBorder(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.save,
                                          size: 25,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: widget.question!=null ? Text(
                                            "Update Polling",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ):Text(
                                            "Submit Polling",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),

                                  ),
                                )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
