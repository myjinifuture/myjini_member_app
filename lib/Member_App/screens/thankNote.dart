import 'package:flutter/material.dart';

class ThankNote extends StatefulWidget {

  @override
  _ThankNoteState createState() => _ThankNoteState();
}

class _ThankNoteState extends State<ThankNote> {

  bool isPressed1=true;
  bool isPressed2=false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          leading: IconButton(icon:Icon(Icons.arrow_back_ios_sharp,size: 20,),color: Colors.white,onPressed: (){Navigator.pop(context);},),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          centerTitle: true,
          title: Text(
            'RECORD TYFCB',
            style: TextStyle(
              fontFamily: "OpenSans",fontSize: 18,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
                padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                onPressed: () {},
                icon: Icon(
                  Icons.help_outline_sharp,
                  size: 25,
                  color: Colors.white,
                ))
          ],
          ),
        body: Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top:10.0)),
                    TextField(
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintStyle:
                        TextStyle(fontSize: 20, color: Colors.grey),
                        suffixIcon: Icon(
                          Icons.search_sharp,
                          size: 25,
                          color: Colors.deepPurple,
                        ),
                        isDense: true,
                        hintText: 'Thank you to:',
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(7))),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top:10.0),),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 17.0,vertical: 8.0),
                            child: Text('\u{20B9}',style: TextStyle(color:Colors.deepPurple,fontSize: 25),),
                            height: 53.0,
                            width: 53.0,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(7),
                                  bottomLeft: Radius.circular(7)
                              ),
                            ),
                          ),
                          Container(
                            height: 53.0,
                            width: MediaQuery.of(context).size.width*0.74,
                            child: TextField(
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintStyle: TextStyle(
                                    fontSize: 20, color: Colors.grey),
                                isDense: true,
                                hintText: 'Amount',
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.only(topRight: Radius.circular(7),bottomRight: Radius.circular(7))),
                              ),
                            ),
                          ),
                        ]),
                    Padding(padding: EdgeInsets.only(top:30)),
                    Text('Referral Type',style: TextStyle(),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MaterialButton(
                          minWidth: MediaQuery.of(context).size.width * 0.47,
                          child: Text(
                            'Self',
                            style: TextStyle(fontSize: 18,color: isPressed1 ? Colors.white : Colors.deepPurple  ),
                          ),
                          color: isPressed1 ? Colors.deepPurple : Colors.white ,
                          onPressed: () {
                            setState(() {
                              isPressed1 = true;
                              isPressed2=false;
                            });
                          },
                        ),
                        MaterialButton(
                          minWidth: MediaQuery.of(context).size.width * 0.47,
                          child: Text(
                            'Outside',
                            style: TextStyle(fontSize: 18,color: isPressed2 ? Colors.white : Colors.deepPurple),
                          ),
                          color: isPressed2 ? Colors.deepPurple : Colors.white ,
                          onPressed: () {
                            setState(() {
                              isPressed1 = false;
                              isPressed2=true;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    TextField(
                      style: TextStyle(fontSize: 20),
                      maxLines: 4,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
                        isDense: true,
                        hintText: 'Comments',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                      ),
                    ),
                    SizedBox(height:20),
                    Center(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        height: 40,
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 18,color: Colors.white),
                        ),
                        color: Colors.deepPurple,
                        onPressed: () {},
                      ),
                    ),
                  ]
              ),
            )
        )
    );
  }
}


