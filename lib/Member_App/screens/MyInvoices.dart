import 'package:flutter/material.dart';

class MyInvoices extends StatefulWidget {
  @override
  _MyInvoicesState createState() => _MyInvoicesState();
}

class _MyInvoicesState extends State<MyInvoices> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Pending",
                ),
                Tab(text: "Paid"),
              ],
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
            title: Text(
              "MY Invoices",
              style: TextStyle(fontSize: 18,fontFamily: "OpenSans"),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Pending(),
            Text(""),
          ],
        ),
      ),
    );
  }

  Pending() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) => Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Proforma Invoice#1480",
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(padding: EdgeInsets.only(left: 122)),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF00796B),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.text_snippet_sharp,
                                  color: Colors.white,
                                  size: 16,
                                )),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 4.0)),
                      Text(
                        "GGATE DEMO",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Maintenance for C1-211",
                        style: TextStyle(
                            color: Color(0xFFeba134),
                            fontSize: 12,
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.only(top: 6.0)),
                      Row(
                        children: [
                          Text("Total amount",
                              style: TextStyle(
                                  fontFamily: "OpenSans", fontSize: 12)),
                          Padding(padding: EdgeInsets.only(left: 198)),
                          Text("₹2596",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                  fontFamily: "OpenSans")),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 6.0)),
                      Row(
                        children: [
                          Text(
                            "Issued on: 15 May 2021",
                            style: TextStyle(
                                color: Color(0xffeba134),
                                fontSize: 12,
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(padding: EdgeInsets.only(left: 48)),
                          Text("Due date:22 Feb 2021",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00796B),
                                  fontFamily: "OpenSans")),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:95.0,),
                            child: RaisedButton(
                              onPressed: () {

                              },shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                            ),
                              color: Color(0xFFE0F2F1),
                              child: Padding(
                                padding: const EdgeInsets.only(left:20.0,right: 20.0),
                                child: Text(
                                  "Pay Now",
                                  style: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontSize: 12,
                                    color: Color(0xFF00796B),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
