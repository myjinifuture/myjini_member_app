import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/DailyServicesStaffProfileScreen.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:smart_society_new/Member_App/screens/RateNowScreen.dart';

class DailyServicesStaffListing extends StatefulWidget {
  String title;
  var staffData;

  DailyServicesStaffListing({this.title, this.staffData});

  @override
  _DailyServicesStaffListingState createState() =>
      _DailyServicesStaffListingState();
}

class _DailyServicesStaffListingState extends State<DailyServicesStaffListing> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: widget.staffData["StaffCount"].toString()!='0'?Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                // shrinkWrap: true,
                itemCount: widget.staffData["StaffCount"],
                itemBuilder: (BuildContext context, int index) {
                  print( widget.staffData["staffImage"]);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DailyServicesStaffProfileScreen(
                            categoryName: widget.title,
                            staffProfileData: widget.staffData["StaffData"]
                                [index],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              widget.staffData["staffImage"] != null ||
                                  widget.staffData["staffImage"] != ""
                                  ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                  ClipOval(
                                      child: /*widget._staffInSideList["Image"] == null && widget._staffInSideList["Image"] == '' ?*/
                                      FadeInImage.assetNetwork(
                                          placeholder: 'images/user.png',
                                          image:
                                          "${constant.Image_Url}${widget.staffData["staffImage"]}",
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fill))
                              )
                                  : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipOval(
                                      child: Image.asset(
                                        'images/user.png',
                                        width: 50,
                                        height: 50,
                                      ))),
                              // widget.staffData["StaffData"][index]
                              //             ["staffImage"] ==
                              //         ""
                              //     ? Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: ClipOval(
                              //           child: FadeInImage.assetNetwork(
                              //               placeholder: 'images/user.png',
                              //               image:
                              //                   "${constant.Image_Url}${widget.staffData["StaffData"][index]["staffImage"]}",
                              //               width: 80,
                              //               height: 80,
                              //               fit: BoxFit.fill),
                              //         ),
                              //       )
                              //     : Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: ClipOval(
                              //           child: Image.asset(
                              //             'images/user.png',
                              //             width: 80,
                              //             height: 80,
                              //           ),
                              //         ),
                              //       ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.staffData["StaffData"][index]["Name"]
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: constant.appPrimaryMaterialColor,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.staffData["StaffData"][index]
                                                    ["NoOfWorkingFlats"] >
                                                1
                                            ? '${widget.staffData["StaffData"][index]["NoOfWorkingFlats"].toString()} HOUSES'
                                            : '${widget.staffData["StaffData"][index]["NoOfWorkingFlats"].toString()} HOUSE',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: constant.appPrimaryMaterialColor,
                                        ),
                                      ),
                                      widget.staffData["StaffData"][index]
                                                  ["AverageRating"] ==
                                              null
                                          ? Container()
                                          : Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 4.0),
                                                  child: Container(
                                                    height: 2,
                                                    width: 6,
                                                    decoration: BoxDecoration(
                                                      color: constant.appPrimaryMaterialColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 3.0),
                                                  child: Icon(
                                                    Icons.star_rate_rounded,
                                                    color: Colors.amberAccent,
                                                    size: 20,
                                                  ),
                                                ),
                                                Text(
                                                  '${widget.staffData["StaffData"][index]["AverageRating"].toString()}',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: constant.appPrimaryMaterialColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RateNowScreen(
                                            staffId:
                                                widget.staffData["StaffData"]
                                                    [index]["_id"],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      color: Colors.red[100],
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 5.0,
                                          right: 5.0,
                                        ),
                                        child: Row(
                                          children: [
                                            GradientText(
                                              text: 'RATE NOW',
                                              colors: <Color>[
                                                Color(0xffDA44bb),
                                                Color(0xff8921aa)
                                              ],
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Icon(
                                              Icons.star_half_rounded,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  widget.staffData["StaffData"][index]
                                              ["AverageRating"] ==
                                          null
                                      ? Container()
                                      : SizedBox(
                                          height: 5,
                                        ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              right: 5.0,
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: constant.appPrimaryMaterialColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ):Center(child: Text('No Data Found'),),
    );
  }
}
