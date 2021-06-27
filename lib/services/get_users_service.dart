import 'dart:developer';
import 'dart:io';

import 'package:admin/models/user.dart';
import 'package:admin/shared/constants.dart';
import 'package:admin/shared/global.dart';
import 'package:admin/ui/screens/login/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetUsers {
  Future getUsers(String type, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<User> users = [];
    String? api;
    switch (type) {
      case 'D':
        api = listDoctorsAPI;
        break;

      case 'R':
        api = listReceptionistsAPI;
        break;

      case 'P':
        api = listPatientsAPI;
        break;
    }

    try {
      Response response = await Dio().get(
        '$domainName$api',
        options: Options(headers: {
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
        }),
      );
      log(response.toString());
      users =
          List<User>.from(response.data.map((model) => User.fromJson(model)));
      log(users[0].username.toString());
    } on DioError catch (e) {
      log("error in loginAccess => ${e.response}");
      if (e.response!.statusCode == 403) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    }
    return users;
  }
}
