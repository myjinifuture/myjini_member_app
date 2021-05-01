import 'package:flutter/material.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as constant;
import 'package:smart_society_new/Member_App/common/constant.dart';

class StaffProfile extends StatefulWidget {
  var staffData;

  StaffProfile({this.staffData});

  @override
  _StaffProfileState createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  TextEditingController nameText = new TextEditingController();
  TextEditingController contactText = new TextEditingController();
  TextEditingController vehicleText = new TextEditingController();
  TextEditingController workText = new TextEditingController();
  TextEditingController purposeText = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() {
    nameText.text = widget.staffData["Name"];
    contactText.text = widget.staffData["ContactNo"];
    vehicleText.text = widget.staffData["VehicleNo"];
    workText.text = widget.staffData["Work"];
    purposeText.text = widget.staffData["Purpose"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Edit Staff",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: widget.staffData["Image"] != '' &&
                        widget.staffData["Image"] != null
                    ? FadeInImage.assetNetwork(
                        placeholder: '',
                        image: Image_Url +
                            "${widget.staffData["Image"]}",
                        width: 60,
                        height: 60,
                        fit: BoxFit.fill)
                    : Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(75),
                          color: constant.appPrimaryMaterialColor,
                        ),
                        child: Center(
                          child: Text(
                            "${widget.staffData["Name"].toString().substring(0, 1).toUpperCase()}",
                            style: TextStyle(fontSize: 35, color: Colors.white),
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: nameText,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(),
                      ),
                      counterText: "",
                      labelText: "Staff Name",
                      hasFloatingPlaceholder: true,
                      labelStyle: TextStyle(fontSize: 13)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: contactText,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(),
                      ),
                      counterText: "",
                      labelText: "Contact Number",
                      hasFloatingPlaceholder: true,
                      labelStyle: TextStyle(fontSize: 13)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: vehicleText,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(),
                      ),
                      counterText: "",
                      labelText: "Vehicle Number",
                      hasFloatingPlaceholder: true,
                      labelStyle: TextStyle(fontSize: 13)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: workText,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(),
                      ),
                      counterText: "",
                      labelText: "Work of Staff",
                      hasFloatingPlaceholder: true,
                      labelStyle: TextStyle(fontSize: 13)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: purposeText,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(),
                      ),
                      counterText: "",
                      labelText: "Purpose of Staff",
                      hasFloatingPlaceholder: true,
                      labelStyle: TextStyle(fontSize: 13)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Update Staff",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      color: Colors.green,
                      onPressed: () {})),
            ),
          ],
        ),
      ),
    );
  }
}
