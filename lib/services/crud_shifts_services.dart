import 'dart:developer';
import 'dart:io';

import 'package:admin/models/shift.dart';
import 'package:admin/shared/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CRUDShiftsServices {
  Future getOpenedShifts(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Shift> shifts = [];

    try {
      Response response = await Dio().get(
        '$domainName$listShiftsAPI?closed=false',
        options: Options(headers: {
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
        }),
      );
      log(response.toString());
      shifts =
          List<Shift>.from(response.data.map((model) => Shift.fromJson(model)));
      // log(shifts[0].patient!.username.toString());
    } on DioError catch (e) {
      log("error in listShifts => ${e.response}");
      if (e.response!.statusCode == 403) {
        prefs.clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    }
    return shifts;
  }

  Future newShift(Shift? shift, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response;
    log("username :" + shift!.receptionist!.username.toString());

    FormData formData;
    formData = FormData.fromMap(shift.toJson());
    log(formData.fields.join("\n"));

    try {
      response = await Dio().post(
        "$domainName$newShiftsAPI",
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
      log("error in createShift => ${e.response!.data}");
      if (e.response!.statusCode == 403) {
        prefs.clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      return "${e.response!.data}";
    }
  }

  Future editShift(Shift? shift, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response;

    FormData formData;
    formData = FormData.fromMap(shift!.toJson());
    log(formData.fields.join("\n"));

    try {
      response = await Dio().put(
        "$domainName$editShiftsAPI${shift.id}",
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
      log("error in editingShift => ${e.response!.data}");
      if (e.response!.statusCode == 403) {
        prefs.clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      return "${e.response!.data}";
    }
  }

  Future deleteShift(Shift? shift, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response;

    try {
      response = await Dio().delete(
        "$domainName$deleteShiftsAPI${shift!.id}",
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
      log("error in deletingShift => ${e.response!.data}");
      if (e.response!.statusCode == 403) {
        prefs.clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      return "${e.response!.data}";
    }
  }
}
