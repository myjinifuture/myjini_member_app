import 'dart:io';
import 'dart:io' as i;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';

class ThankNote extends StatefulWidget {

  @override
  _ThankNoteState createState() => _ThankNoteState();
}

class _ThankNoteState extends State<ThankNote> {

  TextEditingController _txtAmount  = TextEditingController();
  TextEditingController _txtcomments  = TextEditingController();

 List memberData = [];
 String _selectedReferralTypeTo;
 i.File imageFile;
 bool isSelected = false;

 @override
 void initState() {
   // TODO: implement initState
   super.initState();
   _getDirectoryListing();
 }

 void _openGallery(BuildContext context) async {
   // ignore: deprecated_member_use
   var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
   this.setState(() {
     imageFile = picture;
   });
   Navigator.of(context).pop();
 }

 void _openCamera(BuildContext context) async {
   // ignore: deprecated_member_use
   var picture = await ImagePicker.pickImage(source: ImageSource.camera);
   this.setState(() {
     imageFile = picture;
   });
   Navigator.of(context).pop();
 }

 Future<void> _showSelectionDialog(BuildContext context) {
   return showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
             title: Text("From where do you want to take the photo?"),
             content: SingleChildScrollView(
               child: ListBody(
                 children: <Widget>[
                   GestureDetector(
                     child: Text("Gallery"),
                     onTap: () {
                       _openGallery(context);
                     },
                   ),
                   Padding(padding: EdgeInsets.all(8.0)),
                   GestureDetector(
                     child: Text("Camera"),
                     onTap: () {
                       _openCamera(context);
                     },
                   )
                 ],
               ),
             ));
       });
 }

 addThankYou(String Amount,String Comments) async {
   try {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     var memberId = prefs.getString(Session.Member_Id);
     print(memberId);
     final result = await InternetAddress.lookup('google.com');
     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
       var body = {
         "thankYouFrom": memberId,
         "thankYouTo": _selectedReferralTypeTo,
         "amount":Amount,
         "comments": Comments
       };
       print("print body......................");
       print(body);
       Services.responseHandler(apiName: "member/addThankYouNote", body: body)
           .then((data) async {
         if (data.Data != null) {
           setState(() {
             print(data.Data);
             Fluttertoast.showToast(
                 msg: "Add Thank You Note Successfully..!!",
                 backgroundColor: Colors.green,
                 gravity: ToastGravity.TOP,
                 textColor: Colors.white);
             Navigator.pop(context);
           });
         } else if (data.Data.toString() == "0") {
           setState(() {
             Fluttertoast.showToast(
                 msg: "Add Thank you Note Rejected!!!",
                 backgroundColor: Colors.red,
                 gravity: ToastGravity.TOP,
                 textColor: Colors.white);
           });
         } else {
           print("Somthing went Wrong");
         }
       }, onError: (e) {
         showMsg("Something Went Wrong Please Try Again");
       });
     }
   } on SocketException catch (_) {
     showMsg("No Internet Connection.");
   }
 }

 showMsg(String msg, {String title = 'MYJINI'}) {
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         title: new Text(title),
         content: new Text(msg),
         actions: <Widget>[
           new FlatButton(
             child: new Text("OK"),
             onPressed: () {
               Navigator.of(context).pop();
               ;
             },
           ),
         ],
       );
     },
   );
 }

 showHHMsg(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                ;
              },
            ),
          ],
        );
      },
    );
  }

  _getDirectoryListing() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var SocietyId = prefs.getString(Session.SocietyId);
      var memberId = prefs.getString(Session.Member_Id);
      print("print member ID+++++++++++++++");
      print(memberId);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {"societyId": SocietyId};
        // setState(() {
        //   isLoading = true;
        // });
        Services.responseHandler(apiName: "admin/directoryListing", body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            if(mounted){setState(() {
              memberData = data.Data;
            });
            print("memberData print..................");
            print(memberData);
          } }else {
            // setState(() {
            //   isLoading = false;
            // });
          }
        }, onError: (e) {
          showHHMsg("Something Went Wrong Please Try Again", "");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
    }
  }

 _setImageView() {
   if (imageFile != null) {
     isSelected = true;
     setState(() {});
     return Stack(
       children: [
         Image.file(
           (imageFile),
           width: MediaQuery.of(context).size.width,
           height: MediaQuery.of(context).size.height * 0.3,
           fit: BoxFit.cover,
         ),
         Positioned(
           bottom: 0,
           right: 0,
           child: Opacity(
             opacity: 0.75,
             child: Container(
               width: 50,
               height: 50,
               decoration: BoxDecoration(
                   borderRadius:
                   BorderRadius.only(topLeft: Radius.circular(50)),
                   color: Colors.purple),
             ),
           ),
         ),
         Positioned(
           bottom: 3,
           right: 3,
           child: Opacity(
               opacity: 0.75,
               child: InkWell(
                 onTap: () {
                   _showSelectionDialog(context);
                 },
                 child: Icon(
                   Icons.camera_alt,
                   color: Colors.white,
                   size: 30,
                 ),
               )),
         ),
       ],
     );
   } else {
     return Center(
       child: DottedBorder(
         borderType: BorderType.Circle,
         color: Colors.grey,
         strokeWidth: 2.0,
         dashPattern: [3],
         child: Container(
           height: MediaQuery.of(context).size.height * 0.1,
           width: MediaQuery.of(context).size.width * 0.5,
           decoration: BoxDecoration(shape: BoxShape.circle),
           child: InkWell(
               onTap: () {
                 _showSelectionDialog(context);
               },
               child: Icon(
                 Icons.camera_alt_outlined,
                 size: 40,
                 color: Colors.grey,
               )),
         ),
       ),
     );
   }
 }


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
          ),
        body: SingleChildScrollView(
          child: Container(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.grey)),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: Text('Thank you to :'),
                              value: _selectedReferralTypeTo,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedReferralTypeTo = newValue;
                                  print("<divyan sondagar");
                                  print(_selectedReferralTypeTo);
                                });
                              },
                              items: memberData.map((location) {
                                return DropdownMenuItem(
                                  child: new Text(location["Name"]),
                                  value: location["_id"].toString(),
                                );
                              }).toList(),
                            ),
                          ),
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
                                controller: _txtAmount,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Amount',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.only(topRight: Radius.circular(7),bottomRight: Radius.circular(7))),
                                ),
                              ),
                            ),
                          ]),
                      /*Padding(padding: EdgeInsets.only(top:10)),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.20,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.purple)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _setImageView(),
                          )),*/
                      Padding(padding: EdgeInsets.only(top: 10.0)),
                     /* Padding(padding: EdgeInsets.only(top:30)),
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
                      ),*/
                      SizedBox(height: 10),
                      TextField(
                        controller: _txtcomments,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Comments',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7))),
                        ),
                      ),
                      SizedBox(height:20),
                      Center(
                        child: InkWell(
                          onTap: (){
                            if (_txtAmount.text == "" ||
                                _txtcomments.text == "") {
                              Fluttertoast.showToast(
                                msg: "Fields can't be empty",
                                gravity: ToastGravity.TOP,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            }else {
                              addThankYou(_txtAmount.text, _txtcomments.text);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey),
                              gradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.deepPurple,
                                    Colors.purple,
                                  ]
                              ),
                            ),
                            padding: EdgeInsets.only(
                                left: 70.0, right: 70, top: 10, bottom: 10),
                            child: Text("Submit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "OpenSans"),
                            ),
                          ),
                        ),
                      ),
                    ]
                ),
              )
          ),
        )
    );
  }
}


