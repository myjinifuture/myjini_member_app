import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_society_new/Member_App/Mall/Common/ExtensionMethods.dart';
import 'package:smart_society_new/Member_App/Mall/Components/ProductComponent.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

class OtherProducts extends StatefulWidget {
  @override
  _OtherProductsState createState() => _OtherProductsState();
}

class _OtherProductsState extends State<OtherProducts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 2,
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) {
          return ProductComponent();
        },
        staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
      ),
    );
  }
}
