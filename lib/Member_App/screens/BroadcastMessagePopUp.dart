import 'package:flutter/material.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class BroadcastMessagePopUp extends StatefulWidget {
  var broadcastMessage;

  BroadcastMessagePopUp({this.broadcastMessage});

  @override
  _BroadcastMessagePopUpState createState() => _BroadcastMessagePopUpState();
}

class _BroadcastMessagePopUpState extends State<BroadcastMessagePopUp> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Center(child: Text("MYJINI")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Broadcast Message",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              Container(
                height: 45,
                width: 45,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 13.0),
                  child: Image.asset("images/loudspeaker.png"),
                ),
              ),
            ],
          ),
          Container(
            decoration: DottedDecoration(
              shape: Shape.box,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${widget.broadcastMessage.toString()}",
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.35,
            child: RaisedButton(
              color: constant.appPrimaryMaterialColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/HomeScreen', (route) => false);
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
