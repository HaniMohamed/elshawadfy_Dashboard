import 'dart:developer';
import 'dart:io';

import 'package:admin/models/radiology.dart';
import 'package:admin/shared/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CRUDRaysServices {
  Future getRays(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Radiology> rays = [];

    try {
      Response response = await Dio().get(
        '$domainName$listRaysAPI',
        options: Options(headers: {
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
        }),
      );
      // log(response.toString());
      rays = List<Radiology>.from(
          response.data.map((model) => Radiology.fromJson(model)));
      // log(rays[0].name.toString());
    } on DioError catch (e) {
      log("error in listRays => ${e.response}");
      if (e.response!.statusCode == 403) {
        prefs.clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    }
    return rays;
  }

  Future newRays(Radiology? ray, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response;

    FormData formData;
    formData = FormData.fromMap(ray!.toJson());

    try {
      response = await Dio().post(
        "$domainName$newRaysAPI",
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
      log("error in createRays => ${e.response!.data}");
      if (e.response!.statusCode == 403) {
        prefs.clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      return "${e.response!.data}";
    }
  }

  Future editRays(Radiology? ray, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response;

    FormData formData;
    formData = FormData.fromMap(ray!.toJson());

    try {
      response = await Dio().put(
        "$domainName$editRaysAPI${ray.id}",
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
      log("error in editingRays => ${e.response!.data}");
      if (e.response!.statusCode == 403) {
        prefs.clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      return "${e.response!.data}";
    }
  }

  Future deleteRays(Radiology? ray, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response;

    try {
      response = await Dio().delete(
        "$domainName$deleteRaysAPI${ray!.id}",
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
      log("error in deletingRays => ${e.response!.data}");
      if (e.response!.statusCode == 403) {
        prefs.clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      return "${e.response!.data}";
    }
  }
}
