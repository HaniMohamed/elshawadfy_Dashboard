import 'dart:developer';

import 'package:admin/controllers/MenuController.dart';
import 'package:admin/responsive.dart';
import 'package:admin/ui/screens/appointments/appointments_screen.dart';
import 'package:admin/ui/screens/dashboard/dashboard_screen.dart';
import 'package:admin/ui/screens/patients/pateints_screen.dart';
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
    Container(),
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

  changeBody(int index) {
    Provider.of<MenuController>(context, listen: false).showPageIndex(index);
  }

  @override
  void initState() {
    checkAuthenticated(context);
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
