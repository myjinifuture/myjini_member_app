import 'package:flutter/material.dart';

class APIURL {
  static const String API_URL =
      "http://digitalcard.co.in/DigitalcardService.asmx/";
  static const String API_URL_RazorPay_Order =
      "http://razorpayapi.itfuturz.com/Service.asmx/";
}

const Inr_Rupee = "₹";
const Color appcolor = Color.fromRGBO(48, 131, 201, 1);
const Color buttoncolor = Color.fromRGBO(85, 96, 128, 1);
const String whatsAppLink =
    "https://wa.me/#mobile?text=#msg"; //mobile no with country code
const String smsLink = "sms:#mobile?body=#msg"; //mobile no with country code
const String mailLink =
    "mailto:#mail?subject=#subject&body=#msg"; //mobile no with country code
const String shareMessage =
    "hello #recever, \nmy name is #sender \nyou can see my digital visiting card from the below link. \n#link \nRegards \n#sender";
const String profileUrl = "http://digitalcard.co.in?uid=#id";
const String playstoreUrl = "https://urlzs.com/JzR8A";
//const String inviteFriMsg = "http://digitalcard.co.in?uid=#id, smart & simple app to manage your digital visiting card & business profile.\nDownload the app from #appurl and use my refer code “#refercode” to get 15 days free trial.";
const String inviteFriMsg =
    "Hi there, \nYou came to my mind as I was using this interesting App *'Digital Card'*.\nhttp://digitalcard.co.in?uid=#id.\nI have been using this App to manage my business smartly & in a digital way.\nYou can also create your own business profile.\n\n*Download the App from the below link*. #appurl";
const String directShareMsg =
    "Hello Sir, \nMy name is #sender \nyou can see my digital visiting card from the below link \n#link \nRegards \n#sender \n\Download the App from the below link to make your own visiting card \n#applink";
