import 'package:flutter/material.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class MessageToWatchmanPopUp extends StatefulWidget {
  const MessageToWatchmanPopUp({Key key}) : super(key: key);

  @override
  _MessageToWatchmanPopUpState createState() => _MessageToWatchmanPopUpState();
}

class _MessageToWatchmanPopUpState extends State<MessageToWatchmanPopUp> {
    TextEditingController messageToWatchmanController = TextEditingController();
  List watchmanData = [];
  List selectedWatchmanList = [];
  List selectedWatchmanIdList = [];
  bool isLoading = false;

  @override
  void initState() {
    getAllWatchmen();
  }

  getAllWatchmen() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String societyId = prefs.getString(cnst.Session.SocietyId);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var body = {
          "societyId": societyId,
        };
        Services.responseHandler(apiName: "member/getAllWatchman", body: body)
            .then((data) async {
          if (data.Data != null && data.IsSuccess == true) {
            setState(() {
              // watchmanData = data.Data;
              for(int i=0;i<data.Data.length;i++){
                watchmanData.add({
                  "Name" : data.Data[i]["Name"],
                  "Id" : data.Data[i]["_id"],
                });
              }
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
            showMsg("$e");
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
    }
  }

  sendMessageToWatchman() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String societyId = prefs.getString(cnst.Session.SocietyId);
      String wingId = prefs.getString(cnst.Session.WingId);
      String flatId = prefs.getString(cnst.Session.FlatId);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {
          "watchmanIdList": selectedWatchmanIdList,
          "societyId": societyId,
          "wingId": wingId,
          "flatId": flatId,
          "message" : messageToWatchmanController.text
        };
        Services.responseHandler(
                apiName: "member/instantMessageToWatchman", body: body)
            .then((data) async {
          if (data.Data.toString()=="1" && data.IsSuccess == true) {
            Fluttertoast.showToast(
              msg: "Message sent to Watchman",
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            messageToWatchmanController.clear();
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
    print("watchmanData");
    print(watchmanData);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Center(child: Text("MYJINI")),
      content: isLoading == false
          ? SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Message to Watchman",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      Container(
                        height: 45,
                        width: 45,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 13.0),
                          child: Image.asset("images/loudspeaker.png"),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: DottedDecoration(
                      shape: Shape.box,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      controller: messageToWatchmanController,
                      keyboardType: TextInputType.text,
                      maxLines: 6,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Start typing here ...",
                        contentPadding: EdgeInsets.only(
                          left: 10,
                          top: 5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MultiSelectFormField(
                    autovalidate: false,
                    title: Text('Select Watchman'),
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please select one or more options';
                      }
                    },border: InputBorder.none,
                    dataSource: watchmanData,
                    textField: 'Name',
                    valueField: 'Name',
                    okButtonLabel: 'OK',
                    cancelButtonLabel: 'CANCEL',
                    hintWidget: Text('No Wing Selected'),
                    // change: () => selectedWingList,
                    onSaved: (value) {
                      selectedWatchmanList.clear();
                      selectedWatchmanIdList.clear();
                      selectedWatchmanList = value;
                      for (int i = 0; i < watchmanData.length; i++) {
                        selectedWatchmanIdList
                            .add(watchmanData[i]["Id"]);
                      }
                      print(selectedWatchmanIdList);
                    },
                  ),
                  // MultiSelectDialogField(
                  //   items: watchmanData
                  //       .map((e) => MultiSelectItem(e, e["Name"]))
                  //       .toList(),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  //   onConfirm: (values) {
                  //     selectedWatchmanList.clear();
                  //     selectedWatchmanIdList.clear();
                  //     selectedWatchmanList = values;
                  //     for (int i = 0; i < selectedWatchmanList.length; i++) {
                  //       selectedWatchmanIdList
                  //           .add(selectedWatchmanList[i]["_id"]);
                  //     }
                  //     print(selectedWatchmanIdList);
                  //   },
                  //   buttonIcon: Icon(
                  //     Icons.arrow_drop_down,
                  //     color: cnst.appPrimaryMaterialColor,
                  //   ),
                  //   buttonText: Text("Select Watchman"),
                  // ),
                ],
              ),
          )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            ),
      actions: [
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
            messageToWatchmanController.clear();
          },
        ),
        FlatButton(
          child: Text('Send'),
          onPressed: () {
            Navigator.pop(context);
            sendMessageToWatchman();
          },
        ),
      ],
    );
  }
}
