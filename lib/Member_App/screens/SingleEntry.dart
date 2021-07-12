import 'package:flutter/material.dart';

class SingleEntry extends StatefulWidget {
  @override
  _SingleEntryState createState() => _SingleEntryState();
}

class _SingleEntryState extends State<SingleEntry> {
  int _value = 1;
  int _Value = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
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
            "Single Entry",
            style: TextStyle(fontSize: 18, fontFamily: "OpenSans"),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 15,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  DropdownButton(
                      autofocus: true,
                      underline: SizedBox(),
                      icon: Icon(Icons.arrow_right,color: Colors.deepPurple,),
                      isExpanded: true,
                      value: _value,
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            "Select wing",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "OpenSans",
                                fontSize: 12),
                          ),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            "A",
                            style:
                                TextStyle(fontFamily: "OpenSans", fontSize: 12),
                          ),
                          value: 2,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            "B",
                            style:
                                TextStyle(fontFamily: "OpenSans", fontSize: 12),
                          ),
                          value: 3,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      }),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Container(
              height: MediaQuery.of(context).size.height / 15,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    icon: Icon(Icons.arrow_right,color: Colors.deepPurple,),
                      underline: SizedBox(),
                      isExpanded: true,
                      autofocus: true,
                      value: _Value,
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            "Select Flat",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "OpenSans",
                                fontSize: 12),
                          ),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            "101",
                            style:
                                TextStyle(fontFamily: "OpenSans", fontSize: 12),
                          ),
                          value: 2,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            "102",
                            style:
                                TextStyle(fontFamily: "OpenSans", fontSize: 12),
                          ),
                          value: 3,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _Value = value;
                        });
                      }),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Container(
              height: MediaQuery.of(context).size.height / 15,
              width:MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding: const EdgeInsets.only(top:13.0,left:8.0,bottom: 8.0,right: 8.0),
                child: Text("Title",style: TextStyle(fontFamily: "OpenSans"),),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Container(
              height: MediaQuery.of(context).size.height / 15,
              width:MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding: const EdgeInsets.only(top:13.0,left:8.0,bottom: 8.0,right: 8.0),
                child: Text("Amount",style: TextStyle(fontFamily: "OpenSans"),),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Container(
              height: MediaQuery.of(context).size.height / 15,
              width:MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding: const EdgeInsets.only(top:13.0,left:8.0,bottom: 8.0,right: 8.0),
                child: Text("Date",style: TextStyle(fontFamily: "OpenSans"),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
