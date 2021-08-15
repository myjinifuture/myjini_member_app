import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../screens/NewPost.dart';

class Homes extends StatefulWidget {
  @override
  _HomesState createState() => _HomesState();
}

class _HomesState extends State<Homes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Rent & Sell",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontFamily: "OpenSans"),
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
        body: Container(
          margin: EdgeInsets.all(10.0),
          child: UIdesignbody(),
        ));
  }

  UIdesignbody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            child: Lottie.asset("assets/json/home.json",
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 4)),
        Text(
          "Choose a lifestyle,\n not just a home",
          style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.bold),
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Text(
          "Explore homes from best communites to live in",
          style: TextStyle(fontSize: 12, fontFamily: "OpenSans"),
        ),
        Padding(padding: EdgeInsets.only(top: 20.0)),
        InkWell(
          child: Stack(children: [
            Positioned(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image(
                      height: 120.0,
                      width: MediaQuery.of(context).size.width / 1,
                      image: AssetImage("assets/image/h2.jpg"),
                      fit: BoxFit.fill)),
            ),
            Positioned(
              left: 40,
              top: 80,
              child: Text(
                "Rent",
                style: TextStyle(
                    fontSize: 17, color: Colors.white,fontFamily: "OpenSans"),
              ),
            ),
          ]),
          onTap: () {
            Navigator.push(context,MaterialPageRoute(builder: (context)=>NewPost()));
          },
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        InkWell(
          child: Stack(children: [
            Positioned(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image(
                      height: 120.0,
                      width: MediaQuery.of(context).size.width / 1,
                      image: AssetImage("assets/image/h3.jpg"),
                      fit: BoxFit.fill)),
            ),
            Positioned(
              left: 40,
              top: 80,
              child: Text(
                "Buy",
                style: TextStyle(
                    fontSize: 17, color: Colors.white, fontFamily: "OpenSans"),
              ),
            ),
          ]),
          onTap: () {},
        )
      ],
    );
  }
}
