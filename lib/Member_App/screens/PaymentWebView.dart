import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:http/http.dart' as http;
import 'package:smart_society_new/Member_App/component/LoadingComponent.dart';

class PaymentWebView extends StatefulWidget {
  var data;

  PaymentWebView(this.data);

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  String cancelLbl = "Cancel";
  ProgressDialog pr;
  bool isLoading = true;

  void initState() {
    super.initState();
    print("key:" + widget.data["key"]);
    print("title:" + widget.data["title"]);
    print("token:" + widget.data["token"]);
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            valueColor:
                new AlwaysStoppedAnimation<Color>(cnst.appPrimaryMaterialColor),
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    sendMemberPaymentId("123456");
    //createRequest(); //creating the HTTP request
// Add a listener on url changed
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        if (url.contains('http://www.example.com/redirect')) {
          Uri uri = Uri.parse(url);
//Take the payment_id parameter of the url.
          String paymentRequestId = uri.queryParameters['payment_id'];
//calling this method to check payment status
          _checkPaymentStatus(paymentRequestId);
        }
      }
    });
  }

  showSucDialog(String PaymentIs) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Success!',
                        style: TextStyle(
                            color: cnst.appPrimaryMaterialColor, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(
                        'Your payment is complete.',
                        style: TextStyle(
                            color: cnst.appPrimaryMaterialColor, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(
                        "Your Transaction ID Is ${PaymentIs}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      margin: EdgeInsets.only(top: 40),
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0)),
                        color: Colors.green,
                        minWidth: MediaQuery.of(context).size.width / 2,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/HomeScreen', (Route<dynamic> route) => false);
                        },
                        child: Text(
                          "Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  showFailedDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: cnst.appPrimaryMaterialColor,
                          shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Oh no!',
                        style: TextStyle(
                            color: cnst.appPrimaryMaterialColor, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(
                        'Something went wrong.\nPlease try again.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: cnst.appPrimaryMaterialColor, fontSize: 18),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      margin: EdgeInsets.only(top: 40),
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0)),
                        color: cnst.appPrimaryMaterialColor,
                        minWidth: MediaQuery.of(context).size.width / 2,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/HomeScreen', (Route<dynamic> route) => false);
                        },
                        child: Text(
                          "Try again",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future createRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _name = prefs.getString(Session.Name);
    String _mobile = prefs.getString(Session.session_login);
    print("_mobile No = ${_mobile}");

    Map<String, String> body = {
      "amount": "${widget.data["amount"]}", //amount to be paid
      "purpose": "Post Advertisement",
      "buyer_name": "${_name}",
      "email": "",
      "phone": "${_mobile}",
      "allow_repeated_payments": "true",
      "send_email": "false",
      "send_sms": "false",
      "redirect_url": "http://www.example.com/redirect/",
      "webhook": "http://www.example.com/webhook/"
    };

//First we have to create a Payment_Request.
//then we'll take the response of our request.
    var resp = await http.post(
        Uri.encodeFull("https://www.instamojo.com/api/1.1/payment-requests/"),
        //Uri.encodeFull("https://test.instamojo.com/api/1.1/payment-requests/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "${widget.data["InstaMojoKey"]}",
          "X-Auth-Token": "${widget.data["InstaMojoToken"]}",
        },
        body: body);
    print("Respo = ${resp.body}");

    if (json.decode(resp.body)['success'] == true) {
//If request is successful take the longurl.
      //// pr.hide();
      String selectedUrl =
          json.decode(resp.body)["payment_request"]['longurl'].toString() +
              "?embed=form";
      flutterWebviewPlugin.close();
//Let's open the url in webview.
      flutterWebviewPlugin.launch(
        selectedUrl,
        rect: new Rect.fromLTRB(
            5.0,
            MediaQuery.of(context).size.height / 7,
            MediaQuery.of(context).size.width - 5.0,
            7 * MediaQuery.of(context).size.height / 7),
        //userAgent: kAndroidUserAgent
      );
    } else {
      //_showSnackbar(json.decode(resp.body)['message'].toString());
      //// pr.hide();
      print(
          "error = ${json.decode(resp.body)['message']["amount"].toString()}");
      showMsg("${json.decode(resp.body)['message'].toString()}");
    }
  }

  _checkPaymentStatus(String id) async {
    var response = await http.get(
        Uri.encodeFull("https://www.instamojo.com/api/1.1/payments/$id/"),
        // Uri.encodeFull("https://test.instamojo.com/api/1.1/payments/$id/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "${widget.data["InstaMojoKey"]}",
          "X-Auth-Token": "${widget.data["InstaMojoToken"]}",
          "X-XSS-Protection": "0; mode=block"
        });
    setState(() {
      cancelLbl = "";
    });
    var realResponse = json.decode(response.body);
    print("Final Response = ${realResponse}");
    if (realResponse['success'] == true) {
      if (realResponse["payment"]['status'] == 'Credit') {
//payment is successful.
        flutterWebviewPlugin.close();
        /*await sendMemberPaymentId(
            realResponse["payment"]['payment_id'].toString());*/
        if (widget.data["renew"] == "true") {
          await sendMemberPaymentIdForRenew(
              realResponse["payment"]['payment_id'].toString());
        }
        await sendMemberPaymentId(
            realResponse["payment"]['payment_id'].toString());
        await showSucDialog(realResponse["payment"]['payment_id'].toString());
        //Navigator.pushReplacementNamed(context, '/Suc');
      } else {
        flutterWebviewPlugin.close();
//payment failed or pending.
        showFailedDialog();
        //Navigator.pushReplacementNamed(context, '/failed');
      }
    } else {
      flutterWebviewPlugin.close();
      showFailedDialog();
      print("PAYMENT STATUS FAILED");
    }
  }

  sendMemberPaymentId(String tId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(Session.Member_Id);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String filename = "";
        String filePath = "";
        File compressedFile;

        if (widget.data["photo"] != null) {
          ImageProperties properties =
              await FlutterNativeImage.getImageProperties(
                  widget.data["photo"].path);

          compressedFile = await FlutterNativeImage.compressImage(
            widget.data["photo"].path,
            quality: 80,
            targetWidth: 600,
            targetHeight: (properties.height * 600 / properties.width).round(),
          );

          filename = widget.data["photo"].path.split('/').last;
          filePath = compressedFile.path;
        }

        FormData formData = new FormData.fromMap({
          "Id": 0,
          "Title": widget.data["title"],
          "Description": widget.data["desc"],
          "File": (filePath != null && filePath != '')
              ? await MultipartFile.fromFile(filePath,
                  filename: filename.toString())
              : null,
          "MemberId": MemberId,
          "PackageId": "${widget.data["packageId"]}",
          "ExpiryDate": widget.data["expiredDate"].toString(),
          "Type": "${widget.data["type"]}",
          "TargetedId": "${widget.data["targetedId"]}",
          "PaymentMode": "Online",
          "ReferenceNo": "${tId}",
          "Date": "${DateTime.now().toString()}",
          "WebsiteURL": "${widget.data["WebsiteURL"]}",
          "GoogleMap": "${widget.data["GoogleMap"]}",
          "EmailId": "${widget.data["Email"]}",
          "VideoLink": "${widget.data["VideoLink"]}",
        });

        print("SaveAdvertisement Data = ${formData}");
        Services.SaveAdvertisement(formData).then((data) async {
          if (data.Data != "0" && data.IsSuccess == true) {
            showMsg(data.Message, title: "Success");
          } else {
            showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          showMsg("Try Again.");
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  sendMemberPaymentIdForRenew(String tId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(Session.Member_Id);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String filename = "";
        String filePath = "";
        File compressedFile;

        if (widget.data["photo"] != null) {
          ImageProperties properties =
              await FlutterNativeImage.getImageProperties(
                  widget.data["photo"].path);

          compressedFile = await FlutterNativeImage.compressImage(
            widget.data["photo"].path,
            quality: 80,
            targetWidth: 600,
            targetHeight: (properties.height * 600 / properties.width).round(),
          );

          filename = widget.data["photo"].path.split('/').last;
          filePath = compressedFile.path;
        }

        FormData formData = new FormData.fromMap({
          "Id": "${widget.data["id"]}",
          "Title": widget.data["title"],
          "Description": widget.data["desc"],
          "Image": (filePath != null && filePath != '')
              ? await MultipartFile.fromFile(filePath,
                  filename: filename.toString())
              : null,
          "MemberId": MemberId,
          "PackageId": "${widget.data["packageId"]}",
          "ExpiryDate": widget.data["expiredDate"].toString(),
          "Type": "${widget.data["type"]}",
          "TargetedId": "${widget.data["targetedId"]}",
          "PaymentMode": "Online",
          "ReferenceNo": "${tId}",
          "date": "${DateTime.now().toString()}",
          "WebsiteURL": "${widget.data["WebsiteURL"]}",
          "GoogleMap": "${widget.data["GoogleMap"]}",
          "Email": "${widget.data["Email"]}",
          "VideoLink": "${widget.data["VideoLink"]}",
        });

        print("SaveAdvertisement Data = ${formData}");
        Services.SaveAdvertisementForRenew(formData).then((data) async {
          if (data.Data != "0" && data.IsSuccess == true) {
            showMsg(data.Message, title: "Success");
          } else {
            showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          showMsg("Try Again.");
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg, {String title = 'MYJINI'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();;
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/HomeScreen', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        appBar: AppBar(
          title: Text("Payment Process"),
          leading: Text(""),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                flutterWebviewPlugin.close();
                //showSucDialog();
                showFailedDialog();
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${cancelLbl}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isLoading == true ? LoadingComponent() : Container(),
        ),
      ),
    );
  }
}
