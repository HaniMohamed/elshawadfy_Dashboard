import 'dart:developer';
import 'dart:io';

import 'package:admin/models/user.dart';
import 'package:admin/shared/constants.dart';
import 'package:admin/shared/global.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetUsers {
  Future getUsers(String type) async {
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
      Response response = await Dio().post(
        '$domainName$api',
        options: Options(headers: {
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader:
              "Bearer ${prefs.getString("access_token")}"
        }),
      );
      log(response.toString());
      users =
          List<User>.from(response.data.map((model) => User.fromJson(model)));
      log(users[0].username.toString());
    } catch (e) {
      log(e.toString());
    }
    return users;
  }
}
