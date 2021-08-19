import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';

enum referralRating {poor,average,good,very_good,highly_recommended}

class ReferralSlip extends StatefulWidget {
  @override
  _ReferralSlipState createState() => _ReferralSlipState();
}

class _ReferralSlipState extends State<ReferralSlip> {
  TextEditingController _txtreferralName = TextEditingController();
  TextEditingController _txtMobileNo = TextEditingController();
  TextEditingController _txtEmail = TextEditingController();
  TextEditingController _txtComments = TextEditingController();
  TextEditingController _txtAddress = TextEditingController();
  List referralTypeList = [];
  List colourchanger = [];
  String selectedType;
  bool isReferralType = true;
  bool isPressed1 = true;
  bool isPressed2 = false;
  String img = 'assets/images/slightly-grinning-face.png';
  String recommend = 'Good';
  List<bool> star = [true, true, true, false, false];
  List memberData = [];
  Image myImage1, myImage2, myImage3, myImage4, myImage5;

  String _selectedReferralTypeTo;
  var starFill = 0;

  @override
  void initState() {
    super.initState();
    _getReferralTypeList();
    _getDirectoryListing();
    myImage1 = Image.asset('assets/image/disappointed-face.png');
    myImage2 = Image.asset('assets/image/neutral-face.png');
    myImage3 = Image.asset('assets/image/slightly-grinning-face.png');
    myImage4 = Image.asset('assets/image/grinning-face.png');
    myImage5 = Image.asset('assets/image/star-struck.png');
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
                ;
              },
            ),
          ],
        );
      },
    );
  }

  _getDirectoryListing() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var SocietyId = prefs.getString(Session.SocietyId);
      var memberId = prefs.getString(Session.Member_Id);
      print("print member ID+++");
      print(memberId);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {"societyId": SocietyId};
        Services.responseHandler(apiName: "admin/directoryListing", body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            if(mounted){
              setState(() {
                memberData = data.Data;
              });
            }
            print("memberData print..................");
            print(memberData);
          } else {
            // setState(() {
            //   isLoading = false;
            // });
          }
        }, onError: (e) {
          showHHMsg("Something Went Wrong Please Try Again", "");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
    }
  }

  addReferal(String Refname, String Mobileno, String Email, String Address,
      String Comments, int star) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var memberId = prefs.getString(Session.Member_Id);
      print(memberId);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {
          "referralFrom": memberId,
          "referralTo": _selectedReferralTypeTo,
          "referralType": selectedType,
          "referralName": Refname,
          "mobile": Mobileno,
          "email": Email,
          "address": Address,
          "comments": Comments,
          "status": star
        };
        print("print body......................");
        print(body);
        Services.responseHandler(apiName: "member/addReferral", body: body)
            .then((data) async {
          if (data.Data != null) {
            setState(() {
              print(data.Data);
              Fluttertoast.showToast(
                  msg: "Add Referral Successfully..!!",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              Navigator.pop(context);
            });
          } else if (data.Data.toString() == "0") {
            setState(() {
              Fluttertoast.showToast(
                  msg: "Add Referral Rejected!!!",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
            });
          } else {
            print("Somthing went Wrong");
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _getReferralTypeList() async {
    try {
      final internetResult = await InternetAddress.lookup('google.com');
      if (internetResult.isNotEmpty &&
          internetResult[0].rawAddress.isNotEmpty) {
        var body = {};
        print(body);
        Services.responseHandler(apiName: "member/getReferralType", body: body)
            .then((responseData) {
          if (responseData.Data.length > 0) {
            if(mounted){setState(() {
              referralTypeList = responseData.Data;
              print("Divyan");
              print(referralTypeList);
              for (var i = 0; i < referralTypeList.length; i++) {
                if (i == 0) {
                  setState(() {
                    colourchanger.add(1);
                    selectedType = referralTypeList[0]["_id"].toString();
                    print(selectedType);
                  });
                } else {
                  setState(() {
                    colourchanger.add(2);
                  });
                }
              }
              print(colourchanger);
            });}
          } else {
            Fluttertoast.showToast(
              msg: "${responseData.Message}",
              backgroundColor: Colors.white,
              textColor: appPrimaryMaterialColor,
            );
          }
        }).catchError((error) {
          Fluttertoast.showToast(
            msg: "Error $error",
            backgroundColor: Colors.white,
            textColor: appPrimaryMaterialColor,
          );
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "You aren't connected to the Internet !",
        backgroundColor: Colors.white,
        textColor: appPrimaryMaterialColor,
      );
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
                Navigator.of(context).pop();
                ;
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(myImage1.image, context);
    precacheImage(myImage2.image, context);
    precacheImage(myImage3.image, context);
    precacheImage(myImage4.image, context);
    precacheImage(myImage5.image, context);
  }

  var name;
  storedataincontroler(String data) async {
    setState(() {
      for (var i = 0; i < memberData.length; i++) {
        if (data == memberData[i]["_id"].toString()) {
            name = memberData[i]["Name"].toString();
          _txtMobileNo.text = memberData[i]["ContactNo"].toString();
          _txtEmail.text = memberData[i]["EmailId"].toString();
          _txtAddress.text = memberData[i]["Address"].toString();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Refrral Slip',
            style: TextStyle(
              fontSize: 18,
              fontFamily: "OpenSans",
              color: Colors.white,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                onPressed: () {},
                icon: Icon(
                  Icons.help_outline_sharp,
                  size: 30,
                  color: Colors.white,
                ))
          ],
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ), //

        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey)),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text('Referral To'),
                      value: _selectedReferralTypeTo,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedReferralTypeTo = newValue;
                            print(_selectedReferralTypeTo);
                          storedataincontroler(_selectedReferralTypeTo);
                          //  _selectedReferralTypeMySelf(_selectedReferralTypeTo);
                        });
                      },
                      items: memberData.map((location) {
                        return DropdownMenuItem(
                          child: new Text(location["Name"]),
                          value: location["_id"].toString(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
              ),
              child: Text('Referral Type',style:TextStyle(fontFamily: "OpenSans",)),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 15,
              child: Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: referralTypeList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedType =
                              referralTypeList[index]["_id"].toString();
                          print(selectedType);
                        });
                        for (var i = 0; i < referralTypeList.length; i++) {
                          if (colourchanger[i] == 1) {
                            setState(() {
                              colourchanger[i] = 2;
                              colourchanger[index] = 1;
                            });
                          }
                        }
                        if (colourchanger[0] == 1) {
                          setState(() {
                            storedataincontroler(_selectedReferralTypeTo);
                          });
                        } else {
                          setState(() {
                            _txtEmail.text = "";
                            _txtMobileNo.text = "";
                            _txtAddress.text = "";
                            _txtreferralName.text = "";
                          });
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                            gradient: LinearGradient(
                              colors: colourchanger[index] == 1
                                  ? <Color>[
                                      Colors.deepPurple,
                                      Colors.purple,
                                    ]
                                  : <Color>[
                                      Colors.grey,
                                      Colors.white,
                                    ],
                            ),
                          ),
                          padding: EdgeInsets.only(
                              left: 57.0, right: 57, top: 10, bottom: 10),
                          child: Text(
                            referralTypeList[index]["referralType"],
                            style: TextStyle(
                                color: colourchanger[index] == 1
                                    ? Colors.white
                                    : Colors.black,
                                fontFamily: "OpenSans"),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 15,
                child: TextFormField(
                  controller: _txtreferralName,
                  decoration: InputDecoration(
                    hintText: 'Referral Name',
                    focusColor: Colors.deepPurple,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.height /11,
                child: TextFormField(
                  controller: _txtMobileNo,
                  validator: (value) {
                    if (value.trim() == "" || value.length < 10) {
                      return 'Please Enter 10 Digit Mobile Number';
                    }
                    return null;
                  },
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Telephone',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10.0, right: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 15,
                child: TextField(
                  controller: _txtEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 7.5,
                child: TextField(
                  controller: _txtAddress,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Address',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 8,
                child: TextField(
                  controller: _txtComments,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Comments',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Text(
                'How hot is this referral ?',
                style: TextStyle(fontSize: 14,fontFamily: "OpenSans",),
              ),
            ),
            SizedBox(height: 30),
            Center(
                child: Image(
                    image: AssetImage(img),
                    width: MediaQuery.of(context).size.width * 0.2)),
            SizedBox(height: 10),
            Center(
                child: Text(
              recommend,
              style: TextStyle(fontSize: 24),
            )),
            SizedBox(height: 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    child: Icon(
                      star[0] ? Icons.star : Icons.star_border,
                      color: Color(0xffe892cd),
                      size: 40,
                    ),
                    onTap: () {
                      rating(0);
                    },
                  ),
                  InkWell(
                      child: Icon(star[1] ? Icons.star : Icons.star_border,
                          color: Color(0xffea4bee), size: 40),
                      onTap: () {
                        rating(1);
                      }),
                  InkWell(
                      child: Icon(star[2] ? Icons.star : Icons.star_border,
                          color: Color(0xffad0ac2), size: 40),
                      onTap: () {
                        rating(2);
                      }),
                  InkWell(
                      child: Icon(star[3] ? Icons.star : Icons.star_border,
                          color: Color(0xff9f23d2), size: 40),
                      onTap: () {
                        rating(3);
                      }),
                  InkWell(
                      child: Icon(star[4] ? Icons.star : Icons.star_border,
                          color: Color(0xff8a0cad), size: 40),
                      onTap: () {
                        rating(4);
                      }),
                ]),
            Padding(padding: EdgeInsets.only(top:20.0)),
                Center(
                  child: InkWell(
                    onTap: (){
                      if (_txtreferralName.text == "" ||
                          _txtMobileNo.text == "" ||
                          _txtEmail.text == "" ||
                          _txtComments.text == "" ||
                          _txtAddress.text == "" ) {
                        Fluttertoast.showToast(
                          msg: "Fields can't be empty",
                          gravity: ToastGravity.TOP,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      } else {
                        addReferal(
                            _txtreferralName.text,
                            _txtMobileNo.text,
                            _txtEmail.text,
                            _txtAddress.text,
                            _txtComments.text,
                            starFill
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                        gradient: LinearGradient(
                          colors: <Color>[
                            Colors.deepPurple,
                            Colors.purple,
                          ]
                        ),
                      ),
                      padding: EdgeInsets.only(
                          left: 70.0, right: 70, top: 10, bottom: 10),
                      child: Text("Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "OpenSans"),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
          ]),
        ));
  }

  rating(int i) {
    var flag = 0;
    for (flag = 0; flag <= i; flag++) {
      star[flag] = true;
    }
    starFill = flag;
    print("ptint starFill.........");
    print(starFill);
    for (int k = i + 1; k <= 4; k++) {
      star[k] = false;
    }

    switch (i) {
      case 0:
        img = 'assets/images/disappointed-face.png';
        recommend = 'Poorly Recommended';
        break;
      case 1:
        img = 'assets/images/neutral-face.png';
        recommend = 'Moderately Recommended';
        break;
      case 2:
        img = 'assets/images/slightly-grinning-face.png';
        recommend = 'Fairly Recommended';
        break;
      case 3:
        img = 'assets/images/grinning-face.png';
        recommend = 'Strongly Recommended';
        break;
      case 4:
        img = 'assets/images/star-struck.png';
        recommend = 'Highly Recommended';
        break;
      default:
        img = 'assets/images/slightly-grinning-face.png';
        recommend = 'good';
    }
    setState(() {});
  }
}
