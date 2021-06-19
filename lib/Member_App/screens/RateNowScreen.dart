import 'package:flutter/material.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'dart:io';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RateNowScreen extends StatefulWidget {
  String staffId;

  RateNowScreen({this.staffId});
  @override
  _RateNowScreenState createState() => _RateNowScreenState();
}

class _RateNowScreenState extends State<RateNowScreen> {
  TextEditingController reviewController = TextEditingController();
  double ratingValue;

  addStaffReview() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String societyId = prefs.getString(constant.Session.SocietyId);
        String memberId = prefs.getString(constant.Session.Member_Id);
        var data = {
          "societyId": societyId,
          "staffId": widget.staffId,
          "rating": ratingValue.toString(),
          "ratingMemberId": memberId,
          "review": reviewController.text,
        };
        print("sent data:");
        print(data);
        Services.responseHandler(
                apiName: "member/addStaffRating", body: data)
            .then((data) async {
          if (data.Data.toString() == "1" && data.IsSuccess == true) {
              Fluttertoast.showToast(
                  msg: "Review Submitted Successfully",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);

              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/DailyServicesScreen');
          } else {
            // showMsg("Complaint Is Not Added To Solved");
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
        });
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
    }
  }

  showMsg(String msg, {String title = 'My JINI'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate and Review'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.star,
                    size: 28,
                    color: Colors.amber,
                  ),
                  Icon(
                    Icons.star,
                    size: 28,
                    color: Colors.amberAccent,
                  ),
                  Icon(
                    Icons.star,
                    size: 28,
                    color: Colors.amberAccent,
                  ),
                  GradientText(
                    text: 'Please Submit\nYour Feedback'.toUpperCase(),
                    textAlign: TextAlign.center,
                    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.star,
                    size: 28,
                    color: Colors.amberAccent,
                  ),
                  Icon(
                    Icons.star,
                    size: 28,
                    color: Colors.amberAccent,
                  ),
                  Icon(
                    Icons.star,
                    size: 28,
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 2.5,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Please Rate This Staff :'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '( OUT OF 5 )',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      RatingBar.builder(
                        itemSize: 50,
                        initialRating: 0,
                        direction: Axis.horizontal,
                        itemPadding: EdgeInsets.only(left: 8.0),
                        itemCount: 5,
                        glow: false,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            ratingValue = rating;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 8.0,
                              ),
                              child: Text(
                                'Please give your feedback here :'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: DottedDecoration(
                            shape: Shape.box,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            controller: reviewController,
                            keyboardType: TextInputType.text,
                            maxLines: 4,
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: constant.appPrimaryMaterialColor,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                  left: 20,
                  right: 20,
                ),
                child: Text(
                  'Submit'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              onPressed: () {
                addStaffReview();
              },
            )
          ],
        ),
      ),
    );
  }
}
