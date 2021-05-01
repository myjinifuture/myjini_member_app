import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';

class promocodeComponent extends StatefulWidget {
  var promoCode;
  promocodeComponent({this.promoCode});

  @override
  _promocodeComponentState createState() => _promocodeComponentState();
}

class _promocodeComponentState extends State<promocodeComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 10, right: 10),
          child: Row(
            children: [
              Image.asset(
                "assets/promocode.png",
                width: 70,
                height: 70,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text("${widget.promoCode["Promocode"]}",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text("${widget.promoCode["PromocodeType"]}",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child:
                            Text("${widget.promoCode["PromocodeDescription"]}",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: SizedBox(
                          height: 35,
                          width: 110,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            onPressed: () {
                              FlutterClipboard.copy(
                                      "${widget.promoCode["Promocode"]}")
                                  .then((value) {
                                Fluttertoast.showToast(
                                    msg: "Promocode copied",
                                    gravity: ToastGravity.TOP);
                              });
                            },
                            color: appPrimaryMaterialColor,
                            child: Text('Get Code',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
