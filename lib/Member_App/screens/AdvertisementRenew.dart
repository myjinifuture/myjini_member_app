import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/constant.dart';

import 'PaymentWebView.dart';

class AdvertisementRenew extends StatefulWidget {
  var data;

  AdvertisementRenew(this.data);

  @override
  _AdvertisementRenewState createState() => _AdvertisementRenewState();
}

class _AdvertisementRenewState extends State<AdvertisementRenew> {
  TextEditingController edtTitle = new TextEditingController();
  TextEditingController edtDescription = new TextEditingController();
  TextEditingController edtWebsiteURL = new TextEditingController();
  TextEditingController edtEmail = new TextEditingController();

  String selectedType;
  String selectedLocationType;
  String selectedLocations = "";
  int selected_package;
  File image;

  List _locationsData = [];
  List _packageAllList = [];
  List _packageList = [];
  List _selectedCheckList = [];
  List _paymentDetails = [];

  bool isLoading = false;
  ProgressDialog pr;
  String _result = 'Unknown';
  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    setData();
    _getLocation();
  }

  Future getImage(ImageSource source) async {
    var newImage = await ImagePicker.pickImage(source: source);
    if (newImage != null) {
      setState(() {
        image = newImage;
        widget.data["image"] = null;
      });
    }
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _result = position.toString();
    });
    print(position);
  }

  setData() async {
    await getPackages();
    await getPaymentDetails();
    setState(() {
      edtTitle.text = widget.data["title"];
      edtDescription.text = widget.data["desc"];
      edtWebsiteURL.text = widget.data["website"];
      edtEmail.text = widget.data["email"];
      //Set GeoLocation lang long
      if (widget.data["type"] == "Society")
        selectedType = "For Society";
      else if (widget.data["type"] == "Area")
        selectedType = "For Area";
      else if (widget.data["type"] == "City")
        selectedType = "For City";
      else if (widget.data["type"] == "State") selectedType = "For State";
    });
    if (selectedType != null && selectedType != "") {
      // await getLocationData(selectedType);
    }
    var selectedLocations = widget.data["targetedId"].toString().split(",");
    for (int i = 0; i < selectedLocations.length; i++) {
      _selectedCheckList.add(int.parse(selectedLocations[i].trim()));
    }
    print("->>>" + _selectedCheckList.toString());
  }

  getPackages() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetPackages();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _packageAllList = data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              _packageAllList = data;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  getPaymentDetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetPaymentDetails();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _paymentDetails = data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              _paymentDetails = data;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  getLocationData(String selectedType) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (selectedType == "For Society")
          setState(() {
            selectedLocationType = "Society";
          });
        else if (selectedType == "For Area")
          setState(() {
            selectedLocationType = "Area";
          });
        else if (selectedType == "For City")
          setState(() {
            selectedLocationType = "City";
          });
        else if (selectedType == "For State")
          setState(() {
            selectedLocationType = "State";
          });

        Future res = Services.GetAdvertiseFor(selectedLocationType);
        // pr.show();
        res.then((data) async {
          // pr.hide();
          if (data != null && data.length > 0) {
            setState(() {
              _locationsData = data;
            });
            setPackage();
          } else {
            setState(() {
              _locationsData = data;
            });
          }
        }, onError: (e) {
          // pr.hide();
          showMsg("Something Went Wrong.\nPlease Try Again");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
      // pr.hide();
    }
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
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  setPackage() async {
    setState(() {
      _packageList.clear();
      selected_package = null;
    });

    for (int i = 0; i < _packageAllList.length; i++) {
      if (_packageAllList[i]["Type"] == selectedLocationType) {
        print("selected Package-->" +
            _packageAllList[i]["Id"].toString() +
            "  " +
            _packageAllList[i]["Type"]);
        setState(() {
          _packageList.add(_packageAllList[i]);
        });
      }
    }
    for (int i = 0; i < _packageList.length; i++) {
      if (_packageList[i]["Id"].toString() == widget.data["packageId"]) {
        setState(() {
          selected_package = i;
        });
      }
    }
  }

  _makePayment() async {
    if (edtTitle.text != "" && edtDescription.text != "") {
      DateTime expiredDate = DateTime.now();

      expiredDate = expiredDate
          .add(Duration(days: _packageList[selected_package]["Duration"]));

      var data = {
        "id": "${widget.data["Id"]}",
        "key": "${_paymentDetails[0]["InstaMojoKey"]}",
        "token": "${_paymentDetails[0]["InstaMojoToken"]}",
        "amount": "${double.parse(
          (_packageList[selected_package]["Price"] * _selectedCheckList.length)
              .toString(),
        )}",
        "title": "${edtTitle.text}",
        "desc": "${edtDescription.text}",
        "photo": image,
        "packageId": "${_packageList[selected_package]["Id"]}",
        "expiredDate": "${expiredDate.toString()}",
        "type": "${selectedLocationType}",
        "targetedId": "${selectedLocations}",
        "renew": "true",
      };

      print(data);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebView(data),
        ),
      );
    } else
      Fluttertoast.showToast(
          msg: "Please Enter All Fields",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Renew Promotion"),
        ),
        body: isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, right: 5.0, left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Text("Advertisement Title",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 5.0, top: 6.0),
                              child: Container(
                                height: 55,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextFormField(
                                        controller: edtTitle,
                                        decoration: InputDecoration(
                                          hintText: "Title",
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[400]),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            constant.appPrimaryMaterialColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, right: 5.0, left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Text("Description",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: constant.appPrimaryMaterialColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0))),
                              margin: EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0, bottom: 4.0),
                                child: TextFormField(
                                  controller: edtDescription,
                                  maxLines: 4,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter Description",
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[400])),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, right: 5.0, left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Text("Website URL",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 5.0, top: 6.0),
                              child: Container(
                                height: 55,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextFormField(
                                        controller: edtWebsiteURL,
                                        decoration: InputDecoration(
                                          hintText: "URL",
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[400]),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            constant.appPrimaryMaterialColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, right: 5.0, left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Text("E-Mail",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 5.0, top: 6.0),
                              child: Container(
                                height: 55,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextFormField(
                                        controller: edtEmail,
                                        decoration: InputDecoration(
                                          hintText: "Enter E-Mail",
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[400]),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            constant.appPrimaryMaterialColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, right: 8.0, left: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Text("Select Photo",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 10, right: 10, bottom: 10),
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: 45,
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    20.0)),
                                        color: constant.appPrimaryMaterialColor,
                                        onPressed: () {
                                          getImage(ImageSource.gallery);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.photo_library,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 4)),
                                            Expanded(
                                              child: Text(
                                                "Add from Gallery",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 8)),
                                  Flexible(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: 45,
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    20.0)),
                                        color: Colors.grey[100],
                                        onPressed: () {
                                          getImage(ImageSource.camera);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.camera_alt,
                                              size: 20,
                                              color: constant
                                                  .appPrimaryMaterialColor,
                                            ),
                                            Text(
                                              " Camera",
                                              style: TextStyle(
                                                  color: constant
                                                      .appPrimaryMaterialColor,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            //Uploader(file:image),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            widget.data["image"] != null &&
                                    widget.data["image"] != ""
                                ? FadeInImage.assetNetwork(
                                    placeholder: "images/placeholder.png",
                                    image:
                                        Image_Url + '${widget.data["image"]}',
                                    height: 150,
                                    fit: BoxFit.fill,
                                  )
                                : image != null
                                    ? Image.file(
                                        File(image.path),
                                        height: 150,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, right: 5.0, left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Text("Advertisement For",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                            Container(
                                height: 45,
                                margin: EdgeInsets.all(8.0),
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 1),
                                ),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                  isExpanded: true,
                                  value: selectedType,
                                  hint: Text("Select Type"),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedType = newValue;
                                      _locationsData.clear();
                                      _selectedCheckList.clear();
                                    });
                                    getLocationData(newValue);
                                  },
                                  items: <String>[
                                    'For Society',
                                    'For Area',
                                    'For City',
                                    'For State',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ))),
                            _packageList.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, right: 8.0, left: 8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text("Select Prefer Package",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                  )
                                : Container(),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Wrap(
                                  runSpacing: 10,
                                  spacing: 10,
                                  children: List.generate(_packageList.length,
                                      (index) {
                                    return ChoiceChip(
                                      padding: EdgeInsets.only(
                                          top: 5,
                                          left: 10,
                                          bottom: 5,
                                          right: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      backgroundColor: Colors.grey[200],
                                      selectedColor: Colors.green[400],
                                      label: Column(
                                        children: <Widget>[
                                          Text(
                                            "${_packageList[index]["Title"]}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: selected_package == index
                                                    ? Colors.white
                                                    : Colors.grey[700]),
                                          ),
                                          Text(
                                            "${constant.Inr_Rupee}${_packageList[index]["Price"]}",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: selected_package == index
                                                    ? Colors.white
                                                    : Colors.grey),
                                          ),
                                          Text(
                                            "${_packageList[index]["Duration"]} Days",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: selected_package == index
                                                    ? Colors.white
                                                    : Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                      selected: selected_package == index,
                                      onSelected: (selected) {
                                        if (selected) {
                                          setState(() {
                                            selected_package = index;
                                            print(_packageList[index]["Title"]);
                                          });
                                        }
                                      },
                                    );
                                  }),
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 10)),
                            isLoading
                                ? Container()
                                : _locationsData.length > 0
                                    ? MultiSelectFormField(
                                        autovalidate: false,
                                        title:
                                            Text('Select $selectedLocationType'),
                                        validator: (value) {
                                          if (value == null ||
                                              value.length == 0) {
                                            return 'Please select one or more options';
                                          }
                                        },
                                        dataSource: _locationsData,
                                        textField: 'Name',
                                        valueField: 'Id',
                                        okButtonLabel: 'OK',
                                        cancelButtonLabel: 'CANCEL',
                              hintWidget: Text('Select $selectedLocationType'),
                                        change: () => _selectedCheckList,
                                        onSaved: (value) {
                                          if (value == null) return;
                                          print(_selectedCheckList);
                                          setState(() {
                                            _selectedCheckList = value;
                                            selectedLocations =
                                                _selectedCheckList
                                                    .toString()
                                                    .replaceAll("[", "");
                                            selectedLocations =
                                                selectedLocations
                                                    .toString()
                                                    .replaceAll("]", "");
                                            print(selectedLocations);
                                          });
                                        },
                                      )
                                    : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  _selectedCheckList.length > 0 && selected_package != null
                      ? MaterialButton(
                          height: 45,
                          minWidth: MediaQuery.of(context).size.width,
                          color: constant.appprimarycolors[600],
                          onPressed: () {
                            _makePayment();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Pay Now",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              Padding(padding: EdgeInsets.only(left: 15)),
                              Text(
                                "${constant.Inr_Rupee} ",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              Text(
                                "${double.parse((_packageList[selected_package]["Price"] * _selectedCheckList.length).toString()).toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Padding(padding: EdgeInsets.only(right: 15))
                            ],
                          ))
                      : Container(),
                ],
              ));
  }
}
