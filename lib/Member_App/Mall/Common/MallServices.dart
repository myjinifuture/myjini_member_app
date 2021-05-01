import 'dart:convert';

import 'package:dio/dio.dart';

import 'MallClassList.dart';
import 'MallConstants.dart';

Dio dio = new Dio();

class MallServices {
  static Future<MallAPIClass> GetBanner() async {
    String url = Mall_API_Url + 'getbanners';
    print("GetBanner url : " + url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        MallAPIClass saveData =
            new MallAPIClass(message: 'No Data', success: "0");

        print("GetBanner Response: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);

        saveData.message = memberDataClass["message"];
        saveData.success = memberDataClass["success"];
        saveData.data = memberDataClass["data"];
        return saveData;
      } else {
        print("Error GetBanner");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetBanner : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetCateogries() async {
    String url = Mall_API_Url + 'allcategories';
    print("GetCateogries url : " + url);
    FormData data = FormData.fromMap({"language_id": 1});
    try {
      final response = await dio.post(url, data: data);
      if (response.statusCode == 200) {
        List list = [];
        print("GetCateogries Response: " + response.data.toString());
        final responseData = jsonDecode(response.data);
        if (responseData["success"] == "1") {
          print(responseData["data"]);
          list = responseData["data"];
        }
        return list;
      } else {
        print("Error GetCateogries");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetCateogries : ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
