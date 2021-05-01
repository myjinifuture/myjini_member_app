import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherHelpComponent extends StatefulWidget {
  var maidData;

  OtherHelpComponent(this.maidData);

  @override
  _OtherHelpComponentState createState() => _OtherHelpComponentState();
}

class _OtherHelpComponentState extends State<OtherHelpComponent> {
  setTime(String datetime) {
    var time = datetime.split(" ");
    var t = time[1].split(":");
    var meridiam = "";
    if (int.parse(t[0]) > 12) {
      meridiam = "PM";
      t[0] = (int.parse(t[0]) - 12).toString();
    } else {
      meridiam = "AM";
    }
    return "${t[0]}:${t[1]} ${meridiam}";
  }

  var newDt;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // newDt = DateFormat.yMMMEd().format(DateTime.parse(widget.data["DateOfJoin"]));
    // newDt = "${newDt.toString().split(",")[1]}" +
    //     "${newDt.toString().split(",")[2]}";
    // print(newDt);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                widget.maidData["StaffData"][0]["staffImage"] != null &&
                    widget.maidData["StaffData"][0]["staffImage"] != ""
                    ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipOval(
                        child: /*widget._staffInSideList["Image"] == null && widget._staffInSideList["Image"] == '' ?*/
                        FadeInImage.assetNetwork(
                            placeholder: 'images/user.png',
                            image:
                            "${Image_Url}${widget.maidData["StaffData"][0]["staffImage"]}",
                            width: 50,
                            height: 50,
                            fit: BoxFit.fill)))
                    : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipOval(
                        child: Image.asset(
                          'images/user.png',
                          width: 50,
                          height: 50,
                        ))),
                Container(
                  width: MediaQuery.of(context).size.width / 1.63,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("${widget.maidData["StaffData"][0]["Name"]}".toUpperCase(),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                      Row(
                        children: <Widget>[
                          Text("${widget.maidData["StaffData"][0]["staffCategory"]}",
                              style: TextStyle(color: Colors.black)),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, bottom: 4.0, top: 4.0),
                            child: widget.maidData.length > 0
                                ? widget.maidData["outDateTime"].length == 0
                                ? Container(
                              height: 20,
                              width: 60,
                              child: Center(
                                  child: Text('Inside',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 12))),
                              decoration: BoxDecoration(
                                  color: Colors.green[500],
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(6.0))),
                            )
                                : Container(
                              height: 20,
                              width: 60,
                              child: Center(
                                  child: Text('OutSide',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 12))),
                              decoration: BoxDecoration(
                                  color: Colors.red[500],
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(6.0))),
                            )
                                : Container(),
                          )
                        ],
                      ),
                      // Text(widget.maidData["StaffData"][0]["staffCategory"]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.arrow_downward,
                            color: Colors.green,
                          ),
                          Text("${widget.maidData["inDateTime"][1]}"),
                          widget.maidData["outDateTime"].length == 0
                              ? Container()
                              : Icon(
                            Icons.arrow_upward,
                            color: Colors.red,
                          ),
                          widget.maidData["outDateTime"].length == 0
                              ? Container()
                              : Text("${widget.maidData["outDateTime"][1]}"),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 9, right: 7),
                  child: GestureDetector(
                      onTap: () {
                        launch("tel:${widget.maidData["ContactNo"]}");
                      },
                      child: Icon(Icons.phone, color: Colors.green, size: 25)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      launch("tel:${widget.maidData["EmergencyContactNo"]}");
                    },
                    child: Image.asset("images/emergancycall.png",
                        color: Colors.red, height: 25, width: 25),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
