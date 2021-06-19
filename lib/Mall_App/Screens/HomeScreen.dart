import 'dart:io';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/CategoryComponent.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/LoadingComponent.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/OfferComponent.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/ProductComponent.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/TitlePattern.dart';
import 'package:smart_society_new/Mall_App/Providers/CartProvider.dart';
import 'package:smart_society_new/Mall_App/Screens/MyCartScreen.dart';
import 'package:smart_society_new/Mall_App/Screens/OfferScreen.dart';
import 'package:smart_society_new/Mall_App/Screens/ProfileScreen.dart';
import 'package:smart_society_new/Mall_App/Screens/SearchProductPage.dart';
import 'package:smart_society_new/Mall_App/transitions/fade_route.dart';
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';
import 'package:smart_society_new/Member_App/screens/CustomerProfile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime currentBackPressTime;
  List _dashboardList = [];
  List _bannerList = [];
  List _categoryList = [];
  List _suggestedProductList = [];
  List _Offerlist = [];
  bool isLoading = false;
  bool iscartlist = false;
  Location location = new Location();
  LocationData locationData;
  String latitude, longitude;
  String CustomerName;

  Future<bool> onWillPop() {
    print("exit called");
    exit(0);
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "press back again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  getlocaldata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      CustomerName = preferences.getString(Session.CustomerName);
    });
  }

  @override
  void initState() {
    super.initState();
    // _dashboardData();
    getlocaldata();
  }

  @override
  Widget build(BuildContext context) {
    CartProvider provider = Provider.of<CartProvider>(context);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: isLoading == true ? Colors.white : Colors.grey[400],
        appBar: AppBar(
          centerTitle: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_back_ios,
                size: 27,
              ),
            ),
          ),
          title:
              /*GestureDetector(
            onTap: () {
              Navigator.push(context, SlideLeftRoute(page: ProfileScreen()));
            },
            child: Row(
              children: [
                Icon(
                  Icons.account_box,
                  size: 27,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello,",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                      Text("${CustomerName}",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          )*/
              Text('Online Shopping'),
        ),
        body: WillPopScope(
            child: isLoading == true
                ? LoadingComponent()
                : _dashboardList.length > 0
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            _bannerList.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: SizedBox(
                                      height: 170.0,
                                      width: MediaQuery.of(context).size.width,
                                      child: Carousel(
                                        boxFit: BoxFit.cover,
                                        autoplay: true,
                                        animationCurve: Curves.fastOutSlowIn,
                                        animationDuration:
                                            Duration(milliseconds: 1000),
                                        dotSize: 4.0,
                                        dotIncreasedColor: Colors.black54,
                                        dotBgColor: Colors.transparent,
                                        dotPosition: DotPosition.bottomCenter,
                                        dotVerticalPadding: 10.0,
                                        showIndicator: true,
                                        indicatorBgPadding: 7.0,
                                        images: _bannerList
                                            .map((item) => Container(
                                                child: Image.network(
                                                    IMG_URL +
                                                        item["BannerImage"],
                                                    fit: BoxFit.fill)))
                                            .toList(),
                                      ),
                                    ),
                                  )
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 4.0, right: 4.0, top: 4.0),
                              child: Card(
                                child: Column(
                                  children: [
                                    TitlePattern(title: "Category"),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: _categoryList.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                      ),
                                      itemBuilder: (context, index) {
                                        return CategoryComponent(
                                            _categoryList[index]);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                    child: TitlePattern(
                                        title: "Suggested Products")),
                              ),
                            ),
                            SizedBox(
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _suggestedProductList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return ProductComponent(
                                        product: _suggestedProductList[index]);
                                  }),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  child: TitlePattern(title: "Offers"),
                                ),
                              ),
                            ),
                            // ignore: missing_return
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return OfferComponent(
                                  Offerdata: _Offerlist[index],
                                );
                              },
                              itemCount: _Offerlist.length,
                            )
                          ],
                        ),
                      )
                    : Container(color: Colors.white),
            onWillPop: () {
              Navigator.of(context).pop();
            }),
        bottomNavigationBar: Container(
          height: 54,
          decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(top: BorderSide(color: Colors.grey, width: 0.3))),
          child: Row(
            children: <Widget>[
              Flexible(
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/assets/home.png',
                            width: 20, color: appPrimaryMaterialColor),
                        Text("Home",
                            style: TextStyle(
                                fontSize: 11, color: appPrimaryMaterialColor))
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
              ),
              Flexible(
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/assets/loupe.png',
                            width: 20, color: appPrimaryMaterialColor),
                        Text("Search",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11, color: appPrimaryMaterialColor))
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context, FadeRoute(page: SearchProductPage()));
                  },
                ),
              ),
              Flexible(
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/assets/discount.png',
                            width: 20, color: appPrimaryMaterialColor),
                        Text("Offers",
                            style: TextStyle(
                                fontSize: 11, color: appPrimaryMaterialColor))
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context, SlideLeftRoute(page: OfferScreen()));
                  },
                ),
              ),
              Flexible(
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/assets/discount.png',
                            width: 20, color: appPrimaryMaterialColor),
                        Text("Profile",
                            style: TextStyle(
                                fontSize: 11, color: appPrimaryMaterialColor))
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context, SlideLeftRoute(page: CustomerProfile()));
                  },
                ),
              ),
              Flexible(
                child: Stack(
                  children: [
                    InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset('assets/assets/shoppingcart.png',
                                width: 22, color: appPrimaryMaterialColor),
                            Text("My Cart",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: appPrimaryMaterialColor))
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context, SlideLeftRoute(page: MyCartScreen()));
                      },
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: provider.cartCount > 0
                          ? CircleAvatar(
                              radius: 7.0,
                              backgroundColor: Colors.red[400],
                              foregroundColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Text(
                                  provider.cartCount.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _dashboardData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.postforlist(apiname: 'getDashboardDataTest').then(
            (responselist) async {
          if (responselist.length > 0) {
            setState(() {
              isLoading = false;
              _dashboardList = responselist;
              _bannerList = responselist[0]["Banner"];
              _categoryList = responselist[1]["Category"];
              _Offerlist = responselist[2]["Offer"];
              _suggestedProductList = responselist[3]["product"];
            });
            print(_bannerList);
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "something went wrong");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "No Internet Connection");
    }
  }
}
