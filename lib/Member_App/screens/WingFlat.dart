import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/Services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import '../common/constant.dart';
import 'SetupWings.dart';

class WingFlat extends StatefulWidget {
  var floorData, maxUnitData, formatData,wingName,wingId,societyId,parkingSlots,noOfWings,mobileNo,societyCode;
  bool isEdit = false;

  WingFlat({this.floorData, this.formatData, this.maxUnitData,this.wingName,this.wingId,
    this.societyId,this.parkingSlots,this.noOfWings,this.mobileNo,this.isEdit,this.societyCode});

  @override
  _WingFlatState createState() => _WingFlatState();
}

class _WingFlatState extends State<WingFlat> {
  Color color1;
  int rowscolumn = 0;
  List colors = [];
  bool allchecked = false;
  bool isSubmitPressed = false;
  List<String> alphabets = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];


  List flatList = [];
  ProgressDialog pr;
  List flatColorsList = [
    constant.appPrimaryMaterialColor[500],
    Colors.grey,
    Colors.orange,
    Colors.black,
    Colors.blueAccent,
  ];

  @override
  void initState() {
    rowscolumn = int.parse(widget.floorData) * int.parse(widget.maxUnitData);
    color1 = constant.appPrimaryMaterialColor;
    getFlatIds(widget.societyId,widget.wingId);
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    print(constant.appPrimaryMaterialColor);
    /*for (int i = 0; i < rowscolumn; i++) {
      colors.add(color1);
    }*/
    formatGrid();
  }

  formatGrid() {
    flatList.clear();
    print("flatColorsList");
    print(flatColorsList[0].runtimeType);
    if (widget.formatData == 1) {
      int flatCount = 1;
      for (int i = 0; i < int.parse(widget.floorData); i++) {
        for (int j = 0; j < int.parse(widget.maxUnitData); j++) {
          flatList.add({
            'flatTypeColor': flatColorsList[0],
            'flatNumber': flatCount,
            "FlatType" : "",
          });
          flatCount++;
        }
      }
    } else if (widget.formatData == 0) {
      int flatCount = 101;
      for (int i = 0; i < int.parse(widget.floorData); i++) {
        for (int j = 0; j < int.parse(widget.maxUnitData); j++) {
          flatList.add({
            'flatTypeColor': flatColorsList[0],
            'flatNumber': flatCount,
            "FlatType" : "",
          });
          flatCount++;
        }
        flatCount = flatCount + 100 - int.parse(widget.maxUnitData);
      }
    } else if (widget.formatData == 2) {
      int flatCount = 1;
      for (int i = 0; i < int.parse(widget.floorData); i++) {
        for (int j = 0; j < int.parse(widget.maxUnitData); j++) {
          if (i == 0) {
            flatList.add({
              'flatTypeColor': flatColorsList[0],
              'flatNumber': "G" + flatCount.toString(),
              "FlatType" : "",
            });
          } else {
            flatList.add({
              'flatTypeColor': flatColorsList[0],
              'flatNumber': flatCount,
              "FlatType" : "",
            });
          }
          flatCount++;
          print("================bb");
          print(flatCount);
        }
        flatCount = flatCount + 100 - int.parse(widget.maxUnitData);
      }
    } else if (widget.formatData == 3) {
      int flatCount = 1;
      int flatCountG = 1;
      for (int i = 0; i < int.parse(widget.floorData); i++) {
        for (int j = 0; j < int.parse(widget.maxUnitData); j++) {
          if (i == 0) {
            flatList.add({
              'flatTypeColor': flatColorsList[0],
              'flatNumber': "G" + flatCountG.toString(),
              "FlatType" : "",
            });
            flatCountG++;
          } else {
            flatList.add({
              'flatTypeColor': flatColorsList[0],
              'flatNumber': flatCount,
              "FlatType" : "",
            });
            flatCount++;
          }
          print("================aaaa");
          print(flatCount);
        }
        print("================");
        print(flatCount);
      }
    } else if (widget.formatData == 4) {
      int flatCount = 101;
      for (int i = 0; i < int.parse(widget.floorData); i++) {
        for (int j = 0; j < int.parse(widget.maxUnitData); j++) {
          print("================");
          print(flatCount);
          flatList.add({
            'flatTypeColor': flatColorsList[0],
            'flatNumber': flatCount,
            "FlatType" : "",
          });
          //flatCount++;
          flatCount += 100;
          print("================bb");
          print(flatCount);
        }
        flatCount = flatCount + 1 - int.parse(widget.maxUnitData) * 100;
      }
    }
    else if (widget.formatData == 5) {
      int flatCount = 1;
      int countOfAlphabet = 0;
      for (int i = 0; i < int.parse(widget.floorData); i++) {
        for (int j = 0; j < int.parse(widget.maxUnitData); j++) {
          print("================");
          print(flatCount);
          flatList.add({
            'flatTypeColor': flatColorsList[0],
            'flatNumber': flatCount.toString() + "${alphabets[countOfAlphabet]}",
            "FlatType" : "",
          });
          countOfAlphabet+=1;
          //flatCount++;
          print("================bb");
          print(flatCount);
        }
        countOfAlphabet = 0;
        flatCount+=1;
      }
    }
    else if (widget.formatData == 6) {
      int flatCount = 1;
      int countOfAlphabet = 0;
      for (int i = 0; i < int.parse(widget.floorData); i++) {
        for (int j = 0; j < int.parse(widget.maxUnitData); j++) {
          print("================");
          print(flatCount);
          flatList.add({
            'flatTypeColor': flatColorsList[0],
            'flatNumber': "${alphabets[countOfAlphabet]}" + flatCount.toString() ,
            "FlatType" : "",
          });
          flatCount++;
          print("================bb");
          print(flatCount);
        }
        countOfAlphabet+=1;
        flatCount=1;
      }
    }
  }

  List flatnoAndType = [];

  getFloorAndFlat() {
    return GridView.count(
        crossAxisCount: int.parse(widget.maxUnitData),
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 8.0,
        children: List.generate(flatList.length, (index) {
          return GestureDetector(
            onTap: () {
              changeColor(index: index,flatno : flatList[index]["flatNumber"]);
            },
            child: Container(
              height: MediaQuery.of(context).size.width /
                  int.parse(widget.maxUnitData),
              width: MediaQuery.of(context).size.width /
                  int.parse(widget.maxUnitData),
              color: flatList[index]["flatTypeColor"],
              alignment: Alignment.center,
              margin: EdgeInsets.all(5),
              child: Text(
                "${flatList[index]["flatNumber"]}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }));

    // int flatNo = 1;
    //
    // List<Widget> columnList = [];
    // for (int i = 0; i < int.parse(widget.floorData); i++) {
    //   List<Widget> rowList = [];
    //   for (int j = 0; j < int.parse(widget.maxUnitData); j++) {
    //     rowList.add(
    //       Flexible(
    //         child: GestureDetector(
    //           onTap: () {
    //             changeColor();
    //           },
    //           child: Container(
    //             height: MediaQuery.of(context).size.width /
    //                 int.parse(widget.maxUnitData),
    //             width: MediaQuery.of(context).size.width /
    //                 int.parse(widget.maxUnitData),
    //             color: color1,
    //             alignment: Alignment.center,
    //             margin: EdgeInsets.all(5),
    //             child: Text(
    //               "$flatNo",
    //               style: TextStyle(color: Colors.white),
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //     flatNo++;
    //   }
    //   columnList.add(Row(children: rowList));
    // }
    // return columnList;
  }

  changeColor({int index,var flatno}) {
    setState(() {
      int colorIndex = flatColorsList.indexOf(flatList[index]["flatTypeColor"]);
      if (colorIndex <= 3){
        flatList[index]["flatTypeColor"] = flatColorsList[colorIndex + 1];
        print(flatList[index]["flatTypeColor"]);

      }
      else{
        flatList[index]["flatTypeColor"] = flatColorsList[0];
        print(flatList[index]["flatTypeColor"]);

      }
    });

    // if(flatnoAndType.length == 0){
    //     flatnoAndType.add({
    //       "flatno": flatno,
    //       "colortype" : flatList[index]["flatTypeColor"]
    //     });
    //   }
    //   else{
    //     for(int i=0;i<flatnoAndType.length;i++){
    //       print(flatnoAndType[i]["flatno"]);
    //       print(flatno);
    //       if(flatnoAndType[i]["flatno"] == flatno){
    //         print("Yes flatno is repeated");
    //         print(flatList[index]["flatTypeColor"]);
    //         flatnoAndType[i]["colortype"] = flatList[index]["flatTypeColor"].toString();
    //       }
    //       else{
    //         flatnoAndType.add({
    //           "flatno": flatno,
    //           "colortype" : flatList[index]["flatTypeColor"]
    //         });
    //       }
    //     }
    //   }
    // print("flatnoAndType");
    // print(flatnoAndType);
  }

  /*changeColor({int index}) {
    setState(() {
      if (colors[index] == constant.appPrimaryMaterialColor) {
        // color1 = Colors.grey;
        colors[index] = Colors.grey;
      } else if (colors[index] == Colors.grey) {
        // color1 = Colors.orange;
        colors[index] = Colors.orange;
      } else if (colors[index] == Colors.orange) {
        // color1 = Colors.black;
        colors[index] = Colors.black;
      } else if (colors[index] == Colors.black) {
        // color1 = Colors.blueAccent;
        colors[index] = Colors.blueAccent;
      } else if (colors[index] == Colors.blueAccent) {
        // color1 = constant.appPrimaryMaterialColor;
        colors[index] = constant.appPrimaryMaterialColor;
      } else {
        // color1 = constant.appPrimaryMaterialColor;
        colors[index] = constant.appPrimaryMaterialColor;
      }
    });
  }*/

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

  List winglistClassList = [];
  List finalDataSent = [];
  List getflatDetails = [];

  getFlatIds(String societyId,String wingId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId" : societyId,
          "wingId" : wingId
        };
        Services.responseHandler(apiName: "admin/getFlatsOfSociety_v1",body: data).then((data) async {
          if (data.Data !=null) {
            setState(() {
              getflatDetails = data.Data;
            });
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

  List flatsofOwner = [],closedFlats=[],rentedFlats = [],deadFlats=[],shopFlats=[];

  createNewWing() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // pr.show();
        for(int i=0;i<flatList.length;i++){
          finalDataSent.add({
            "flatNo" : flatList[i]["flatNumber"].toString(),
            "residenceType" : flatList[i]["FlatType"].toString()
          });
        }
        var data = {
          "societyId" : widget.societyId,
          "wingId" : widget.wingId,
          "totalFloor" : widget.floorData,
          "maxFlatPerFloor" : widget.maxUnitData,
          "wingName" : widget.wingName,
          "noOfParkingSlots" : 0,
          "flatList" :finalDataSent
        };
        Services.responseHandler(apiName: "admin/setUpWing",body: data).then((data) async {
          if (data.Data.toString()=="1") {
            if(widget.isEdit){
              Fluttertoast.showToast(
                msg: "Society Details Updated Successfully",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP,
                textColor: Colors.white,
              );
              Navigator.pushReplacementNamed(context, "/Dashboard");
            }
            else{
              print("success");
              // pr.hide();
              prefs.setString('madeAtleastOneWing', "true");
              Fluttertoast.showToast(
                msg: "Wing Details Added Successfully",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP,
                textColor: Colors.white,
              );
              print("code before setupwings screen");
              print(widget.societyCode);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => SetupWings(
                    wingData:widget.noOfWings,
                    societyId: widget.societyId,
                    mobileNo : widget.mobileNo,
                    societyCode :widget.societyCode,
                    isEdit: false,
                  ))
              );
            }
            // Navigator.pushReplacementNamed(context, "/SetupWings");
            // formatGrid();
          }
        },onError: (e) {
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
        title: Text("Wing"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 15,
                      width: 15,
                      color:     constant.appPrimaryMaterialColor[500],

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "Owner",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 15,
                      width: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "Closed",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 15,
                      width: 15,
                      color: Colors.orange,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "Rent",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 15,
                      width: 15,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "Dead",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 15,
                      width: 15,
                      color: Colors.blue,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "Shop",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            /* Expanded(
              child: BidirectionalScrollViewPlugin(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: myRowChildren,
                ),
              ),
            ),*/
            Expanded(
              child:
              // SingleChildScrollView(
              //   child:
              // Column(
              //   children:
              getFloorAndFlat(),
              // ),
              // ),
            ),
            // Expanded(
            //   child: StaggeredGridView.countBuilder(
            //       physics: ScrollPhysics(),
            //       shrinkWrap: true,
            //       scrollDirection: Axis.vertical,
            //       crossAxisCount: 4,
            //       itemCount: 10,
            //       staggeredTileBuilder: (_) => StaggeredTile.fit(2),
            //       itemBuilder: (BuildContext context, int index) {
            //         return GestureDetector(
            //           onTap: (){
            //             Navigator.pushNamed(context, "/WingDetail");
            //           },
            //           child: SizedBox(
            //             height: 100,
            //             width: 100,
            //             child: Card(
            //               borderOnForeground: true,
            //               color: Colors.grey[200],
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                 children: <Widget>[
            //                   Text(
            //                     "a",
            //                     style: TextStyle(
            //                       fontSize: 25.0,
            //                       fontWeight: FontWeight.w500,
            //                     ),
            //                     softWrap: true,
            //                     textAlign: TextAlign.center,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         );
            //       }),
            // )
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: RaisedButton(
                child: isSubmitPressed ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5,
                    ),
                  ),
                ):Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color:constant.appPrimaryMaterialColor,
                onPressed:(){
                  setState(() {
                    isSubmitPressed=true;
                  });
                  print("color");
                  print(constant.appPrimaryMaterialColor[500].toString());
                  for(int index=0;index<flatList.length;index++){
                    if(flatList[index]["flatTypeColor"].toString() == "MaterialColor(primary value: Color(0x997222a9))"){
                      flatList[index]["FlatType"] = "0";
                    }
                    else if(flatList[index]["flatTypeColor"].toString() == "MaterialColor(primary value: Color(0xff9e9e9e))"){
                      flatList[index]["FlatType"] = "1";
                    }
                    else if(flatList[index]["flatTypeColor"].toString() == "MaterialColor(primary value: Color(0xffff9800))"){
                      flatList[index]["FlatType"] = "2";
                    }
                    else if(flatList[index]["flatTypeColor"].toString() == "Color(0xff000000)"){
                      flatList[index]["FlatType"] = "3";
                    }
                    else if(flatList[index]["flatTypeColor"].toString() == "MaterialAccentColor(primary value: Color(0xff448aff))"){
                      flatList[index]["FlatType"] = "4";
                    }
                    if(index == flatList.length-1){
                      allchecked = true;
                    }
                  }
                  print(flatList);
                  if(allchecked) {
                    createNewWing();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}