import 'dart:async';
import 'dart:developer';

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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
          elevation: 5.0,
          child: AnimatedContainer(
            height: 700,
            width: newLogin ? 1500 : 750,
            duration: Duration(milliseconds: 500),
            child: Row(
              children: <Widget>[
                LeftSide(),
                newLogin ? RightSide() : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
