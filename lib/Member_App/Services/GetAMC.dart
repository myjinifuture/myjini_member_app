import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Classlist.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

class GetAMC extends StatefulWidget {
  var ServiceData;

  GetAMC(this.ServiceData);

  @override
  _GetAMCState createState() => _GetAMCState();
}

class _GetAMCState extends State<GetAMC> {
  ProgressDialog pr;
  bool isLoading = true;
  List PackageList = [];
  List AMCList = [];
  bool flag = false;

  TextEditingController txtamcamt = new TextEditingController();
  TextEditingController txtnoofdays = new TextEditingController();
  TextEditingController txtnoofservices = new TextEditingController();

  List<servicelistClass> servicelistClassList = [];
  servicelistClass _servicelistClass;

  List<vendorlistClass> vendorlistClassList = [];
  vendorlistClass _vendorlistClass;

  bool servicelistLoading = false;
  bool vendorlistLoading = false;

  String _servicelistDropdownError;
  String _vendorlistDropdownError;

  @override
  void initState() {
    print("hhh==>> "+ widget.ServiceData.toString());
    _getServicePackage();
    _getVendorDataDropDown();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
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
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
  }

  _serviceRequestAMC() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // pr.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var data = {
          "Id": 0,
          "MemberId": prefs.getString(cnst.Session.Member_Id),
          "ServiceId": widget.ServiceData["ServiceId"],
          "ServicePackageId":  widget.ServiceData["Id"],
          "VendorId": _vendorlistClass.id,
          "ServicePackagePriceID": _servicelistClass.id
        };

        print("Save Vendor Data = ${data}");
        Services.ServiceRequestAMC(data).then((data) async {
          // pr.hide();

          if (data.Data != "0" && data.IsSuccess == true) {
            Fluttertoast.showToast(
                msg: "AMC Paid Successfully !",
                textColor: Colors.black,
                toastLength: Toast.LENGTH_LONG);

              Navigator.pushNamedAndRemoveUntil(
                context, "/HomeScreen", (Route<dynamic> route) => false);
          } else {
            showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          // pr.hide();
          showMsg("Try Again.");
        });
      } else
        showMsg("No Internet Connection.");
    } on SocketException catch (_) {
      // pr.hide();
      showMsg("No Internet Connection.");
    }
  }

  _getServicePackage() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          servicelistLoading = true;
        });
        String id = widget.ServiceData["Id"].toString();
        Future res = Services.GetServicePackageDropdown(id);
        res.then((data) async {
          setState(() {
            servicelistLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              servicelistClassList = data;
            });
            print("servicelisttt=> " + servicelistClassList.toString());
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            servicelistLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        servicelistLoading = false;
      });
    }
  }

  _getVendorDataDropDown() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          vendorlistLoading = true;
        });
        String id = widget.ServiceData["ServiceId"].toString();
        Future res = Services.GetVendorDataDropDown(id);
        res.then((data) async {
          setState(() {
            vendorlistLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              vendorlistClassList = data;
            });
            print("vendorlisttt=> " + vendorlistClassList.toString());
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            vendorlistLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        vendorlistLoading = false;
      });
    }
  }

  _getAmcDetails(id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        print("helooooo--");
        Services.GetAmcDetails(id).then((Data) async {
          setState(() {
            isLoading = false;
          });
          if (Data != null && Data.length > 0) {
            setState(() {
              AMCList = Data;
            });
            print("AMCList=> " + AMCList.toString());
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
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigator.pushReplacementNamed(context, "/HomeScreen");
              Navigator.pop(context);
            }),
        centerTitle: true,
        title: Text(
          'Get AMC',
          style: TextStyle(fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              "images/amcimage.jpg",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.7,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Service Name",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<servicelistClass>(
                      isExpanded: true,
                      hint: servicelistClassList.length > 0
                          ? Text(
                              ' Select Service',
                              style: TextStyle(fontSize: 15),
                            )
                          : Text(
                              " Service Not Found",
                              style: TextStyle(fontSize: 15),
                            ),
                      value: _servicelistClass,
                      onChanged: (newValue) {
                        setState(() {
                          _servicelistClass = newValue;
                          flag = true;
                          _servicelistDropdownError = null;
                        });
                        print("ServicePackagePriceID=>" + newValue.id);
                        _getAmcDetails(newValue.id);
                      },
                      items: servicelistClassList.map((servicelistClass value) {
                        return DropdownMenuItem<servicelistClass>(
                          value: value,
                          child: Text(" " + value.Title),
                        );
                      }).toList(),
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _servicelistDropdownError == null
                        ? Text(
                      "",
                      textAlign: TextAlign.start,
                    )
                        : Text(
                      _servicelistDropdownError ?? "",
                      style: TextStyle(
                          color: Colors.red[700], fontSize: 12),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Vendor",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<vendorlistClass>(
                      isExpanded: true,
                      hint: vendorlistClassList.length > 0
                          ? Text(
                              ' Select Vendor',
                              style: TextStyle(fontSize: 15),
                            )
                          : Text(
                              " Vendor Not Found",
                              style: TextStyle(fontSize: 15),
                            ),
                      value: _vendorlistClass,
                      onChanged: (newValue) {
                        setState(() {
                          _vendorlistClass = newValue;
                          _vendorlistDropdownError=null;
                        });
                        print("Vendor Id=>" + newValue.id);
                      },
                      items: vendorlistClassList.map((vendorlistClass value) {
                        return DropdownMenuItem<vendorlistClass>(
                          value: value,
                          child: Text(" " + value.Name),
                        );
                      }).toList(),
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _vendorlistDropdownError == null
                        ? Text(
                      "",
                      textAlign: TextAlign.start,
                    )
                        : Text(
                      _vendorlistDropdownError ?? "",
                      style: TextStyle(
                          color: Colors.red[700], fontSize: 12),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),

                flag == true
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: AMCList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left:8.0),
                                        child: Text(
                                          "AMC Amount",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Align(
                                              child: Text(
                                                cnst.Inr_Rupee +
                                                    " ${AMCList[index]["AMCAmount"]}",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              alignment: Alignment.centerLeft,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey[400]),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 40,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left:8.0,top: 4.0),
                                        child: Text(
                                          "No of Days",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Align(
                                              child: Text(
                                                " ${AMCList[index]["NoofDays"]}",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              alignment: Alignment.centerLeft,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey[400]),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 40,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left:8.0,top: 4.0),
                                        child: Text(
                                          "No of Services",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Align(
                                              child: Text(
                                                " ${AMCList[index]["NoofService"]}",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              alignment: Alignment.centerLeft,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey[400]),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 40,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GetAMC(widget.ServiceData),
                          ),
                        );
                        Fluttertoast.showToast(
                            msg: "AMC Added Successfully !",
                            textColor: Colors.black,
                            toastLength: Toast.LENGTH_LONG);
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: 35,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: cnst.appPrimaryMaterialColor,
                            textColor: Colors.white,
                            splashColor: Colors.white,
                            child: Text("Pay Now",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                            onPressed: () {
                              bool isValidate = true;
                              setState(() {
                                if (_servicelistClass == null) {
                                  isValidate = false;
                                  _servicelistDropdownError =
                                  "Please Select Service";
                                }
                                if (_vendorlistClass == null) {
                                  isValidate = false;
                                  _vendorlistDropdownError =
                                  "Please Select Vendor";
                                }
                              });
                              if (isValidate) {
                                _serviceRequestAMC();
                              }

                            }),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
