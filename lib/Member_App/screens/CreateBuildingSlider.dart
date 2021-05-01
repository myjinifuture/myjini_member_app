import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Member_App/screens/SetupWingScreen.dart';


class CreateBuildingSlider extends StatefulWidget {

  var wingData;
  CreateBuildingSlider({this.wingData});
  @override
  _CreateBuildingSliderState createState() => _CreateBuildingSliderState();
}

class _CreateBuildingSliderState extends State<CreateBuildingSlider> {
  List<Slide> slides = new List();

  Function goToTab;

  @override
  void initState() {
    super.initState();
    slides.add(
      new Slide(
        title: "Setup Your Wings",
        styleTitle: TextStyle(
          color:Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono'
        ),
        description:
        "Enter total floor,unit and select your number formate.",
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 16.0,

            fontFamily: 'RobotoMono'),
        pathImage: "",
      ),
    );
    slides.add(
      new Slide(
        title: "Unit View",
        styleTitle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono'
        ),
        description:
            "Tap on unit block and make them as closed if it is not used.Tap again to show as active.",
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 16.0,

            fontFamily: 'RobotoMono'
        ),
        pathImage: "",
      ),
    );

  }

  void onDonePress() {
    // Back to the first tab
    //this.goToTab(0);
    //Navigator.pushReplacementNamed(context, "/SetupWingScreen");
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => SetupWingScreen(
          wingData:widget.wingData,
        )));
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Text("Next",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),);
  }

  Widget renderDoneBtn() {
    return Text("Done",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),);
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color(0xffffcc5c),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          // margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                cnst.appPrimaryMaterialColor[900],
                cnst.appPrimaryMaterialColor[700],
                cnst.appPrimaryMaterialColor[500],
                cnst.appPrimaryMaterialColor[300],
                // Colors.yellow[800],
                // Colors.yellow[700],
                // Colors.yellow[600],
                // Colors.yellow[400],
              ],
            ),
          ),
          child: Center(
            child: ListView(
              children: <Widget>[
                GestureDetector(
                    child: Image.asset(
                  currentSlide.pathImage,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.contain,
                )),
                Container(
                  child: Text(
                    currentSlide.title,
                    style: currentSlide.styleTitle,
                    textAlign: TextAlign.center,
                  ),
                  margin: EdgeInsets.only(top: 20.0),
                ),
                Container(
                  child: Text(
                    currentSlide.description,
                    style: currentSlide.styleDescription,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  margin: EdgeInsets.only(top: 20.0),
                ),
              ],
            ),
          ),
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              cnst.appPrimaryMaterialColor[900],
              cnst.appPrimaryMaterialColor[700],
              cnst.appPrimaryMaterialColor[600],
              cnst.appPrimaryMaterialColor[400],
            ],
          ),
        ),
        child: IntroSlider(
          // List slides
          slides: this.slides,

          // Skip button
          // renderSkipBtn: this.renderSkipBtn(),
          // colorSkipBtn: cnst.appPrimaryMaterialColor,
          // highlightColorSkipBtn: cnst.appPrimaryMaterialColor,

          // Next button
          renderNextBtn: this.renderNextBtn(),

          // Done button
          renderDoneBtn: this.renderDoneBtn(),
          onDonePress: this.onDonePress,
          colorDoneBtn: cnst.appPrimaryMaterialColor,
          highlightColorDoneBtn:cnst.appPrimaryMaterialColor,

          // Dot indicator
          colorDot:Colors.white,
          sizeDot: 13.0,
          //typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

          // Tabs
          listCustomTabs: this.renderListCustomTabs(),
          backgroundColorAllSlides: Colors.white,
          refFuncGoToTab: (refFunc) {
            this.goToTab = refFunc;
          },

          // Show or hide status bar
          shouldHideStatusBar: false,

          // On tab change completed
          onTabChangeCompleted: this.onTabChangeCompleted,
        ),
      ),
    );
  }
}
