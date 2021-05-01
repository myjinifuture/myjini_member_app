import 'package:flutter/material.dart';
import 'dart:io';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:intl/intl.dart';
import '../common/constant.dart' as cnst;

class AddPlasmaDonor extends StatefulWidget {
  @override
  _AddPlasmaDonorState createState() => _AddPlasmaDonorState();
}

class _AddPlasmaDonorState extends State<AddPlasmaDonor> {
  TextEditingController name = new TextEditingController();
  TextEditingController mobile = new TextEditingController();

  bool stateLoading = false;
  bool cityLoading = false;
  List stateList = [];
  List cityList = [];
  String selectedState;
  String selectedCity;
  String selectedStateCode, selectedCountryCode;
  String gender;
  DateTime selectedDate = DateTime.now();
  DateTime covidPositiveDate = DateTime.now();
  DateTime plasmaDonationDate = DateTime.now();
  DateTime vaccinationDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _covidPositiveDateController = TextEditingController();
  TextEditingController _plasmaDonationDateController = TextEditingController();
  TextEditingController _vaccinationDateController = TextEditingController();
  String _setDate;
  String _setCovidPositiveDate;
  String _setPlasmaDonationDate;
  String _setVaccinationDate;
  bool covidPositive = false;
  bool plasmaDonated = false;
  bool plasmaNotDonated = false;
  bool vaccinated = false;
  bool notVaccinated = false;
  TextEditingController weight = TextEditingController();
  TextEditingController bloodGroup = TextEditingController();

