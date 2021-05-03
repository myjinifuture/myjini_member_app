import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as constant;
import 'package:smart_society_new/Admin_App/Screens/StaffProfile.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffComponent extends StatefulWidget {
  var index, staffData;

  StaffComponent({this.index, this.staffData});

  @override
  _StaffComponentState createState() => _StaffComponentState();
}

class _StaffComponentState extends State<StaffComponent> {
  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: widget.index,
      duration: const Duration(milliseconds: 450),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Card(
            margin: EdgeInsets.all(6),
            child: Container(
              padding: EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  widget.staffData["Image"] != '' &&
                          widget.staffData["Image"] != null
                      ? FadeInImage.assetNetwork(
                          placeholder: '',
                          image: Image_Url +
                              "${widget.staffData["Image"]}",
                          width: 60,
                          height: 60,
                          fit: BoxFit.fill)
                      : Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: constant.appPrimaryMaterialColor,
                          ),
                          child: Center(
                            child: Text(
                              "${widget.staffData["Name"].toString().substring(0, 1).toUpperCase()}",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ),
                  Padding(padding: EdgeInsets.only(left: 8)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${widget.staffData["Name"]}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: constant.appPrimaryMaterialColor),
                        ),
                        Text(
                          "${widget.staffData["ContactNo"]}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.grey[600]),
                        ),
                        Text(
                          "${widget.staffData["Work"]}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.call,
                        color: Colors.green[700],
                      ),
                      onPressed: () {
                        launch("tel:" + widget.staffData["ContactNo"]);
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StaffProfile(
                                      staffData: widget.staffData,
                                    )));
                        //Navigator.pushNamed(context, '/EditStaff');
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
