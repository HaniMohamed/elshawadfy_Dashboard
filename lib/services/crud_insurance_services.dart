import 'dart:developer';
import 'dart:io';

import 'package:admin/models/insurance.dart';
import 'package:admin/shared/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CRUDInsurancesServices {
  Future getInsurances(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Insurance> insurances = [];

    try {
      Response response = await Dio().get(
        '$domainName$listInsuranceAPI',
        options: Options(headers: {
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
        }),
      );
      // log(response.toString());
      insurances = List<Insurance>.from(
          response.data.map((model) => Insurance.fromJson(model)));
      // log(insurances[0].patient!.username.toString());
    } on DioError catch (e) {
      log("error in listInsurances => ${e.response}");
      if (e.response!.statusCode == 403) {
        prefs.clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    }
    return insurances;
  }

  Future newInsurance(Insurance? insurance, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response;

    FormData formData;
    formData = FormData.fromMap(insurance!.toJson());
    log(formData.fields.join("\n"));

    try {
      response = await Dio().post(
        "$domainName$newInsuranceAPI",
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
      log("error in createInsurance => ${e.response!.data}");
      if (e.response!.statusCode == 403) {
        prefs.clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      return "${e.response!.data}";
    }
  }

  Future editInsurance(Insurance? insurance, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response;

    FormData formData;
    formData = FormData.fromMap(insurance!.toJson());

    try {
      response = await Dio().put(
        "$domainName$editInsuranceAPI${insurance.id}",
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
      log("error in editingInsurance => ${e.response!.data}");
      if (e.response!.statusCode == 403) {
        prefs.clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      return "${e.response!.data}";
    }
  }

  Future deleteInsurance(Insurance? insurance, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response;

    try {
      response = await Dio().delete(
        "$domainName$deleteInsuranceAPI${insurance!.id}",
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
      log("error in deletingInsurance => ${e.response!.data}");
      if (e.response!.statusCode == 403) {
        prefs.clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      return "${e.response!.data}";
    }
  }
}
