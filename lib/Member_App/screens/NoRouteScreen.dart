import 'package:flutter/material.dart';

class NoRouteScreen extends StatefulWidget {
  String routeName;

  NoRouteScreen({this.routeName});
  @override
  _NoRouteScreenState createState() => _NoRouteScreenState();
}

class _NoRouteScreenState extends State<NoRouteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Unknown Route"),
      ),
      body: Center(child: Text("Route Not Found : ${widget.routeName}")),
    );
  }
}
