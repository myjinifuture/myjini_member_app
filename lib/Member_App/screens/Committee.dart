import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Committee extends StatefulWidget {
  @override
  _CommitteeState createState() => _CommitteeState();
}

class _CommitteeState extends State<Committee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: AppBar(
          title: Text(
            "Committee",
            style: TextStyle(fontSize: 18, fontFamily: "OpenSans"),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "General",
                style: TextStyle(
                    fontFamily: "OpenSans", fontWeight: FontWeight.bold),
              ),
              Padding(padding: EdgeInsets.only(top: 8.0)),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
              Padding(padding: EdgeInsets.only(top: 8.0)),
              ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return listviewItem();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  listviewItem() {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Card(
        elevation: 2,
        color: Colors.deepPurple[50],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(1),
                topRight: Radius.circular(1),
                bottomRight: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    "images/unnamed.png",
                    color: Colors.grey,
                    width: MediaQuery.of(context).size.width / 7,
                    height: MediaQuery.of(context).size.height / 11,
                  ),
                  Padding(padding: EdgeInsets.only(left: 5.0)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Vishal Chauhan",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "OpenSans",
                                fontSize: 14),
                          ),
                          Padding(padding: EdgeInsets.only(left: 80.0)),
                          Container(
                            height: MediaQuery.of(context).size.height / 25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.white),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("D - 2122",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: "OpenSans")),
                            ),
                          )
                        ],
                      ),
                      Text(
                        "Secretory",
                        style: TextStyle(
                            color: Colors.orange[900],
                            fontFamily: "OpenSans",
                            fontSize: 12),
                      ),
                      Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 28,
                            child: Row(
                              children: [
                                InkWell(
                                    onTap: () {},
                                    child: Image.asset(
                                        "images/whatsapp-social-media-pngrepo-com.png",
                                        height: 20)),
                                Padding(padding: EdgeInsets.only(left: 5.0)),
                                Text(
                                  "Message",
                                  style: TextStyle(
                                      fontFamily: "OpenSans",
                                      fontSize: 12,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 50.0)),
                          InkWell(
                            child: Container(
                              height: MediaQuery.of(context).size.height / 25,
                              child: Row(
                                children: [
                                  Image.asset(
                                      "images/phone-call-phone-pngrepo-com.png",
                                      width: 15,
                                      color: Colors.blue[900]),
                                  Padding(padding: EdgeInsets.only(left: 5.0)),
                                  Text("Call",
                                      style: TextStyle(
                                          fontFamily: "OpenSans",
                                          fontSize: 12,
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
