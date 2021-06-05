import 'package:flutter/material.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';

class CartLoadingComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3.5,
          valueColor:
              new AlwaysStoppedAnimation<Color>(appPrimaryMaterialColor),
        ),
      ),
    );
  }
}
