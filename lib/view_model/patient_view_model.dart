import 'package:admin/models/user.dart';
import 'package:admin/services/crud_users_services.dart';
import 'package:flutter/material.dart';

class PatientViewModel extends ChangeNotifier {
  List<User> users = [];

  Future getPatients(context) async {
    users = await CRUDUsersServices().getUsers("P", context);
    notifyListeners();
    return users;
  }

  Future newPatient(User user, context) async {
    String result = await CRUDUsersServices().newUser(user, context);
    if (result == "success") {
      await getPatients(context);
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

  Future editPatient(User user, context) async {
    String result = await CRUDUsersServices().editUser(user, context);
    if (result == "success") {
      await getPatients(context);
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

  Future deletePatient(User user, context) async {
    String result = await CRUDUsersServices().deleteUser(user, context);
    if (result == "success") {
      await getPatients(context);
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
