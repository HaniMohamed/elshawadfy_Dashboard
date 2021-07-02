import 'package:admin/models/appointment.dart';
import 'package:admin/models/appointment.dart';
import 'package:admin/services/crud_appointments_services.dart';
import 'package:admin/services/crud_appointments_services.dart';
import 'package:flutter/material.dart';

class AppointmentViewModel extends ChangeNotifier {
  List<Appointment> appointments = [];

  Future getAppointments(context) async {
    appointments = await CRUDAppointmentsServices().getAppointments(context);
    notifyListeners();
    return appointments;
  }

  Future newAppointment(Appointment appointment, context) async {
    String result =
        await CRUDAppointmentsServices().newAppointment(appointment, context);
    if (result == "success") {
      await getAppointments(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.redAccent,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              "$result",
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      )));
    }
    return result;
  }

  Future editAppointment(Appointment appointment, context) async {
    String result =
        await CRUDAppointmentsServices().editAppointment(appointment, context);
    if (result == "success") {
      await getAppointments(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.redAccent,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              "$result",
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      )));
    }
    return result;
  }

  Future deleteAppointment(Appointment appointment, context) async {
    String result = await CRUDAppointmentsServices()
        .deleteAppointment(appointment, context);
    if (result == "success") {
      await getAppointments(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.redAccent,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              "$result",
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      )));
    }
    return result;
  }
}
