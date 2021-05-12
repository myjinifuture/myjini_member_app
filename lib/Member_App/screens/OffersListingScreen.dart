import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/screens/ViewOfferScreen.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

class OffersListingScreen extends StatefulWidget {
  var offersData;

  OffersListingScreen({this.offersData});

  @override
  _OffersListingScreenState createState() => _OffersListingScreenState();
}

class _OffersListingScreenState extends State<OffersListingScreen> {
  @override
  Widget build(BuildContext context) {
    print("widget.offersData");
    print(widget.offersData);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.offersData["Deal"].length > 0
              ? Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    // shrinkWrap: true,
                    itemCount: widget.offersData["Deal"].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          //height: MediaQuery.of(context).size.height/2.6,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.white,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          FadeInImage.assetNetwork(
                                            placeholder: "images/deals.png",
                                            image: cnst.Image_Url +
                                                '${widget.offersData["Deal"][index]["Image"]}',
                                            width: 50,
                                            height: 50,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.offersData["Deal"][index]
                                                    ["DealName"],
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            25),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.add_location),
                                                  Text(
                                                    'Vesu',
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            25),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.width /
                                                10,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                10,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        10))),
                                        child: Center(
                                            child: Text(
                                          '4.6',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  22),
                                        )),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Divider(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 8, 10, 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              widget.offersData["Deal"][index]
                                                  ["Description"],
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          25),
                                            ),
                                            Spacer()
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'You save ₹250 |',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    25),
                                          ),
                                          TextButton(
                                            onPressed: () {},
                                            child: Text(
                                              '+5 more deals at this outlet',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          30),
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Divider(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('10+ people bought'),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewOfferScreen(
                                                  offersDisplayData:
                                                      widget.offersData["Deal"]
                                                          [index],
                                                  count: widget
                                                      .offersData["Deal"]
                                                      .length,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                // border: Border.all(
                                                //   color: Colors.black,
                                                // ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            10))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'VIEW MORE',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text('No Deals Found'),
                ),
        ],
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.width / 8,
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    'SORT',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 25,
                        fontWeight: FontWeight.w300),
                  ),
                  Icon(
                    Icons.sort,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    'FILTER',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 25,
                        fontWeight: FontWeight.w300),
                  ),
                  Icon(
                    Icons.filter_list_sharp,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
