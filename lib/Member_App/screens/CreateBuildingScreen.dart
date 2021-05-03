import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Member_App/screens/CreateBuildingSlider.dart';

class CreateBuildingScreen extends StatefulWidget {
  @override
  _CreateBuildingScreenState createState() => _CreateBuildingScreenState();
}

class _CreateBuildingScreenState extends State<CreateBuildingScreen> {
  String dropdownValue;
  String dropdownCityValue;
  String dropdownStateValue;
  TextEditingController txtTotalWings = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Building Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            //Navigator.pushReplacementNamed(context, "/CreateBuildingSlider");
          },
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
        //  Navigator.pushReplacementNamed(context, "/CreateBuildingSlider");

          print("============================");
          print(txtTotalWings.text);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => CreateBuildingSlider(
                    wingData: txtTotalWings.text,
                  )));
        },
        child: Container(
          height: 50,
          color: cnst.appPrimaryMaterialColor,
          child: Center(
              child: Text(
            "SUBMIT",
            style: TextStyle(fontSize: 18, color: Colors.white),
          )),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 30.0, bottom: 10, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Type",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: dropdownValue == null
                          ? Text(
                              "  Select ",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            )
                          : Text(dropdownValue),
                      dropdownColor: Colors.white,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 40,
                        color: Colors.grey,
                      ),
                      isExpanded: true,
                      value: dropdownValue,
                      items: [
                        "Buildings(Multiple Floors)",
                        "Society(Single Floor)",
                        "Commercial"
                      ].map((value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(value),
                            ));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownValue = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                child: Text(
                  "Name",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 50,
                child: TextFormField(
                 // controller: txtTotalWings,
                  scrollPadding: EdgeInsets.all(0),
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    // prefixIcon: Icon(
                    //   Icons.title,
                    //   //color: cnst.cnst.appPrimaryMaterialColor,
                    // ),
                    //hintText: "Title"
                  ),
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                child: Text(
                  "Total Wings",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 50,
                child: TextFormField(
                  controller: txtTotalWings,
                  scrollPadding: EdgeInsets.all(0),
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    // prefixIcon: Icon(
                    //   Icons.title,
                    //   //color: cnst.cnst.appPrimaryMaterialColor,
                    // ),
                    //hintText: "Title"
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "State",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: dropdownStateValue == null
                          ? Text(
                              "  Select State ",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            )
                          : Text(dropdownStateValue),
                      dropdownColor: Colors.white,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 40,
                        color: Colors.grey,
                      ),
                      isExpanded: true,
                      value: dropdownStateValue,
                      items: ["Gujarat", "Punjab", "Rajkot", "Vapi", "Udhana"]
                          .map((value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(value),
                            ));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownStateValue = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "City",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: dropdownCityValue == null
                          ? Text(
                              "  Select City ",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            )
                          : Text(dropdownCityValue),
                      dropdownColor: Colors.white,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 40,
                        color: Colors.grey,
                      ),
                      isExpanded: true,
                      value: dropdownCityValue,
                      items: ["Varachha", "Amroli", "Kadodra", "Utran", "VIP"]
                          .map((value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(value),
                            ));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownCityValue = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                child: Text(
                  "Address",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                // height: 50,
                child: TextFormField(
                  // controller: txtTitle,
                  scrollPadding: EdgeInsets.all(0),
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    // prefixIcon: Icon(
                    //   Icons.title,
                    //   //color: cnst.cnst.appPrimaryMaterialColor,
                    // ),
                    //hintText: "Title"
                  ),
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
