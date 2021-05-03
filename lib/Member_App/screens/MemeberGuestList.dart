import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:url_launcher/url_launcher.dart';

class MemberGuestList extends StatefulWidget {
  @override
  _MemberGuestListState createState() => _MemberGuestListState();
}

class _MemberGuestListState extends State<MemberGuestList> {
  bool isLoading = false;
  List _GuestList = [];
  String Address,memberId,societyId;
  String Type = 'Visitor';
  TextEditingController txtSearch = new TextEditingController();
  String name;

  @override
  void initState() {
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      Address = prefs.getString(constant.Session.Address);
    });
    memberId = prefs.getString(constant.Session.Member_Id);
    societyId = prefs.getString(constant.Session.SocietyId);
    name = prefs.getString(constant.Session.Name);
    _GetVisitorData();
  }
//==============by rinki
  void launchwhatsapp({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  _GetVisitorData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data ={
          "memberId": memberId,
          "societyId": societyId,
        };
        Services.responseHandler(apiName: "member/getInvitedGuestList",body: data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              _GuestList = data.Data;
            });
          } else {
            setState(() {
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

  Widget _MyGuestlistCard(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0, left: 4.0),
      child: Card(
          elevation: 2,
          child: Column(
            children: <Widget>[
              Container(
                height: 1,
                color: Colors.grey[200],
                width: MediaQuery.of(context).size.width / 1.1,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 10.0, bottom: 10.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        image: new DecorationImage(
                            image: AssetImage("images/man.png"),
                            fit: BoxFit.cover),
                        borderRadius:
                            BorderRadius.all(new Radius.circular(75.0)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Row(
                            children: <Widget>[
                              !isSearching ? Text("${_GuestList[index]["Name"]}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(81, 92, 111, 1))):Text("${tempList[index]["Name"]}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(81, 92, 111, 1))),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 1.0, top: 3.0),
                              child: !isSearching ? Text("  ${_GuestList[index]["ContactNo"]}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700])):Text("  ${tempList[index]["ContactNo"]}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700])),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: <Widget>[
                        //     Padding(
                        //       padding:
                        //       const EdgeInsets.only(left: 1.0, top: 3.0),
                        //       child: !isSearching ? Text("  ${_GuestList[index]["vehicleNo"]}",
                        //           style: TextStyle(
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.w500,
                        //               color: Colors.grey[700])):Text("  ${tempList[index]["vehicleNo"]}",
                        //           style: TextStyle(
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.w500,
                        //               color: Colors.grey[700])),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  GestureDetector(
                   onTap: (){
                     !isSearching ? launch(
                         ('tel://${_GuestList[index]["ContactNo"]}')):
                     launch(
                         ('tel://${tempList[index]["ContactNo"]}'));
                   },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0,right: 10),
                      child: Icon(Icons.phone,color: Colors.green,size: 30,)
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      !isSearching ?
                      launchwhatsapp(
                          phone:
                          "+91" + " ${_GuestList[index]["ContactNo"]}",
                          message: ""):launchwhatsapp(
                          phone:
                          "+91" + " ${tempList[index]["ContactNo"]}",
                          message: "");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0,right: 10),
                      child: Image.asset("images/whatsapp.png",height: 45,width: 45,),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      // !isSearching ? launch(
                      //     ('tel://${_GuestList[index]["ContactNo"]}')):
                      // launch(
                      //     ('tel://${tempList[index]["ContactNo"]}'));
                      launch('https://wa.me/+91${_GuestList[index]["ContactNo"]}?text=${name}+ is inviting you as a guest in their society\n\n'
                          'Please show this Code at the society gate ${_GuestList[index]["entryNo"]}\n'
                          '${_GuestList[index]["wingData"][0]["wingName"]} - ${_GuestList[index]["flatData"][0]["flatNo"]} \n \n '
                          '${_GuestList[index]["SocietyData"][0]["Location"]["mapLink"]} \n '
                          '${_GuestList[index]["SocietyData"][0]["Address"]}');

                    },
                    child: Padding(
                        padding: const EdgeInsets.only(top: 12.0,right: 10),
                        child: Icon( Icons.share_sharp,color: Colors.green,size: 30,)
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 8.0),
                  //   child: IconButton(
                  //       icon: Icon(Icons.share, color: Colors.grey),
                  //       onPressed: () {
                  //         // Share.share(_GuestList[index]["ContactNo"],
                  //         //     subject: '',
                  //         // sharePositionOrigin:_GuestList[index]["ContactNo"] );
                  //         Share.share(
                  //             'http://smartsociety.itfuturz.com/QRCode.aspx?id=${_GuestList[index]["Id"]}&type=Visitor');
                  //       }),
                  // )
                ],
              ),
            ],
          )),
    );
  }

  List tempList = [];
  bool isSearching = false;

  void searchOperation(String searchText) {
    if (searchText != "") {
      setState(() {
        tempList.clear();
        isSearching = true;
      });
      String mobile = "",name="",vehicleNo="";
      for (int i = 0; i < _GuestList.length; i++) {
         name = _GuestList[i]["Name"];
        mobile = _GuestList[i]["ContactNo"];
         vehicleNo = _GuestList[i]["vehicleNo"];
         if (name.toLowerCase().contains(searchText.toLowerCase()) ||
            mobile.toLowerCase().contains(searchText.toLowerCase())||
             vehicleNo.toLowerCase().contains(searchText.toLowerCase())) {
          setState(() {
            tempList.add(_GuestList[i]);
          });
        }
      }
    } else {
      setState(() {
        isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pushReplacementNamed(context, "/HomeScreen");
      },
      child: Scaffold(
        body:
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.only(top: 5.0, right: 8.0, left: 8.0),
                child: TextFormField(
                  onChanged: searchOperation,
                  controller: txtSearch,
                  scrollPadding: EdgeInsets.all(0),
                  decoration: InputDecoration(
                      counter: Text(""),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius:
                          BorderRadius.all(Radius.circular(8))),
                      suffixIcon: Icon(
                        Icons.search,
                        color: constant.appPrimaryMaterialColor,
                      ),
                      hintText: "Search Visitor"),
                  maxLength: 100,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              isLoading
                  ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
                  : _GuestList.length > 0
                  ? Container(
                child: Container(
                  child: isSearching ? ListView.builder(
                    physics: PageScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: tempList.length,
                    itemBuilder: _MyGuestlistCard,
                  ):ListView.builder(
                    physics: PageScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _GuestList.length,
                    itemBuilder: _MyGuestlistCard,
                  ),
                ),
              )
                  : Container(
                child: Center(child: Text("No Data Found")),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: constant.appPrimaryMaterialColor,
          icon: Icon(Icons.add),
          label: Text("Add Visitor"),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/AddGuest');
          },
        ),
      ),
    );
  }
}
