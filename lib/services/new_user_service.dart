import 'dart:developer';
import 'dart:io';

import 'package:admin/models/user.dart';
import 'package:admin/shared/constants.dart';
import 'package:admin/shared/global.dart';
import 'package:admin/ui/screens/login/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewUserService {
  Future newUser(User? user, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response;

    FormData formData;
    formData = FormData.fromMap(user!.toJson());

    try {
      response = await Dio().post(
        "$domainName$newUserAPI",
        options: Options(headers: {
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer ${prefs.getString("token")}',
        }),
        data: formData,
      );
      log(response.toString());

      if (response.statusCode == 201) {
        return "success";
      } else
        return response.data;
    } on DioError catch (e) {
      log("error in createUser => ${e.response!.data}");
      if (e.response!.statusCode == 403) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
      return "${e.response!.data}";
    }
  }
}
