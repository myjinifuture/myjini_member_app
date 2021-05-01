import 'package:flutter/material.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;

class SetupWingScreen extends StatefulWidget {
  var wingData;
  SetupWingScreen({this.wingData});
  @override
  _SetupWingScreenState createState() => _SetupWingScreenState();
}

class _SetupWingScreenState extends State<SetupWingScreen> {
  var wing;

  @override
  void initState() {
    wing=widget.wingData;
    print("=============================");
    print(wing);
  }

  @override
  Widget build(BuildContext context) {
    print(wing);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Setup Wings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, "/CreateBuildingScreen");
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Setup all your wings and you will be on dashboard screen.",
                    style: TextStyle(color:cnst.appPrimaryMaterialColor,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
//                        //widthScreen / heightScreen,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 25.0),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          height: 50,
                          margin: EdgeInsets.only(right: 5, left: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: cnst.appPrimaryMaterialColor[100], width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(16.0)),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        cnst.appPrimaryMaterialColor.withOpacity(0.2),
                                    blurRadius: 2.0,
                                    spreadRadius: 2.0,
                                    offset: Offset(3.0, 5.0))
                              ]),
                          child: Center(child: Text("A",style: TextStyle(fontSize: 25,color: cnst.appPrimaryMaterialColor),)));
                    },
                    itemCount: int.parse(wing),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: cnst.appPrimaryMaterialColor[700],
                    textColor: Colors.white,
                    splashColor: Colors.white,
                    child: Text("Join Your Building",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    onPressed: () {
                      // Navigator.pushReplacementNamed(
                      //     context, '/LoginScreen');

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
              ],
            ),
          ),
        ),
      ),

    );
  }
}
