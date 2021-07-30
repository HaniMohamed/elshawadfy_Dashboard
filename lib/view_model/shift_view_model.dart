import 'package:admin/models/shift.dart';
import 'package:admin/services/crud_shifts_services.dart';
import 'package:flutter/material.dart';

class ShiftViewModel extends ChangeNotifier {
  List<Shift> shifts = [];

  Future getShifts(context) async {
    shifts = await CRUDShiftsServices().getOpenedShifts(context);
    notifyListeners();
    return shifts;
  }

  Future newShift(Shift shift, context) async {
    String result = await CRUDShiftsServices().newShift(shift, context);
    if (result == "success") {
      await getShifts(context);
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

  Future editShift(Shift shift, context) async {
    String result = await CRUDShiftsServices().editShift(shift, context);
    if (result == "success") {
      await getShifts(context);
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

  Future deleteShift(Shift shift, context) async {
    String result = await CRUDShiftsServices().deleteShift(shift, context);
    if (result == "success") {
      await getShifts(context);
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
