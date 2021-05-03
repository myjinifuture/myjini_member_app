import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';

class LoadingComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
          child: SpinKitCircle(
        color: appPrimaryMaterialColor,
      )),
    );
  }
}
