import 'dart:async';
import 'dart:developer';

import 'package:admin/responsive.dart';
import 'package:admin/shared/global.dart';
import 'package:admin/ui/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/leftSide.dart';
import 'widgets/rightSide.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool newLogin = false;

  checkAuthenticated(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Timer(Duration(seconds: 2), () {
      Object? token = prefs.get("token");
      log("token: ${token.toString()}");
      if (token != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else {
        setState(() {
          newLogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    log("initState login screennnnn");
    checkAuthenticated(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
          elevation: 5.0,
          child: Responsive.isMobile(context) ? mobileWidget() : webWidget(),
        ),
      ),
    );
  }

  Widget webWidget() {
    return AnimatedContainer(
      height: MediaQuery.of(context).size.height * 0.8,
      width: newLogin
          ? MediaQuery.of(context).size.width * 0.8
          : MediaQuery.of(context).size.width * 0.4,
      duration: Duration(milliseconds: 500),
      child: Row(
        children: <Widget>[LeftSide(), newLogin ? RightSide() : Container()],
      ),
    );
  }

  Widget mobileWidget() {
    return AnimatedContainer(
      height: newLogin
          ? MediaQuery.of(context).size.height * 0.9
          : MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.8,
      duration: Duration(milliseconds: 500),
      child: Column(
        children: <Widget>[LeftSide(), newLogin ? RightSide() : Container()],
      ),
    );
  }
}
