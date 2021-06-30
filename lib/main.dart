import 'package:admin/ui/screens/dashboard/dashboard_screen.dart';
import 'package:admin/ui/screens/login/login.dart';
import 'package:admin/shared/constants.dart';
import 'package:admin/controllers/MenuController.dart';
import 'package:admin/ui/screens/main/main_screen.dart';
import 'package:admin/ui/screens/patients/pateints_screen.dart';
import 'package:admin/view_model/patient_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => MenuController(),
    ),
    ChangeNotifierProvider(
      create: (context) => PatientViewModel(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Elshawadfy Radiology',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/login': (context) => Login(),
      },
    );
  }
}
