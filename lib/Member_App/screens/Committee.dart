
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
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text(
            "Committee",
            style: TextStyle(fontSize: 18, fontFamily: "OpenSans"),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.deepPurple],
                stops: [0.1, 7.0],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(11.0),
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
        ),
      ),
    );
  }

  listviewItem() {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: 15.0)),
        Row(
          children: [
            Image.asset(
              "assets/json/dp.png",
              width: MediaQuery.of(context).size.width /7,
              height: MediaQuery.of(context).size.height /11,
            ),
            Padding(padding: EdgeInsets.only(left: 5.0)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Vishal Chauhan",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "OpenSans",
                      fontSize: 14),
                ),
                Padding(padding: EdgeInsets.only(top: 5.0)),
                Text("Committee Member (D-11033)",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFeba134),
                        fontFamily: "OpenSans")),
                Padding(padding: EdgeInsets.only(top: 5.0)),
                Container(
                  height: MediaQuery.of(context).size.height/28,
                  child: RaisedButton(
                    onPressed: () {
                    },shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)
                  ),
                    color: Colors.green,
                    child: Row(
                      children: [
                        Icon(Icons.message_outlined,color: Colors.white,size: 15,),
                        Padding(padding: EdgeInsets.only(left: 5.0)),
                        Text(
                          "Message",
                          style: TextStyle(fontFamily: "OpenSans",fontSize: 10,color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(left: 30.0)),
            Container(
              width: MediaQuery.of(context).size.width / 6.2,
              height: MediaQuery.of(context).size.height /25,
              child: RaisedButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                color: Color(0xFF00796B),
                child: Text(
                  "Call",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "OpenSans",
                      color: Colors.white),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
