import 'package:flutter/material.dart';
import '../screens/SingleEntry.dart';

class MyInvoice extends StatefulWidget {
  @override
  _MyInvoiceState createState() => _MyInvoiceState();
}

class _MyInvoiceState extends State<MyInvoice> {
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
            "MY Invoices",
            style: TextStyle(fontSize: 18, fontFamily: "OpenSans"),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            onPressed: () {
              AlertDialogopen();
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  AlertDialogopen() {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  backgroundColor: Colors.white,
                  shape: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                      width: 2
                    ),
                      borderRadius: BorderRadius.circular(16.0)),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Select Single Entry or Multiple \nEntry ..?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: "OpenSans"),
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.close_sharp,
                            color: Colors.black,
                            size: 20.0,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  content: Container(
                    height: 60,
                    child: Row(
                      children: [
                        RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SingleEntry()));
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.deepPurple,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Text(
                              "Single Entry",
                              style: TextStyle(
                                  fontFamily: "OpenSans",
                                  color: Colors.white,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                        Padding(padding: new EdgeInsets.only(left: 10.0)),
                        RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return MultipleSelectPopUp();
                                });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.deepPurple,
                          child: Text(
                            "Multiple Entry",
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                color: Colors.white,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return SizedBox();
        });
  }
}

class MultipleSelectPopUp extends StatefulWidget {
  @override
  _MultipleSelectPopUpState createState() => _MultipleSelectPopUpState();
}

class _MultipleSelectPopUpState extends State<MultipleSelectPopUp> {

  bool isCheck = false;
  bool isCheck1 = false;
  bool isAll = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
         side: BorderSide(
             color: Colors.deepPurple,
             width: 2
         )
      ),
      title: Row(
        children: [
          Text(
            "Multiple Select Entry",
            style: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
          Padding(
            padding: EdgeInsets.only(left: 45),
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.close_sharp,
                color: Colors.black,
                size: 20.0,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      content: Container(
        height: 120,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                      value: isAll,
                      onChanged: (bool value) {
                        setState(() {
                          isAll = value;
                          this.isCheck = value;
                          this.isCheck1 = value;
                        });
                      }),
                  Text(
                    "Select All Wing",
                    style: TextStyle(fontSize: 12, fontFamily: "OpenSans"),
                  )
                ],
              ),
              Row(
                children: [
                  Checkbox(
                      value: isCheck,
                      onChanged: (bool value) {
                        setState(() {
                          isCheck = value;
                        });
                      }),
                  Text(
                    "A",
                    style: TextStyle(fontFamily: "OpenSans"),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                      value: isCheck1,
                      onChanged: (bool value) {
                        setState(() {
                          isCheck1 = value;
                        });
                      }),
                  Text(
                    "B",
                    style: TextStyle(fontFamily: "OpenSans"),
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
