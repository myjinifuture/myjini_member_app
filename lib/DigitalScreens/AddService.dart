import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/DigitalCommon/Constants.dart';
import 'package:smart_society_new/DigitalCommon/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;


class AddService extends StatefulWidget {
  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  bool isLoading = false;
  String MemberId = "";
  TextEditingController txtTitle = new TextEditingController();
  TextEditingController txtDesc = new TextEditingController();

  DateTime date = new DateTime.now();

  @override
  void initState() {
    super.initState();
    GetLocalData();
  }

  GetLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(cnst.Session.digital_Id);

    if (memberId != null && memberId != "")
      setState(() {
        MemberId = memberId;
      });
  }

  SaveService() async {
    if (txtTitle.text != '' && txtDesc.text != '') {
      setState(() {
        isLoading = true;
      });

      var data = {
        'type': 'service',
        'title': txtTitle.text.replaceAll("'", "''"),
        'desc': txtDesc.text.replaceAll("'", "''"),
        'memberid': MemberId.toString(),
      };

      Future res = Services.SaveService(data);
      res.then((data) {
        setState(() {
          isLoading = false;
        });
        if (data != null && data.ERROR_STATUS == false) {
          Fluttertoast.showToast(
              msg: "Data Saved",
              backgroundColor: Colors.green,
              gravity: ToastGravity.TOP);
          Navigator.popAndPushNamed(context, '/Dashboard');
        } else {
          Fluttertoast.showToast(
              msg: "Data Not Saved" + data.MESSAGE,
              backgroundColor: Colors.red,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_LONG);
        }
      }, onError: (e) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: "Data Not Saved" + e.toString(), backgroundColor: Colors.red);
      });
    } else {
      Fluttertoast.showToast(
          msg: "Please Enter Data First",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Service'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(20),
          //margin: EdgeInsets.only(top: 110),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                      border: new Border.all(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextFormField(
                    controller: txtTitle,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.title), hintText: "Title"),
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black),
                  ),
                  //height: 40,
                  width: MediaQuery.of(context).size.width - 40,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                      border: new Border.all(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextFormField(
                    controller: txtDesc,
                    maxLines: 10,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.description),
                        hintText: "Description"),
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(color: Colors.black),
                  ),
                  //height: 40,
                  width: MediaQuery.of(context).size.width - 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 10),
                  child: MaterialButton(
                    color: buttoncolor,
                    minWidth: MediaQuery.of(context).size.width - 20,
                    onPressed: () {
                      if (isLoading == false) this.SaveService();
                    },
                    child: setUpButtonChild(),
                  ) /*RaisedButton(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            elevation: 5,
                            textColor: Colors.white,
                            color: cnst.buttoncolor,
                            child: Text("Add Service",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15)),
                            onPressed: () {
                              Navigator.pushNamed(context, "/Dashboard");
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)))*/
                  ,
                ),
              ],
            ),
          ),
        ));
  }

  Widget setUpButtonChild() {
    if (isLoading == false) {
      return new Text(
        "Add Service",
        style: TextStyle(
            color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }
}
