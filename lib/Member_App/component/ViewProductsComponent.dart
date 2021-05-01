import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:url_launcher/url_launcher.dart';

class ViewProductsComponent extends StatefulWidget {
  var data, advertiserid, advertisementData;

  ViewProductsComponent(this.data, this.advertiserid, this.advertisementData);

  @override
  _ViewProductsComponentState createState() => _ViewProductsComponentState();
}

class _ViewProductsComponentState extends State<ViewProductsComponent> {
  ProgressDialog pr;
  bool isLoading = true;
  String mobile;

  @override
  void initState() {
    getdata();
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
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
  }

  getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //txtmobile.text = preferences.getString(constant.Session.session_login);
    // txtname.text = preferences.getString(constant.Session.Name);

    print("gg-- " + widget.data.toString());
    print("heythere");
    mobile = widget.advertisementData["AdvertiserMobile"];
    print("heeee-- " + mobile);
  }

  _openWhatsapp(mobile) {
    String whatsAppLink = constant.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "This is message");
    launch(urlwithmsg);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 200,
            width: 190,
            child: Card(
              borderOnForeground: true,
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FadeInImage.assetNetwork(
                      width: MediaQuery.of(context).size.width,
                      height: 85,
                      fit: BoxFit.fill,
                      placeholder: "images/Ad1.jpg",
                      image: "${constant.Image_Url}" + widget.data["Image"]),
                  Text(
                    "${widget.data["Name"]}",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w700,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    constant.Inr_Rupee + " ${widget.data["Price"]}",
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          builder: (context) => Inquiry(
                              mobile, widget.data, widget.advertiserid), context: context);
                      // _openWhatsapp("7600815010");
                    },
                    child: Center(
                        child: Image.asset(
                      "images/whatsapplogo1.png",
                      width: 30,
                      height: 30,
                    )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Inquiry extends StatefulWidget {
  var mobile, data, advertiserid;

  Inquiry(this.mobile, this.data, this.advertiserid);

  @override
  _InquiryState createState() => _InquiryState();
}

class _InquiryState extends State<Inquiry> {
  TextEditingController txtname = new TextEditingController();
  TextEditingController txtmobile = new TextEditingController();
  TextEditingController txtdescription = new TextEditingController();

  String name, mobile;
  ProgressDialog pr;
  bool isLoading = true;

  @override
  void initState() {
    getdata();
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
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
  }

  getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    txtmobile.text = preferences.getString(constant.Session.session_login);
    txtname.text = preferences.getString(constant.Session.Name);

    /*mobile = widget.data["AdvertiserMobile"];
    print("heeee-- "+mobile);*/
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Padding(
                  child: Text(
                    "Enter the details to send to the Advertiser.",
                    style: TextStyle(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.justify,
                  ),
                  padding: const EdgeInsets.all(8.0),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    "images/close.png",
                    width: 25,
                    height: 25,
                  ))
            ],
          ),
          Padding(
            child: Text(
              "Name",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            padding: const EdgeInsets.all(8.0),
          ),
          SizedBox(
            height: 60,
            child: TextFormField(
              /*     validator: (value){
                                          if(value.trim()==""){
                                            return "Please insert valid reason";
                                          }
                                        },*/
              controller: txtname,
              keyboardType: TextInputType.multiline,
              readOnly: true,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: new BorderSide(),
                  ),
                  labelText: "Enter Name",
                  hintStyle: TextStyle(fontSize: 13)),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Padding(
            child: Text(
              "Whatsapp Number",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            padding: const EdgeInsets.all(8.0),
          ),
          SizedBox(
            height: 60,
            child: TextFormField(
              /*     validator: (value){
                                          if(value.trim()==""){
                                            return "Please insert valid reason";
                                          }
                                        },*/
              controller: txtmobile,
              readOnly: true,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: new BorderSide(),
                  ),
                  labelText: "Enter Number",
                  hintStyle: TextStyle(fontSize: 13)),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Padding(
            child: Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            padding: const EdgeInsets.all(8.0),
          ),
          SizedBox(
            child: TextFormField(
              /*     validator: (value){
                                          if(value.trim()==""){
                                            return "Please insert valid reason";
                                          }
                                        },*/
              controller: txtdescription,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: new BorderSide(),
                  ),
                  labelText: "Enter Description",
                  hintStyle: TextStyle(fontSize: 13)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 18.0, left: 8, right: 8, bottom: 8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: constant.appPrimaryMaterialColor,
                  textColor: Colors.white,
                  splashColor: Colors.white,
                  child: Text("Continue",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                        builder: (context) => Continue(widget.mobile, widget.data,
                            txtdescription.text, widget.advertiserid,txtmobile.text,txtname.text), context: context);
                  }),
            ),
          ),
        ],
      )),
    );
  }
}

class Continue extends StatefulWidget {
  var mobile, data, desc, advertiserid,membermobile,membername;

  Continue(this.mobile, this.data, this.desc, this.advertiserid,this.membermobile,this.membername);

  @override
  _ContinueState createState() => _ContinueState();
}

class _ContinueState extends State<Continue> {
  ProgressDialog pr;
  bool isLoading = true;

  _openWhatsapp(mobile) {
    String whatsAppLink = constant.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "This is message");
    // String urlwithmsg = urlwithmobile.replaceAll("#msg", "This is message");
    launch(urlwithmobile);
  }

  _vendorProductInquiry() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var data = {
          "Id": 0,
          "ProductId": widget.data["Id"],
          "MemberId": prefs.getString(constant.Session.Member_Id),
          "AdvertiserId": widget.advertiserid,
          "Description": widget.desc,
        };

        print("Add Scanned Data = ${data}");
        Services.VendorProductInquiry(data).then((data) async {
          if (data.Data != "0" && data.IsSuccess == true) {
            /*        Fluttertoast.showToast(
                msg: "Data Added Successfully",
                textColor: Colors.black,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.green,
                toastLength: Toast.LENGTH_LONG);*/

            Navigator.pop(context);
            /*  Navigator.pushNamedAndRemoveUntil(
                context, "/Dashboard", (Route<dynamic> route) => false);*/
          } else {
            showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          showMsg("Try Again.");
        });
      } else
        showMsg("No Internet Connection.");
    } on SocketException catch (_) {
      // pr.hide();
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
    return AlertDialog(
      content: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  child: Text(
                    "Are you sure about contacting the seller and connecting with him via Whatsapp and sharing your details with him?",
                    style: TextStyle(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.justify,
                  ),
                  padding: const EdgeInsets.all(8.0),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  child: Text(
                    "By confirming you are giving permission to the seller to contact you.",
                    style: TextStyle(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.justify,
                  ),
                  padding: const EdgeInsets.all(8.0),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 18.0, left: 8, right: 8, bottom: 8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: constant.appPrimaryMaterialColor,
                  textColor: Colors.white,
                  splashColor: Colors.white,
                  child: Text("Yes, I Confirm",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  onPressed: () {
                    Navigator.pop(context);
                    _vendorProductInquiry();
                    launch(
                        "https://wa.me/+91${widget.mobile}?text= Product Inquiry \n \n Member Name - ${widget.membername} \n Mobile - ${widget.membermobile} \n Product - ${widget.data["Name"]} \n ");
                    //_openWhatsapp("9558821547");
                  }),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: Padding(
                child: Text(
                  "Cancel",
                  style: TextStyle(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.justify,
                ),
                padding: const EdgeInsets.all(8.0),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
