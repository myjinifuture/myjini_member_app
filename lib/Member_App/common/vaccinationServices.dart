import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_society_new/Member_App/common/Classlist.dart';

Dio dio = new Dio();

class VaccinationServices{
  static Future<VaccinationResponseDataClass> responseHandler(
      {@required apiName,body})async {
    String url = "$apiName";
    var response;
    try {
      if (body == null) {
        response = await dio.get(url);
      } else {
        response = await dio.get(url);
      }
      print(apiName);
      print(body);
      if (response.statusCode == 200) {
        VaccinationResponseDataClass responseData =  VaccinationResponseDataClass(
            centers: "");
        var data = response.data;
        print(response.data["centers"]);
        responseData.centers = data["centers"];
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
}