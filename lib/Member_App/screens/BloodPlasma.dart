import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class BloodPlasma extends StatefulWidget {
  @override
  _BloodPlasmaState createState() => _BloodPlasmaState();
}

class _BloodPlasmaState extends State<BloodPlasma> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Plasma (COVID-19)'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'Are you a Donor or Receiver?',
            style: TextStyle(
              fontSize: 20,
              color: Colors.red,
              fontWeight: FontWeight.w500,fontStyle: FontStyle.italic
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, '/AddPlasmaDonor');
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'images/bloodplasmadonor.png',
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Donor',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: constant.appPrimaryMaterialColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'images/bloodplasmareceiver.png',
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Receiver',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: constant.appPrimaryMaterialColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          )
        ],
      ),
    );
  }
}
