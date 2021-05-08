import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class StaffReviewListingScreen extends StatefulWidget {
  var ratingsData;

  StaffReviewListingScreen({this.ratingsData});

  @override
  _StaffReviewListingScreenState createState() =>
      _StaffReviewListingScreenState();
}

class _StaffReviewListingScreenState extends State<StaffReviewListingScreen> {
  @override
  Widget build(BuildContext context) {
    print("widget.ratingsData");
    print(widget.ratingsData);
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                // shrinkWrap: true,
                itemCount: widget.ratingsData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(elevation: 3,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  width:MediaQuery.of(context).size.width,
                                  child: Card(
                                    color: Colors.grey[400],child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      widget.ratingsData[index]["review"],
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              RatingBar.builder(
                                itemSize: 25,
                                initialRating: double.parse(widget
                                    .ratingsData[index]["rating"]
                                    .toString()),
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star_rate_rounded,
                                  color: Colors.amber,
                                ),
                                ignoreGestures: true,
                                // onRatingUpdate: (rating) {
                                //   print(rating);
                                // },
                              ),
                              SizedBox(width: 5,),
                              Text(
                                "${widget.ratingsData[index]["rating"].toString()}.0",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  // color: Colors.grey,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
