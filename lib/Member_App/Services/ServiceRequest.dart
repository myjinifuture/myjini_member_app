import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

class ServiceRequest extends StatefulWidget {
  var _vendorData, ServiceData, servicetitle,ServiceId;

  ServiceRequest(this._vendorData, this.ServiceData, this.servicetitle,this.ServiceId);

  @override
  _ServiceRequestState createState() => _ServiceRequestState();
}

class _ServiceRequestState extends State<ServiceRequest> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController txtvendorname = new TextEditingController();
  TextEditingController txtabout = new TextEditingController();
  TextEditingController txtmobile = new TextEditingController();
  TextEditingController txtservice = new TextEditingController();
  TextEditingController txtservicepackage = new TextEditingController();
  TextEditingController txtamount = new TextEditingController();
  TextEditingController txttotalamount = new TextEditingController();

  ProgressDialog pr;
  bool isLoading = true;
  List PackageList = [];
  List _SelectedPackageList = [];
  List _SelectedCommissionAmtList = [];
  List _SelectedCommissionPercentageList = [];

  List _SelectedServiceAmountList = [];
  List _SelectedCommisionAmountList = [];
  List _SelectedCommisionPercentageList = [];
  List _SelectedServiceAmtList = [];
  List list = [];

  double finalamt = 0;
  double serviceamt = 0;
  double comper = 0;
  double comamt = 0;
  DateTime _date;
  String _dateError;



  @override
  void initState() {
    print("Meher=> " + widget.servicetitle);
    print("Meher=> " + PackageList.toString());
    print("Meher111 => " + _SelectedPackageList.toString());
    _getdata();
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

  _getdata() {
    txtvendorname.text = widget._vendorData["Name"];
    txtabout.text = widget._vendorData["About"];
    txtmobile.text = widget._vendorData["ContactNo"];
    txtservice.text = widget.servicetitle;
    txtservicepackage.text = widget.ServiceData["Title"];
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now(),
        lastDate: new DateTime(2021));

    if (picked != null && picked != _date && picked != "null") {
      print("Date Selected -->>${_date.toString()}");
      setState(() {
        _date = picked;
        _dateError = null;
      });
    }
  }

  String setDate(String date) {
    String final_date = "";
    var tempDate;
    if (date != "" && date != null && date != "null") {
      tempDate = date.toString().split("-");

      if (tempDate[2].toString().length == 1) {
        tempDate[2] = "0" + tempDate[2].toString();
      }
      if (tempDate[1].toString().length == 1) {
        tempDate[1] = "0" + tempDate[1].toString();
      }
      final_date = "${tempDate[2].toString().substring(0, 2)}-"
          "${tempDate[1].toString().substring(0, 2)}-${tempDate[0].toString()}"
          .toString();
    }
    return final_date;
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
          'Service Request',
          style: TextStyle(fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0, left: 8.0),
                              child: Text(
                                "Vendor",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                ":",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 6.0, left: 8.0, right: 5),
                              child: Container(
                                height: 35,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: txtvendorname,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey[200],
                                      contentPadding: EdgeInsets.only(
                                          top: 5, left: 10, bottom: 5),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              width: 0, color: Colors.black)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 0, color: Colors.black)),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 14)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0, left: 8.0),
                              child: Text(
                                "Mobile",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                ":",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 6.0, left: 8.0, right: 5),
                              child: Container(
                                height: 35,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: txtmobile,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey[200],
                                      contentPadding: EdgeInsets.only(
                                          top: 5, left: 10, bottom: 5),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              width: 0, color: Colors.black)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 0, color: Colors.black)),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 14)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0, left: 8.0),
                              child: Text(
                                "Service",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                ":",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 6.0, left: 8.0, right: 5),
                              child: Container(
                                height: 35,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: txtservice,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey[200],
                                      contentPadding: EdgeInsets.only(
                                          top: 5, left: 10, bottom: 5),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              width: 0, color: Colors.black)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 0, color: Colors.black)),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 14)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0, left: 8.0),
                              child: Text(
                                "Service Package",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                ":",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 6.0, left: 8.0, right: 5),
                              child: Container(
                                height: 35,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: txtservicepackage,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey[200],
                                      contentPadding: EdgeInsets.only(
                                          top: 5, left: 10, bottom: 5),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              width: 0, color: Colors.black)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 0, color: Colors.black)),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 14)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0, left: 8.0),
                              child: Text(
                                "Services",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                ":",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.7,
                                child: MultiSelectFormField(
                                  autovalidate: false,
                                  title: Text('Select Service'),
                                  validator: (value) {
                                    if (value == null || value.length == 0) {
                                      return 'Please select one or more options';
                                    }
                                  },

                                  dataSource: PackageList,
                                  textField: 'Title',
                                  valueField: 'Id',
                                  okButtonLabel: 'OK',
                                  cancelButtonLabel: 'CANCEL',
                                  // required: true,
                                  hintWidget: Text("Please choose one or more"),
                                  change: () => _SelectedPackageList,
                                  onSaved: (value) {
                                    if (value == null) return;
                                    setState(() {
                                      _SelectedPackageList = value;
                                      // PackageList[value]["Price"]=list;
                                      //list = value;
                                    });
                                    print("Meher55 => " +
                                        _SelectedPackageList.toString());
                                    double amt = 0;
                                    for (int i = 0; i < PackageList.length; i++) {
                                      for (int j = 0;
                                          j < _SelectedPackageList.length;
                                          j++) {
                                        if (PackageList[i]["Id"].toString() ==
                                            _SelectedPackageList[j].toString()) {
                                          setState(() {
                                            amt += double.parse(PackageList[i]
                                                    ["Price"]
                                                .toString());
                                           /* comamt = PackageList[i]["CommisionAmount"];
                                            comper = PackageList[i]["CommissionPercentage"];
                                            serviceamt = PackageList[i]["Price"];*/

                                          });
                                          /*_SelectedCommisionAmountList.add(comamt);
                                          _SelectedCommisionPercentageList.add(comper);
                                          _SelectedServiceAmtList.add(serviceamt);*/
                                          break;
                                        }
                                      }
                                    }
                                    setState(() {
                                      finalamt = amt;
                                    });

                                    print("yash=> " + finalamt.toString());
                                    print("Meher111 => " +
                                        _SelectedPackageList.toString());
                                    print("Meher112 => " + list.toString());
                                  //  print("serviceamt => " + _SelectedServiceAmtList.toString());
                                    //print("ComAmt => " + _SelectedCommisionAmountList.toString());
                                    //print("ComPerc => " + _SelectedCommisionPercentageList.toString());
                                    // print("Meher113 => "+ PackageList[value]["Price"].toString());
                                  },
                                ),
                              ),
                            ),
                          ),
                          //finalamt == 0 ? Container() : Text("${finalamt}"),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
