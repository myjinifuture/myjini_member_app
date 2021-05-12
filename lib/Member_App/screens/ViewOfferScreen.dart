import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

class ViewOfferScreen extends StatefulWidget {
  var offersDisplayData;
  int count;

  ViewOfferScreen({this.offersDisplayData,this.count});

  @override
  _ViewOfferScreenState createState() => _ViewOfferScreenState();
}

class _ViewOfferScreenState extends State<ViewOfferScreen> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    print("widget.offersDisplayData");
    print(widget.offersDisplayData);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  top: 10,
                  bottom: 10,
                  right: 5,
                ),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    color: Colors.grey,
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: "images/deals.png",
                    image:
                        cnst.Image_Url + '${widget.offersDisplayData["Image"]}',
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.offersDisplayData["DealName"],
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5.0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Colors.grey,
                          size: 23,
                        ),
                        Text(
                          'Vesu',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Special Deals',
                  style: TextStyle(
                    letterSpacing: 4.5,
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(0),
              itemCount: widget.count,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.grey,
                    width: 0.1,
                  )),
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.offersDisplayData["DealName"],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                widget.offersDisplayData["TermsAndCondition"] !=
                                        ""
                                    ? Text(
                                        widget.offersDisplayData[
                                            "TermsAndCondition"],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    : Container(),
                                Text(
                                  widget.offersDisplayData["Description"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  ' ${cnst.Inr_Rupee}50 ',
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Text(
                                    ' ₹250 ',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '26% Off',
                              style: TextStyle(
                                color: Color(0xff289986),
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (count == 0) {
                                        setState(() {
                                          count = 0;
                                        });
                                      } else {
                                        setState(() {
                                          count--;
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5.0,
                                      right: 5.0,
                                    ),
                                    child: Text(
                                      count.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        count++;
                                      });
                                    },
                                    child: Icon(
                                      Icons.add_circle,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
      bottomNavigationBar: Container(
        color: Colors.grey[300],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
              ),
              child: Text(
                'Total Cost: 0',
                style: TextStyle(
                  color: Colors.grey[600],
                  // fontWeight: FontWeight.w600,
                  // fontSize: 16,
                ),
              ),
            ),
            Text(
              'Savings: 0',
              style: TextStyle(
                color: Color(0xff289986),
                // fontWeight: FontWeight.w600,
                // fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 8.0,
              ),
              child: RaisedButton(
                color: Colors.red,
                child: Text(
                  "BUY",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
