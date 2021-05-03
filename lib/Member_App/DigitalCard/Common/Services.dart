import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:smart_society_new/Member_App/DigitalCard/Common/ClassList.dart';
import 'package:smart_society_new/Member_App/DigitalCard/Common/Constants.dart';

Dio dio = new Dio();

class Services {
  static Future<SaveDataClass> MemberSignUp(data) async {
    String url = APIURL.API_URL + 'MemberSignUp';
    print("MemberSignUp URL: " + url);
    final response = await dio.post(url, data: data);
    try {
      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        print("MemberSignUp response: " + jsonResponse.toString());
        SaveDataClass saveDataClass = new SaveDataClass.fromJson(jsonResponse);
        return saveDataClass;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("SaveTA Erorr : " + e.toString());
      throw Exception("Something Went Wrong");
    }
  }
}
