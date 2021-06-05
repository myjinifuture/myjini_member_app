import 'package:flutter/material.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class JoinCreateBuildingScreen extends StatefulWidget {
  @override
  _JoinCreateBuildingScreenState createState() =>
      _JoinCreateBuildingScreenState();
}

class _JoinCreateBuildingScreenState extends State<JoinCreateBuildingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              // color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.height * 0.37,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: cnst.appPrimaryMaterialColor[400], width: 1),
                  //borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: [
                    BoxShadow(
                        color: cnst.appPrimaryMaterialColor.withOpacity(0.2),
                        blurRadius: 2.0,
                        spreadRadius: 2.0,
                        offset: Offset(3.0, 5.0))
                  ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 18,right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Get Your Joining code from your",
                      style: TextStyle(
                          color: cnst.appPrimaryMaterialColor[900],
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "buildingAdministator",
                      style: TextStyle(
                          color: cnst.appPrimaryMaterialColor[900],
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 18.0, left: 8, right: 8, bottom: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: constant.appPrimaryMaterialColor[700],
                          textColor: Colors.white,
                          splashColor: Colors.white,
                          child: Text("Join Your Building",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/LoginScreen');

                          },
//                         onPressed: valid
//                             ? () {
// //                                Navigator.pushReplacementNamed(
// //                                    context, '/LoginScreen');
//                                 _Registration();
//                               }
//                             : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text("OR",style: TextStyle(fontSize: 18),),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 18.0, left: 8, right: 8, bottom: 8.0),
            child: SizedBox(
              //width: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.height * 0.37,
              height: 50,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: constant.appPrimaryMaterialColor[700],
                textColor: Colors.white,
                splashColor: Colors.white,
                child: Text("Create New Building",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, '/CreateBuildingScreen');
                },
//                         onPressed: valid
//                             ? () {
// //                                Navigator.pushReplacementNamed(
// //                                    context, '/LoginScreen');
//                                 _Registration();
//                               }
//                             : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
