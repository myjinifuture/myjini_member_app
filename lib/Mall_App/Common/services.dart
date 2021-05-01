import 'dart:developer';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:smart_society_new/Mall_App/Common/Classlist.dart';
import 'constant.dart';

Dio dio = new Dio();

class Services {
  static Future<List> postforlist({apiname, body}) async {
    String url = API_URL + '$apiname';
    print("$apiname url : " + url);
    var response;
    try {
      if (body == null) {
        response = await dio.post(url);
      } else {
        response = await dio.post(url, data: body);
      }
      if (response.statusCode == 200) {
        List list = [];
        print("$apiname Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true &&
            responseData["Data"].length > 0) {
          list = responseData["Data"];
        }
        return list;
      } else {
        print("error ->" + response.data.toString());
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("error -> ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> postForSave({apiname, body}) async {
    String url = API_URL + '$apiname';
    print("$apiname url : " + url);
    var response;
    try {
      if (body == null) {
        response = await dio.post(url);
      } else {
        response = await dio.post(url, data: body);
      }
      if (response.statusCode == 200) {
        SaveDataClass savedata =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: null);
        print("$apiname Response: " + response.data.toString());
        var responseData = response.data;
        savedata.Message = responseData["Message"];
        savedata.IsSuccess = responseData["IsSuccess"];
        savedata.Data = responseData["Data"].toString();

        return savedata;
      } else {
        print("error ->" + response.data.toString());
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("error -> ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
