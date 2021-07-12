import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Classlist.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:xml2json/xml2json.dart';

Dio dio = new Dio();
Xml2Json xml2json = new Xml2Json();

class Services {

  static Future<ResponseDataClass> responseHandler(
      {@required apiName, body}) async {
    String url = constant.NODE_API + "$apiName";
    var header = Options(
      headers: {
        "authorization": "$Access_Token" // set content-length
      },
    );
    var response;
    try {
      if (body == null) {
        response = await dio.post(url, options: header);
      } else {
        response = await dio.post(url, data: body, options: header);
      }
      print(apiName);
      print(body);
      if (response.statusCode == 200) {
        ResponseDataClass responseData = new ResponseDataClass(
            Message: "No Data", IsSuccess: false, Data: "");
        var data = response.data;
        print(response.data["Data"]);
        print(response.data["Message"]);
        print(response.data["IsSuccess"]);
        responseData.Message = data["Message"];
        responseData.IsSuccess = data["IsSuccess"];
        responseData.Data = data["Data"];
        return responseData;
      } else {
        print("error ->" + response.data.toString());
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Catch error -> ${e.toString()}");
      throw Exception(e.toString());
    }
  }


  static Future<ResponseDataClass> responseHandlerForBase64(
      {@required apiName, body}) async {
    String url = constant.NODE_API + "$apiName";
    var header = Options(
      headers: {
        "authorization": "$Access_Token" ,
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
        contentType: Headers.formUrlEncodedContentType
    );
    String jsonString = json.encode(body); // encode map to json
    // String paramName = 'param'; // give the post param a name
    // String formBody = paramName + '=' + Uri.encodeQueryComponent(jsonString);
    var response;
    //Instance level
    dio.options.contentType= Headers.formUrlEncodedContentType;
    try {
      if (jsonString == null) {
        response = await dio.post(url);
      } else {
        response = await dio.post(url, data: body,options:header);
      }
      print(body);
      print(apiName);
      if (response.statusCode == 200) {
        ResponseDataClass responseData = new ResponseDataClass(
            Message: "No Data", IsSuccess: false, Data: "");
        var data = response.data;
        print(response.data["Data"]);
        responseData.Message = data["Message"];
        responseData.IsSuccess = data["IsSuccess"];
        responseData.Data = data["Data"];

        return ResponseDataClass.fromJson(data);
      } else {
        print("error ->" + response.data.toString());
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Catch error -> ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
