import 'dart:io';

import 'package:admin/shared/constants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  Future<String> login(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FormData formData = FormData.fromMap({
      "username": "$username",
      "password": "$password",
    });

    try {
      Response response = await Dio().post(
        "$domainName$loginAPI",
        data: formData,
        options: Options(headers: {
          HttpHeaders.acceptHeader: "application/json",
        }),
      );

      print(response);
      prefs.setString("token", response.data["access"]);
      prefs.setString("username", response.data["username"]);
      prefs.setString("type", response.data["user_type"]);
      prefs.setInt("user_id", response.data["id"]);
      // Global.token = response.data["access"];
      // Global.username = response.data["username"];
      // Global.type = response.data["user_type"];
      return "success";
    } on DioError catch (e) {
      print("error in loginAccess => ${e.response}");
      if (e.response!.statusCode != 404)
        return "${e.response!.data['detail'].toString()}";
      else
        return "Unknown error";
    }
  }
}
