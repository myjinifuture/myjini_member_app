import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class BuildingInfo extends StatefulWidget {
  var societyData;

  BuildingInfo({this.societyData});

  @override
  _BuildingInfoState createState() => _BuildingInfoState();
}

class _BuildingInfoState extends State<BuildingInfo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Building Information', style: TextStyle(fontSize: 18)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: widget.societyData.length == 0
          ? Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("images/file.png",
                        width: 70, height: 70, color: Colors.grey[300]),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("No Building Info Found",
                          style: TextStyle(color: Colors.grey[400])),
                    )
                  ],
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3.5,
                  child:Image.asset("images/Building.png")
                  // widget.societyData["Society"][0]["societyImage"] == null
                  //     ? Image.asset("images/Building.png")
                  //     : FadeInImage.assetNetwork(
                  //         placeholder: "",
                  //         image:
                  //             "${constant.Image_Url}${widget.societyData["Society"][0]["societyImage"]}",
                  //         fit: BoxFit.cover,
                  //         width: MediaQuery.of(context).size.width,
                  //       ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${widget.societyData["Society"][0]["Name"]}".toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          color: constant.appPrimaryMaterialColor,
                        ),
                      ),
                      Text(
                        "${widget.societyData["Society"][0]["Address"]},",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      // Text(
                      //   widget.societyData["Society"][0]["city"] == null
                      //       ? "VIP road"
                      //       : "${widget.societyData["Society"][0]["Address"]},",
                      //   style: TextStyle(fontWeight: FontWeight.w600),
                      // ),
                      Text(
                        widget.societyData["Society"][0]["city"] == null
                            ? "Surat"
                            : "${widget.societyData["Society"][0]["city"]},",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      // Text( // have told to monil to give me statename in this api
                      //   widget.societyData["Society"][0]["city"] == null
                      //       ? "Gujrat"
                      //       : "${widget.societyData[0]["StateName"]},",
                      //   style: TextStyle(fontWeight: FontWeight.w600),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