  @override
  void initState() {
    getState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _covidPositiveDateController.text =
        DateFormat('dd/MM/yyyy').format(DateTime.now());
    _plasmaDonationDateController.text =
        DateFormat('dd/MM/yyyy').format(DateTime.now());
    _vaccinationDateController.text =
        DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  getState() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          stateLoading = true;
        });
        var body = {"countryCode": "IN"};
        Services.responseHandler(apiName: "admin/getState", body: body).then(
            (data) async {
          setState(() {
            stateLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              stateList = data.Data;
            });
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            stateLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        stateLoading = false;
      });
    }
  }

  getCity(String stateCode, String countryCode) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          cityLoading = true;
        });
        var body = {"countryCode": countryCode, "stateCode": stateCode};
        Services.responseHandler(apiName: "admin/getCity", body: body).then(
            (data) async {
          // pr.hide();
          setState(() {
            cityLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              cityList = data.Data;
            });
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            cityLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        cityLoading = false;
      });
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
  }

  Future<Null> _covidPositiveDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: covidPositiveDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        covidPositiveDate = picked;
        _covidPositiveDateController.text =
            DateFormat('dd/MM/yyyy').format(covidPositiveDate);
      });
  }

  Future<Null> _plasmaDonationDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: plasmaDonationDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        plasmaDonationDate = picked;
        _covidPositiveDateController.text =
            DateFormat('dd/MM/yyyy').format(plasmaDonationDate);
      });
  }

  Future<Null> _vaccinationDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: vaccinationDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        vaccinationDate = picked;
        _vaccinationDateController.text =
            DateFormat('dd/MM/yyyy').format(plasmaDonationDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Plasma Donation'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Card(
              child: TextFormField(
                controller: name,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Name",
                  contentPadding: EdgeInsets.only(
                    left: 10,
                  ),
                ),
              ),
            ),
            Card(
              child: TextFormField(
                controller: mobile,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Mobile Number",
                  contentPadding: EdgeInsets.only(
                    left: 10,
                  ),
                ),
              ),
            ),
            Card(
              child: Container(
                height: 45,
                // margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<dynamic>(
                  isExpanded: true,
                  hint: stateList.length > 0
                      ? Text(
                          'Select State',
                          style: TextStyle(fontSize: 12),
                        )
                      : Text(
                          "State Not Found",
                          style: TextStyle(fontSize: 12),
                        ),
                  value: selectedState,
                  onChanged: (newValue) {
                    setState(() {
                      selectedState = newValue;
                      cityList = [];
                    });
                    for (int i = 0; i < stateList.length; i++) {
                      if (newValue == stateList[i]["name"]) {
                        selectedStateCode = stateList[i]["isoCode"];
                        selectedCountryCode = stateList[i]["countryCode"];
                        break;
                      }
                    }
                    getCity(selectedStateCode, selectedCountryCode);
                  },
                  items: stateList.map((dynamic value) {
                    return DropdownMenuItem<dynamic>(
                      value: value["name"],
                      child: Text(value["name"]),
                    );
                  }).toList(),
                )),
              ),
            ),
            Card(
              child: Container(
                height: 45,
                // margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  // border: Border.all(
                  //     color: Colors.black,
                  //     style: BorderStyle.solid,
                  //     width: 0.6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<dynamic>(
                    isExpanded: true,
                    hint: cityList.length > 0
                        ? Text(
                            'Select City',
                            style: TextStyle(fontSize: 12),
                          )
                        : Text(
                            "City Not Found",
                            style: TextStyle(fontSize: 12),
                          ),
                    value: selectedCity,
                    onChanged: (newValue) {
                      setState(() {
                        selectedCity = newValue;
                      });
                    },
                    items: cityList.map((dynamic value) {
                      return DropdownMenuItem<dynamic>(
                        value: value["name"],
                        child: Text(value["name"]),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Gender :',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Radio(
                    value: 'Male',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                        print(gender);
                      });
                    }),
                Text("Male"),
                Radio(
                    value: 'Female',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                        print(gender);
                      });
                    }),
                Text("Female"),
                Radio(
                    value: 'Others',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                        print(gender);
                      });
                    }),
                Text("Others"),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Date of Birth :',
                  style: TextStyle(
                    // fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _dateController,
                        onSaved: (String val) {
                          _setDate = val;
                        },
                        decoration: InputDecoration(
                          disabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Weight :',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  height: 55,
                  width: 70,
                  child: Card(
                    elevation: 3,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: weight,
                      decoration: InputDecoration(
                        hintText: "0.0 Kg",
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                Text(
                  'Blood Group :',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  height: 55,
                  width: 70,
                  child: Card(
                    elevation: 3,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: bloodGroup,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  'COVID History',
                  style: TextStyle(
                    // fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: covidPositive == true
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: covidPositive,
                      onChanged: (value) {
                        setState(() {
                          covidPositive = value;
                        });
                      },
                    ),
                    Text('Tested Positive'),
                  ],
                ),
                covidPositive == true
                    ? Row(
                        children: [
                          Text(
                            'Date :',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: cnst.appPrimaryMaterialColor,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              _covidPositiveDate(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                  enabled: false,
                                  keyboardType: TextInputType.text,
                                  controller: _covidPositiveDateController,
                                  onSaved: (String val) {
                                    _setCovidPositiveDate = val;
                                  },
                                  decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Have you donated your Plasma Before?',
                  style: TextStyle(
                    // fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: plasmaDonated,
                      onChanged: (value) {
                        setState(() {
                          plasmaDonated = value;
                        });
                      },
                    ),
                    Text('Yes'),
                    plasmaDonated != true
                        ? Row(
                            children: [
                              Checkbox(
                                value: plasmaNotDonated,
                                onChanged: (value) {
                                  setState(() {
                                    plasmaNotDonated = value;
                                  });
                                },
                              ),
                              Text('No'),
                            ],
                          )
                        : Container(),
                  ],
                ),
                plasmaDonated == true
                    ? Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Donation Date :',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: cnst.appPrimaryMaterialColor,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              _plasmaDonationDate(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                  enabled: false,
                                  keyboardType: TextInputType.text,
                                  controller: _plasmaDonationDateController,
                                  onSaved: (String val) {
                                    _setPlasmaDonationDate = val;
                                  },
                                  decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Are you vaccinated for COVID-19?',
                  style: TextStyle(
                    // fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: vaccinated,
                      onChanged: (value) {
                        setState(() {
                          vaccinated = value;
                        });
                      },
                    ),
                    Text('Yes'),
                    vaccinated != true
                        ? Row(
                            children: [
                              Checkbox(
                                value: notVaccinated,
                                onChanged: (value) {
                                  setState(() {
                                    notVaccinated = value;
                                  });
                                },
                              ),
                              Text('No'),
                            ],
                          )
                        : Container(),
                  ],
                ),
                vaccinated == true
                    ? Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Vaccination Date :',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: cnst.appPrimaryMaterialColor,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              _vaccinationDate(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                  enabled: false,
                                  keyboardType: TextInputType.text,
                                  controller: _vaccinationDateController,
                                  onSaved: (String val) {
                                    _setVaccinationDate = val;
                                  },
                                  decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
            Center(
              child: RaisedButton(
                child: Text('Submit',style: TextStyle(color: Colors.white),),
                color: cnst.appPrimaryMaterialColor,
                onPressed: () {
                  print('Plasma Form Submitted');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
