// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'dart:io';
import '../../Member_App/./common/Services.dart';
import 'package:pie_chart/pie_chart.dart';

class PollingComponent extends StatefulWidget {
  var _pollingData;
  int index;
  String totalMembersInSociety;

  PollingComponent(this._pollingData, this.index,this.totalMembersInSociety);

  @override
  _PollingComponentState createState() => _PollingComponentState();
}

class _PollingComponentState extends State<PollingComponent> {
  int touchedIndex;

  List<Color> colors = [
    Color(0xff00A6A6),
    Color(0xff3D405B),
    Color(0xff7EB2DD),
    Color(0xff81B29A)
  ];

  // List<PieChartSectionData> showingSections() {
  //   return List.generate(widget._pollingData["PollOptions"].length,
  //       (i) {
  //     final isTouched = i == touchedIndex;
  //     final double fontSize = isTouched ? 25 : 16;
  //     final double fontSizeForZero = isTouched ? 18 : 12;
  //     final double radius = isTouched ? 60 : 50;
  //     return widget._pollingData["PollOptions"][i]["Count"]
  //                 .toString() !=
  //             '0.0'
  //         ? PieChartSectionData(
  //             color: colors[i],
  //             value: double.parse(responseToPolling.length.toString()),
  //             title:
  //                 '${responseToPolling.length}%',
  //             radius: radius,
  //             titleStyle: TextStyle(
  //                 fontSize: fontSize,
  //                 fontWeight: FontWeight.bold,
  //                 color: const Color(0xffffffff)),
  //           )
  //         : PieChartSectionData(
  //             color: colors[i],
  //             title:
  //                 '${widget._pollingData["PollingOptionCountList"][i]["Count"]}%',
  //             radius: radius,
  //             titleStyle: TextStyle(
  //                 fontSize: fontSizeForZero,
  //                 fontWeight: FontWeight.bold,
  //                 color: const Color(0xffffffff)),
  //           );
  //   });
  // }

  List<Widget> chartData() {
    return List.generate(responseToPolling.length,
        (i) {
      return Indicator(
        color: colors[i], // colors[i],
        text: '${responseToPolling.length}',
        isSquare: false,
      );
    });
  }

  showMsg(String msg, {String title = 'MYJINI'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // @override
  // void initState() {
  //   _getResponseOfPolling(widget._pollingData["_id"]);
  // }

  Map<String, double> data = new Map();
  double responsePercent = 0.0;
  bool isNoAnswerZero = false;
  List<Widget> percentageList = [];

  @override
  void initState() {
    percentageList.length = widget._pollingData[widget.index]["PollOptions"].length + 1;
    // widget._pollingData[widget.index]["PollOptions"].length+=1;
    for(int i=0;i<widget._pollingData[widget.index]["PollOptions"].length;i++) {
      responsePercent+=widget._pollingData[widget.index]["PollOptions"][i]["ResponsePercent"];
      // data.addAll({
      //   widget._pollingData[widget.index]["PollOptions"][i]["pollOption"]:
      //   widget._pollingData[widget.index]["PollOptions"][i]["ResponsePercent"]/100,
      // // });
      // if(i == widget._pollingData[widget.index]["PollOptions"].length - 1){
      //   data.addAll({
      //     "No Response":
      //     (100 - responsePercent)/100,
      //   });
      // }
      // else{
        // responsePercent +=
        // widget._pollingData[widget.index]["PollOptions"][i]["ResponsePercent"];
        print(widget._pollingData[widget.index]["PollOptions"][i]["ResponsePercent"]/100);
        print(widget._pollingData[widget.index]["PollOptions"][i]["pollOption"]);
        data.addAll({
          widget._pollingData[widget.index]["PollOptions"][i]["pollOption"]:
          widget._pollingData[widget.index]["PollOptions"][i]["ResponsePercent"]/100,
        });
      // percentageList.add({
      //   "value" : widget._pollingData[widget.index]["PollOptions"][i]["ResponsePercent"].toString(),
      // });
      // }
      percentageList[i] = Row(
        children: [
          Text("${double.parse(widget._pollingData[widget.index]["PollOptions"][i]["ResponsePercent"].toString()).round()}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("%",
          ),
        ],
      );
    }
    data.addAll({
      "No Reponse":
      (100 - responsePercent)/100,
    });
    // percentageList.add({
    //   "value" : (100 - responsePercent).toString(),
    // });
    percentageList[percentageList.length-1] = Row(
      children: [
        Text("${double.parse((100 - responsePercent).toString()).round()}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),),
        Text("%",
        ),
      ],
    );
    super.initState();
  }

  List<Color> _colors = [
    Colors.black,
    Colors.grey,
    Colors.lightBlueAccent,
    Colors.redAccent
  ];

  List responseToPolling = [];

  _getResponseOfPolling(String pollingQuestionId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "pollQuestionId" : pollingQuestionId
        };

        Services.responseHandler(apiName: "admin/getResponseOfPoll",body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              responseToPolling = data.Data;
            });
          } else {
            // setState(() {
            //   isLoading = false;
            // });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
          // setState(() {
          //   isLoading = false;
          // });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: widget.index,
      duration: const Duration(milliseconds: 450),
      child: FlipAnimation(
        //verticalOffset: 50.0,
        delay: Duration(milliseconds: 350),
        flipAxis: FlipAxis.x,
        child: FadeInAnimation(
          child: Card(
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        "images/question.png",
                        width: 15,
                        height: 15,
                        color: Colors.grey,
                      ),
                      Padding(padding: EdgeInsets.only(left: 8)),
                      Expanded(
                        child: Text(
                          "${widget._pollingData[widget.index]["pollQuestion"]}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: cnst.appPrimaryMaterialColor),
                        ),
                      ),
                    ],
                  ),
                ),
                // responseToPolling.length > 0
                //     ?
                Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          PieChart(
                            dataMap: data,
                            colorList:
                            _colors, // if not declared, random colors will be chosen
                            animationDuration: Duration(milliseconds: 1500),
                            chartLegendSpacing: 10.0,
                            chartRadius: MediaQuery.of(context).size.width /
                                2.7, //determines the size of the chart
                            showChartValuesInPercentage: true,
                            showChartValues: true,
                            showChartValuesOutside: false,
                            chartValueBackgroundColor: Colors.grey[200],
                            showLegends: true,
                            legendPosition:
                            LegendPosition.right, //can be changed to top, left, bottom
                            decimalPlaces: 1,
                            showChartValueLabel: true,
                            initialAngle: 0,
                            chartValueStyle: defaultChartValueStyle.copyWith(
                              color: Colors.blueGrey[900].withOpacity(0.9),
                            ),
                            chartType: ChartType.disc, //can be changed to ChartType.ring
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom:4.0),
                            child: Column(
                              children: percentageList,
                            ),
                          ),
                        ],
                      )
                    // : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 13,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600, color: textColor),
        )
      ],
    );
  }
}
