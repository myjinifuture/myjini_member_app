import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Admin_App/Common/Constants.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitorComponent extends StatefulWidget {
  var _visitorData;
  int index;

  VisitorComponent(this._visitorData, this.index);

  @override
  _VisitorComponentState createState() => _VisitorComponentState();
}

class _VisitorComponentState extends State<VisitorComponent> {
  setTime(String datetime) {
    String hour = "";
    var time = datetime.split(" ");
    var t = time[1].split(":");
    if (int.parse(t[0]) > 12) {
      hour = (int.parse(t[0]) - 12).toString();
      return "${hour}:${t[1]} PM";
    } else {
      hour = int.parse(t[0]).toString();
      return "${hour}:${t[1]} AM";
    }
  }

  @override
  Widget build(BuildContext context) {
    print("widget._visitorData");
    print(widget._visitorData);
    return AnimationConfiguration.staggeredList(
      position: widget.index,
      duration: const Duration(milliseconds: 450),
      child: SlideAnimation(
        horizontalOffset: 50.0,
        child: FadeInAnimation(
          child: Card(
            margin: EdgeInsets.only(top: 4, right: 8, left: 8, bottom: 6),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              padding: EdgeInsets.only(right: 10, top: 7, left: 7, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                      child: widget._visitorData["guestImage"] != null &&
                              widget._visitorData["guestImage"] != ""
                          ? FadeInImage.assetNetwork(
                              placeholder: '',
                              image: Image_Url +
                                  "${widget._visitorData["guestImage"]}",
                              width: 50,
                              height: 50,
                              fit: BoxFit.fill)
                          : Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: cnst.appPrimaryMaterialColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: Center(
                                child: Text(
                                  "${widget._visitorData["Name"].toString().substring(0, 1).toUpperCase()}",
                                  style: TextStyle(
                                      fontSize: 26, color: Colors.white),
                                ),
                              ),
                            )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${widget._visitorData["Name"]}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          widget._visitorData["GuestCategory"].length==0 ? Text("No guest category") :
                          Text('${widget._visitorData["GuestCategory"][0]["guestType"]}',
                              style: TextStyle(fontSize: 12)),
                          Text(
                              '${widget._visitorData["WingData"][0]["wingName"]}'
                              '-'
                              '${widget._visitorData["FlatData"][0]["flatNo"]}'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.arrow_downward,
                                color: Colors.green,
                              ),
                              widget._visitorData["inDateTime"].length==0 ?
                              Text("No Intime Found"):
                              Text("${widget._visitorData["inDateTime"][1]}"),
                              widget._visitorData["outDateTime"].length==0 ||
                                      widget._visitorData["outDateTime"] == ""
                                  ? Container()
                                  : Icon(
                                      Icons.arrow_upward,
                                      color: Colors.red,
                                    ),
                              widget._visitorData["outDateTime"].length==0  ||
                                      widget._visitorData["outDateTime"] == ""
                                  ? Container()
                                  : Text(
                                      "${widget._visitorData["outDateTime"][1]}"),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  widget._visitorData["GuestCategory"].length == 0
                      ? Row(
                          children: <Widget>[
                            Image.network(
                              IMG_URL + widget._visitorData["companyImage"],
                              width: 22,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('${widget._visitorData["companyImage"]}',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
