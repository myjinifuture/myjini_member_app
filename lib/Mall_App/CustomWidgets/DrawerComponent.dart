import 'package:flutter/material.dart';

class DrawerComponent extends StatefulWidget {
  @override
  _DrawerComponentState createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).padding.top)),
          Container(
            color: Colors.black54,
            height: 50,
          ),
          Text("ddd")
        ],
      ),
    );
  }
}
