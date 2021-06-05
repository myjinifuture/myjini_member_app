import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

class Categories extends StatefulWidget {
  Function onSelect;

  Categories({this.onSelect});
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  bool showSubCategory = false;
  @override
  Widget build(BuildContext context) {
    return !showSubCategory
        ? StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            itemCount: 8,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    showSubCategory = true;
                  });
                },
                child: Card(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Opacity(
                        opacity: 0.3,
                        child: Image.asset(
                          "lib/Mall/Images/daawat.png",
                          width: 120,
                          fit: BoxFit.contain,
                          height: 120,
                        ),
                      ),
                      Container(
                        child: Text(
                          "Dal",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
          )
        : Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: cnst.appPrimaryMaterialColor,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          showSubCategory = false;
                        });
                      }),
                  Text(
                    "Main Categories",
                    style: TextStyle(
                        color: cnst.appPrimaryMaterialColor, fontSize: 13),
                  )
                ],
              ),
              Expanded(
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        widget.onSelect("$index");
                      },
                      child: Card(
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Opacity(
                              opacity: 0.3,
                              child: Image.asset(
                                "lib/Mall/Images/daawat.png",
                                width: 120,
                                fit: BoxFit.contain,
                                height: 120,
                              ),
                            ),
                            Container(
                              child: Text(
                                "Tuver Dal",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                ),
              ),
            ],
          );
  }
}
