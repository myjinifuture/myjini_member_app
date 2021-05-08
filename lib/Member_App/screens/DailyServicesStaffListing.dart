import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/DailyServicesStaffProfileScreen.dart';

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
  Widget build(BuildContext context) {
    print("widget.staffData");
    print(widget.staffData);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              // shrinkWrap: true,
              itemCount: widget.staffData["StaffCount"],
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DailyServicesStaffProfileScreen(
                          categoryName: widget.title,
                          staffProfileData: widget.staffData["StaffData"][index],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
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
                            widget.staffData["StaffData"][index]
                                        ["staffImage"] ==
                                    ""
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipOval(
                                      child: FadeInImage.assetNetwork(
                                          placeholder: 'images/user.png',
                                          image:
                                              "${constant.Image_Url}${widget.staffData["StaffData"][index]["staffImage"]}",
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fill),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'images/user.png',
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                  ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.staffData["StaffData"][index]["Name"]
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                                widget.staffData["StaffData"][index]
                                            ["AverageRating"] ==
                                        null
                                    ? Container()
                                    : Row(
                                        children: [
                                          Icon(
                                            Icons.star_rate_rounded,
                                            color: Colors.amberAccent,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            '${widget.staffData["StaffData"][index]["AverageRating"].toString()}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                Text(
                                  widget.staffData["StaffData"][index]
                                              ["NoOfWorkingFlats"] >
                                          1
                                      ? '${widget.staffData["StaffData"][index]["NoOfWorkingFlats"].toString()} HOUSES'
                                      : '${widget.staffData["StaffData"][index]["NoOfWorkingFlats"].toString()} HOUSE',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                )
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
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
