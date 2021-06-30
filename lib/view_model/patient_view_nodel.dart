import 'package:admin/models/user.dart';
import 'package:admin/services/user_services/edit_user_service.dart';
import 'package:admin/services/user_services/get_users_service.dart';
import 'package:admin/services/user_services/new_user_service.dart';
import 'package:flutter/material.dart';

class PatientViewModel extends ChangeNotifier {
  List<User> users = [];

  Future getPatients(context) async {
    users = await GetUsers().getUsers("P", context);
    notifyListeners();
    return users;
  }

  Future newPatient(User user, context) async {
    String result = await NewUserService().newUser(user, context);
    if (result == "success") {
      await getPatients(context);
    }
    return result;
  }

  Future editPatient(User user, context) async {
    String result = await EditUserService().editUser(user, context);
    if (result == "success") {
      await getPatients(context);
    }
    return result;
  }
}
