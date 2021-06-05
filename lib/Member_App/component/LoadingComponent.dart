// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LoadingComponent extends StatelessWidget {
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        //width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height,
        color: Color.fromRGBO(0, 0, 0, 0.4),
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(
            strokeWidth: 5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
      ),
    );
  }
}