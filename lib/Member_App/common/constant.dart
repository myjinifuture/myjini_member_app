import 'package:flutter/material.dart';

// const String API_URL = "http://smartsociety.itfuturz.com/api/AppAPI/";
// const String Image_Url = Image_Url;
// const String Image_Url1 = Image_Url;

const String API_URL = "http://mywatcher.itfuturz.com/api/AppAPI/";
 String NODE_API = "";
 String Image_Url = "";
const String Image_Url1 = "http://mywatcher.itfuturz.com";
const Inr_Rupee = "₹";
const String Access_Token = "Mjdjhcbj43jkmsijkmjJKJKJoijlkmlkjo-HfdkvjDJjMoikjnNJn-JNFhukmk";

//const String whatsAppLink = "https://wa.me/#mobile?text=#msg";
const String whatsAppLink =
    "https://api.whatsapp.com/send?phone=#mobile&text=#msg";

class MESSAGES {
  static const String INTERNET_ERROR = "No Internet Connection";
  static const String INTERNET_ERROR_RETRY =
      "No Internet Connection.\nPlease Retry";
}

class Session {
  static const String session_login = "Login_data";
  static const String Member_Id = "Member_id";
  static const String selFlatHolderType = "selFlatHolderType";
  static const String SocietyId = "SocietyId";
  static const String Name = "Member_Name";
  static  bool isInForeground = true;
  static const String Profile = "Profile";
  static const String CompanyName = "Companyname";
  static const String Designation = "BusinessJob";
  static const String BusinessDescription = "Description";
  static const String BloodGroup = "Bloodgroup";
  static const String Gender = "Gender";
  static const String Email = "Email";
  static const String DOB = "Dob";
  static const String ResidenceType = "ResidenceType";
  static const String FlatNo = "FlatNo";
  static const String FlatId = "FlatId";
  static const String SocietyCode = "SocietyCode";
  static const String Wing = "Wing";
  static const String WingId = "WingId";
  static const String Address = "Address";
  static const String isPrivate = "isPrivate";
  static const String ParentId = "ParentId";
  static const String ProfileUpdateFlag = "ProfileUpdateFlag";

  static const String EventId = "EventId";
  static const String digital_Id = "digital_Id";
  static const String IsVerified = "is_verified";
  static const String forFirstTime = "forFirstTime";
  static const String mapLink = "mapLink";
  static const String societyName = "societyName";
}

Map<int, Color> appprimarycolors = {
  50: Color.fromRGBO(114, 34, 169, .1),
  100: Color.fromRGBO(114, 34, 169, .2),
  200: Color.fromRGBO(114, 34, 169, .3),
  300: Color.fromRGBO(114, 34, 169, .4),
  400: Color.fromRGBO(114, 34, 169, .5),
  500: Color.fromRGBO(114, 34, 169, .6),
  600: Color.fromRGBO(114, 34, 169, .7),
  700: Color.fromRGBO(114, 34, 169, .8),
  800: Color.fromRGBO(114, 34, 169, .9),
  900: Color.fromRGBO(114, 34, 169, 1)
};

MaterialColor appPrimaryMaterialColor =
    MaterialColor(0xFF7222A9, appprimarycolors);
