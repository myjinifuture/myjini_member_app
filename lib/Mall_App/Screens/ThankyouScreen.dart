import 'package:flutter/material.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Mall_App/Screens/HomeScreen.dart';

class ThankyouScreen extends StatefulWidget {
  @override
  _ThankyouScreenState createState() => _ThankyouScreenState();
}

class _ThankyouScreenState extends State<ThankyouScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey),
        // title: Row(
        //   children: [
        //     Image.asset(
        //       "assets/assets/splash.jpg",
        //       fit: BoxFit.cover,
        //       height: 50,
        //       width: 50,
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.only(top: 20.0, left: 1),
        //       child: Text(
        //         "Saree",
        //         style: TextStyle(
        //             color: appPrimaryMaterialColor,
        //             fontSize: 14,
        //             fontWeight: FontWeight.w400),
        //       ),
        //     ),
        //   ],
        // ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top +
                MediaQuery.of(context).size.height / 15,
          ),
          Center(
            child: Column(
              children: [
                Text(
                  "Thank you for choosing",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "Surti Basket",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: MediaQuery.of(context).padding.top + 2),
                Container(
                  width: 60,
                  height: 60,
                  child: GestureDetector(
                      onTap: () {},
                      child: Icon(Icons.done, size: 42, color: Colors.white)),
                  decoration: BoxDecoration(
                      color: appPrimaryMaterialColor,
                      borderRadius: BorderRadius.circular(100.0)),
                ),
                SizedBox(height: MediaQuery.of(context).padding.top + 2),
                Text(
                  "Order Placed Successfully",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    "We Will Deliver Your Order Soon",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.top +
                      MediaQuery.of(context).size.height / 10,
                ),
                Center(
                  child: Text(
                    "In case of any query related to your order",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Center(
                    child: Text(
                      "please feel free to Contact Us...",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: SizedBox(
                    height: 42,
                    width: MediaQuery.of(context).size.width / 1.7,
                    child: FlatButton(
                      color: appPrimaryMaterialColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.grey[300])),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    HomeScreen()),
                            (route) => false);
                      },
                      child: Text(
                        "Continue Shopping...",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
