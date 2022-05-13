import 'dart:developer';

import 'package:admin/controllers/MenuController.dart';
import 'package:admin/models/shift.dart';
import 'package:admin/responsive.dart';
import 'package:admin/ui/screens/appointments/appointments_screen.dart';
import 'package:admin/ui/screens/patients/pateints_screen.dart';
import 'package:admin/view_model/shift_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _drawerIndex = 0;
  List<Widget> bodyWidgets = [
    // DashboardScreen(),
    PatientsScreen(),
    AppointmentsScreen(),
  ];

  checkAuthenticated(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Object? token = prefs.get("token");
    log("token: ${token.toString()}");
    if (token == null) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    }
  }

  getCurrentShift() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Object? username = prefs.get("username");
    List<Shift> shifts =
        await Provider.of<ShiftViewModel>(context, listen: false)
            .getShifts(context);
    if (shifts.isNotEmpty) {
      // if (shifts[0].receptionist!.username != username) {
      //   showDialog<void>(
      //     context: context,
      //     barrierDismissible: false,
      //     barrierColor: Colors.black87,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: const Text('Wrong shift receptionist'),
      //         content: SingleChildScrollView(
      //           child: ListBody(
      //             children: <Widget>[
      //               Text(
      //                   'There is another shift of (${shifts[0].receptionist!.username}) is opened'),
      //               Text(
      //                   '(${shifts[0].receptionist!.username}) must login and close it first'),
      //             ],
      //           ),
      //         ),
      //         actions: <Widget>[
      //           TextButton(
      //             child: const Text('logout'),
      //             onPressed: () {
      //               prefs.clear();
      //               Navigator.of(context).pushNamedAndRemoveUntil(
      //                   '/login', (Route<dynamic> route) => false);
      //             },
      //           ),
      //         ],
      //       );
      //     },
      //   );
      // }
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('New Shift'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('There is no shifts opened now'),
                  Text('please, start new one'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('New Shift'),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  int? id = prefs.getInt("user_id");
                  String? username = prefs.getString("username");
                  if (id == null || username == null) {
                    prefs.clear();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login', (Route<dynamic> route) => false);
                  }
                  log(id.toString() + "\n" + username.toString());
                  String result =
                      await Provider.of<ShiftViewModel>(context, listen: false)
                          .newShift(
                              Shift(
                                  closed: false,
                                  receptionist:
                                      Receptionist(id: id, username: username)),
                              context);
                  if (result == "success") {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  changeBody(int index) {
    Provider.of<MenuController>(context, listen: false).showPageIndex(index);
  }

  @override
  void initState() {
    checkAuthenticated(context);
    getCurrentShift();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(changeBody),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(changeBody),
              ),
            Consumer<MenuController>(
              builder: (context, menu, child) {
                return Expanded(
                  // It takes 5/6 part of the screen
                  flex: 5,
                  child: bodyWidgets[menu.indexPage],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
