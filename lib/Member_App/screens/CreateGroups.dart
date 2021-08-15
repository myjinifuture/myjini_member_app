import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Classlist.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Member_App/screens/RegisterScreen.dart';
import 'package:smart_society_new/Member_App/screens/WingDetail.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../screens/AddMyResidents.dart';
import '../common/constant.dart';

class CreateGroups extends StatefulWidget {
  var wingData,societyId;
  String mobileNo,societyCode,Price_dropdownValue;
  bool isEdit = false;
  CreateGroups({this.wingData,this.societyId,this.mobileNo,this.societyCode,this.isEdit,this.Price_dropdownValue});
  @override
  CreateGroupsState createState() => CreateGroupsState();
}

class CreateGroupsState extends State<CreateGroups> {
  ProgressDialog pr;
  bool isLoading = false;
  String _stateDropdownError, _cityDropdownError;
  bool stateLoading = false;
  bool cityLoading = false;
 var textEditingControllers  =<TextEditingController> [];
  List<stateClass> stateClassList = [];
  stateClass _stateClass;

  List<cityClass> cityClassList = [];
  cityClass _cityClass;

  String Price_dropdownValue = 'Select';
  var filledOneWing = "";
  TextEditingController txtname = TextEditingController();
  TextEditingController txtmobile =  TextEditingController();
  TextEditingController txtwings =  TextEditingController();
  List<String> alphabets = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];

  @override
  void initState() {
    super.initState();

    alphabets[0];
    print("societyCode");
    print(widget.societyCode);
    getWingsId(widget.societyId.toString());
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
        color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600,
      ),
    );
    // getState();
  }

  bool foundOneRegisteredBuilding = false;

  List winglistClassList = [];
  var wingfilled = "";
  bool filledAtleastOneWing = false;

  getWingsId(String societyId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {
          "societyId" : widget.societyId
        };
        Services.responseHandler(apiName: "admin/getAllWingOfSociety",body: body).then((data) async {
          if (data.Data !=null) {
            setState(() {
              winglistClassList = data.Data;
            });
            for(int i=0;i<winglistClassList.length;i++){
              if(winglistClassList[i]["totalFloor"].toString()!="0"){
                wingfilled = prefs.getString('madeAtleastOneWing');
                setState(() {
                  filledAtleastOneWing = true;
                });
                break;
              }
            }
            for(var i = 0; i< winglistClassList.length; i++)
            {
              var textEditingController = new TextEditingController(text : alphabets[i]);
              textEditingControllers.add(textEditingController);
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
                Navigator.of(context).pop();;
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

  bool dataLoaded = false;

  getSocietyDetails(String societyCode) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {
          "societyCode": societyCode
        };
        Services.responseHandler(apiName: "member/getSocietyDetails",body: data).then((data) async {
          // pr.hide();
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              Fluttertoast.showToast(
                  msg: "Society Added Successfully!!!",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              print(data.Data["Society"][0]);
              print("code before register screen");
              print(data.Data["Society"][0]["societyCode"]);
              dataLoaded = true;
              if(widget.isEdit){
                Navigator.pushReplacementNamed(context, '/Dashboard');
              }
              else{
                if(dataLoaded) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RegisterScreen(
                              Name: data.Data["Society"][0]["ContactPerson"],
                              mobileNo: data
                                  .Data["Society"][0]["ContactMobile"],
                              societyCode: data
                                  .Data["Society"][0]["societyCode"],
                              societyId: widget.societyId,
                              societyNameAndSocietyAddress: data
                                  .Data["Society"][0]["Name"] + " ," + data
                                  .Data["Society"][0]["Address"]
                          ),
                    ),
                  );
                }
              }
              // Clipboard.setData(new ClipboardData(text: widget.societyCode));
            });
          } else {
            setState(() {
              Fluttertoast.showToast(
                  msg: "Please submit details of atleast one wing",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showHHMsg("Try Again.", "");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
    }
  }

  createNewWing(String name) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var wingId = prefs.getString(Session.WingId);
      print("print wingId..........................");
      print(wingId);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // pr.show();
        var data = {
          "societyId" : widget.societyId,
          "wingId" : wingId,
          "wingName" : name,
          "isSetUp": true
        };
        print(data);
        Services.responseHandler(apiName: "admin/updateCommunity",body: data).then((data) async {
          if (data.IsSuccess == true) {
            if(widget.isEdit) {
              Fluttertoast.showToast(
                msg: "Community Details Updated Successfully",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP,
                textColor: Colors.white,
              );
            }
            else{
              print("success");
              prefs.setString('madeAtleastOneWing', "true");
              Fluttertoast.showToast(
                msg: "Group Details Added Successfully",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP,
                textColor: Colors.white,
              );
              print("code before setupwings screen");
              print(widget.societyCode);
            }
            Navigator.pop(context);
            // formatGrid();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Setup Groups"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Setup any Groups and you will be on dashboard screen.",style: TextStyle(color:cnst.appPrimaryMaterialColor),),
                  ),
                  StaggeredGridView.countBuilder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 4,
                      //itemCount: int.parse(widget.wingData),
                      itemCount: int.parse(widget.wingData),
                      staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                      itemBuilder: (BuildContext context, int index) {
                        return winglistClassList.length == 0 ? Center(
                          child: CircularProgressIndicator(),
                        ) : GestureDetector(
                          onTap: () {
                            if(winglistClassList[index]["totalFloor"].toString()!="0"){
                              Fluttertoast.showToast(
                                  msg: "Details Already Found!!",
                                  backgroundColor: Colors.green,
                                  gravity: ToastGravity.TOP);
                            }
                            // Navigator.pushNamed(context, "/WingDetail");
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                elevation: 8,
                                borderOnForeground: true,
                                color: widget.isEdit != false ? Colors.green : Colors.grey[200],
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: TextFormField(
                                    controller: textEditingControllers[index],
                                    decoration: InputDecoration(
                                      labelText: "Group Name",
                                      isDense: true,
                                      hintText: "Group Name",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              child: FlatButton(
                height: 45,
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  print(prefs.getString('madeAtleastOneWing'));
                  prefs.getString('madeAtleastOneWing') == "true" ?
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             AddMyResidents(
                  //               mobileNo:widget.mobileNo,
                  //               isUpdate : true
                  //             ),
                  //     ),
                  // ):
                  Navigator.pushReplacementNamed(context, '/RegisterScreen')
                      :
                  Fluttertoast.showToast(
                      msg: "Please Submit Details of atleast 1 Groups",
                      backgroundColor: Colors.red,
                      gravity: ToastGravity.TOP,
                      textColor: Colors.white);
                  print(foundOneRegisteredBuilding);
                },
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap:() {
                        createNewWing(textEditingControllers.toString());
                          // print(widget.societyCode);
                        // pr.show();
                        //getSocietyDetails(widget.societyCode);
                      },
                      child: Text(
                        "Finish Setup",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                color: constant.appPrimaryMaterialColor,
                textColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}