import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AdvertisemnetDetail extends StatefulWidget {
  var data;

  AdvertisemnetDetail(this.data);

  @override
  _AdvertisemnetDetailState createState() => _AdvertisemnetDetailState();
}

class _AdvertisemnetDetailState extends State<AdvertisemnetDetail> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(21.203510, 72.839233);

  YoutubePlayerController _controller;
  String _playerStatus = '';

  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _setVideo();

    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  }

  _setVideo() {
    print(widget.data["VideoLink"]);
    if (widget.data["VideoLink"] != null &&
        widget.data["VideoLink"] != "" &&
        widget.data["VideoLink"]
            .toString()
            .toLowerCase()
            .contains("youtube.com")) {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.data["VideoLink"]),
        flags: YoutubePlayerFlags(
          mute: false,
          autoPlay: false,
          // forceHideAnnotation: true,
          loop: true,
        ),
      )..addListener(listener);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void listener() {
    if (_isPlayerReady) {
      if (mounted && !_controller.value.isFullScreen) {
        setState(() {
          _playerStatus = _controller.value.playerState.toString();
        });
      }
    }
  }

  _openWhatsapp(mobile) {
    String whatsAppLink = constant.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advertise Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 3,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.new_releases,
                        size: 15,
                        color: Colors.grey[600],
                      ),
                      Padding(padding: EdgeInsets.only(left: 4)),
                      Expanded(
                        child: Text(
                          "${widget.data["Title"]}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 3, bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Icon(
                          Icons.message,
                          size: 15,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 4)),
                      Expanded(
                        child: Text(
                          "${widget.data["Description"]}",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                CarouselSlider.builder(
                  height: 170,
                  viewportFraction: 1.0,
                  autoPlayAnimationDuration: Duration(milliseconds: 1500),
                  reverse: false,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlay: true,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int itemIndex) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child: Image.network(
                        Image_Url + widget.data["Image"],
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width,
                        height: 170,
                      ),
                    );
                  },
                ),
                widget.data["VideoLink"] != null &&
                        widget.data["VideoLink"] != "" &&
                        widget.data["VideoLink"]
                            .toString()
                            .toLowerCase()
                            .contains("youtube.com")
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          height: 170,
                          width: MediaQuery.of(context).size.width,
                          child: YoutubePlayer(
                            controller: _controller,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: appPrimaryMaterialColor,
                            topActions: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                                onPressed: () {
                                  _controller.toggleFullScreenMode();
                                },
                              ),
                            ],
                            onReady: () {
                              _isPlayerReady = true;
                            },
                          ),
                        ),
                      )
                    : Container(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Text("Contact Information",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700])),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Name :",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          Text(
                            "Website :",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${widget.data["MemberName"]}",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              launch("${widget.data["WebsiteURL"]}");
                            },
                            child: Text(
                              "${widget.data["WebsiteURL"]}",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _openWhatsapp(widget.data["ContactNo"]);
                        },
                        child: Container(
                          color: Colors.green[400],
                          height: 30,
                          width: MediaQuery.of(context).size.width / 4.29,
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: Image.asset(
                            "images/whatsapp.png",
                            width: 43,
                            height: 43,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          launch(
                              'mailto:${widget.data["EmailId"]}?subject=&body=');
                          //launch('mailto:${widget.data["Email"].toString()}?subject=&body=');
                        },
                        child: Container(
                          color: constant.appPrimaryMaterialColor,
                          height: 30,
                          width: MediaQuery.of(context).size.width / 4.29,
                          padding: EdgeInsets.symmetric(vertical: 7),
                          child: Image.asset(
                            "images/mail.png",
                            width: 23,
                            height: 12,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          launch("tel:${widget.data["ContactNo"]}");
                        },
                        child: Container(
                          color: Colors.green[400],
                          height: 30,
                          width: MediaQuery.of(context).size.width / 4.29,
                          padding: EdgeInsets.symmetric(vertical: 7),
                          child: Image.asset(
                            "images/call.png",
                            width: 23,
                            height: 23,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        color: constant.appPrimaryMaterialColor,
                        height: 30,
                        width: MediaQuery.of(context).size.width / 4.29,
                        padding: EdgeInsets.symmetric(vertical: 7),
                        child: Image.asset(
                          "images/navigation.png",
                          width: 23,
                          height: 23,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
