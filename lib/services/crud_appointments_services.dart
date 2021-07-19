import 'dart:developer';
import 'dart:io';

import 'package:admin/models/appointment.dart';
import 'package:admin/shared/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CRUDAppointmentsServices {
  Future getAppointments(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Appointment> appointments = [];

    try {
      Response response = await Dio().get(
        '$domainName$listAppointmentsAPI',
        options: Options(headers: {
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
        }),
      );
      log(response.toString());
      appointments = List<Appointment>.from(
          response.data.map((model) => Appointment.fromJson(model)));
      // log(appointments[0].patient!.username.toString());
    } on DioError catch (e) {
      log("error in listAppointments => ${e.response}");
      if (e.response!.statusCode == 403) {
        prefs.clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    }
    return appointments;
  }

  Future newAppointment(Appointment? appointment, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response;

    FormData formData;
    formData = FormData.fromMap(appointment!.toJson());
    log(formData.fields.join("\n"));

    try {
      response = await Dio().post(
        "$domainName$newAppointmentAPI",
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
      log("error in createAppointment => ${e.response!.data}");
      if (e.response!.statusCode == 403) {
        prefs.clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      return "${e.response!.data}";
    }
  }

  Future editAppointment(Appointment? appointment, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response;

    FormData formData;
    formData = FormData.fromMap(appointment!.toJson());

    try {
      response = await Dio().put(
        "$domainName$editAppointmentAPI${appointment.id}",
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
      log("error in editingAppointment => ${e.response!.data}");
      if (e.response!.statusCode == 403) {
        prefs.clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      return "${e.response!.data}";
    }
  }

  Future deleteAppointment(Appointment? appointment, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response;

    try {
      response = await Dio().delete(
        "$domainName$deleteAppointmentAPI${appointment!.id}",
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
      log("error in deletingAppointment => ${e.response!.data}");
      if (e.response!.statusCode == 403) {
        prefs.clear();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      return "${e.response!.data}";
    }
  }
}