//                      Text("Commission Amount - ${_SelectedCommisionAmountList}"),
//                      Text("Commission Per - ${_SelectedCommisionPercentageList}"),
//                      Text("ServiceAmt - ${_SelectedServiceAmtList}"),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0, left: 8.0),
                              child: Text(
                                "Amount",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                ":",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 8,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              padding: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                  border:
                                  Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5))),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: finalamt == null
                                          ? Padding(
                                        padding:
                                        const EdgeInsets.all(
                                            8.0),
                                        child: Text(
                                          " Final Amount",
                                          style: TextStyle(
                                              color: Colors
                                                  .grey[700],
                                              fontSize: 17),
                                        ),
                                      )
                                          : Text(
                                          "  ${finalamt}")),
                                ],
                              ),
                            ),
                          ),

                        /*  Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 6.0, left: 8.0, right: 5),
                              child: finalamt == 0
                                  ? Container()
                                  : Text(cnst.Inr_Rupee+" ${finalamt}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                            ),
                          ),*/
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0, left: 8.0),
                              child: Text(
                                "Date",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                ":",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: GestureDetector(
                              onTap: () {
                                _selectDate(context);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                padding: EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                    border:
                                    Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5))),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: _date == null
                                            ? Padding(
                                          padding:
                                          const EdgeInsets.all(
                                              8.0),
                                          child: Text(
                                            " Select",
                                            style: TextStyle(
                                                color: Colors
                                                    .grey[700],
                                                fontSize: 17),
                                          ),
                                        )
                                            : Text(
                                            "  ${setDate(_date.toString())}")),
                                    GestureDetector(
                                        onTap: () {
                                          _selectDate(context);
                                        },
                                        child: Icon(
                                          Icons.calendar_today,
                                          color: cnst
                                              .appPrimaryMaterialColor,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _dateError == null
                            ? Container()
                            : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _dateError ?? "",
                            style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 12),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30.0),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: cnst.appPrimaryMaterialColor,
                            textColor: Colors.white,
                            splashColor: Colors.white,
                            child: Text("ADD",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            onPressed: () {
                              bool isValidate = true;
                              setState(() {
                                if (_date == null) {
                                  isValidate = false;
                                  _dateError = "Please Select Date";

                                }
                              });
                               if (_formkey.currentState
                                  .validate()) {
                                 if (isValidate) {
                                 }

                              }
                              /*Navigator.pushReplacementNamed(
                                            context, "/OTPVerification");*/
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
