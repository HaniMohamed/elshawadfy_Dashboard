import 'dart:developer';
import 'dart:io';
import 'package:admin/models/user.dart';
import 'package:admin/shared/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CRUDUsersServices {
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
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    }
    return users;
  }

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
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      return "${e.response!.data}";
    }
  }

  Future editUser(User? user, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response;

    FormData formData;
    formData = FormData.fromMap(user!.toJson());

    try {
      response = await Dio().put(
        "$domainName$editUserAPI${user.id}",
        options: Options(headers: {
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer ${prefs.getString("token")}',
        }),
        data: formData,
      );
      log(response.toString());

      if (response.statusCode == 201 || response.statusCode == 200) {
        return "success";
      } else
        return response.data;
    } on DioError catch (e) {
      log("error in editingUser => ${e.response!.data}");
      if (e.response!.statusCode == 403) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      return "${e.response!.data}";
    }
  }

  Future deleteUser(User? user, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response;

    try {
      response = await Dio().delete(
        "$domainName$deleteUserAPI${user!.id}",
        options: Options(headers: {
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer ${prefs.getString("token")}',
        }),
      );
      log(response.toString());

      if (response.statusCode == 201 ||
          response.statusCode == 200 ||
          response.statusCode == 204) {
        return "success";
      } else
        return response.data;
    } on DioError catch (e) {
      log("error in deletingUser => ${e.response!.data}");
      if (e.response!.statusCode == 403) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      return "${e.response!.data}";
    }
  }
}
