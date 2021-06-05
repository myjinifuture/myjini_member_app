import 'package:flutter/material.dart';

class ViewVisitorPopUpImage extends StatefulWidget {
  var data;
  ViewVisitorPopUpImage({this.data});
  @override
  _ViewVisitorPopUpImageState createState() => _ViewVisitorPopUpImageState();
}

class _ViewVisitorPopUpImageState extends State<ViewVisitorPopUpImage> {
  @override
  Widget build(BuildContext context) {
    print("data");
    return Scaffold(
      appBar: AppBar(
        title: Text('Visitor Image'),
      ),
      body: Column(
        children: [Center(child: Image.network(widget.data))],
      ),
    );
  }
}

