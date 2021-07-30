import 'package:admin/controllers/MenuController.dart';
import 'package:admin/models/shift.dart';
import 'package:admin/shared/constants.dart';
import 'package:admin/view_model/shift_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends StatefulWidget {
  Function? function;

  SideMenu(this.function);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int _selectedIndex = 0;
  List<String> menuTitles = [
    // "Dashboard",
    "Patients",
    "Appointments",
  ];

  List<String> menuImages = [
    // "assets/icons/menu_dashbord.svg",
    "assets/icons/patients.svg",
    "assets/icons/appointment.svg",
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: menuTitles.length,
                itemBuilder: (BuildContext context, int index) {
                  return Consumer<MenuController>(
                    builder: (context, menu, child) {
                      return DrawerListTile(
                        title: menuTitles[index],
                        svgSrc: menuImages[index],
                        isSelected: index == menu.indexPage,
                        press: () {
                          widget.function!(index);
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                      );
                    },
                  );
                }),
          ),
          Consumer<ShiftViewModel>(
            builder: (context, shiftModel, child) {
              if (shiftModel.shifts.isNotEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Shift No: ${shiftModel.shifts[0].id}"),
                    Text("total income: ${shiftModel.shifts[0].totalIncome}"),
                    TextButton(
                        onPressed: () async {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            barrierColor: Colors.black87,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Close Shift'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('Your total income is: '),
                                      Text(
                                        "${shiftModel.shifts[0].totalIncome} L.E",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Yes, Close'),
                                    onPressed: () async {
                                      String result = await Provider.of<
                                                  ShiftViewModel>(context,
                                              listen: false)
                                          .editShift(
                                              Shift(
                                                  id: shiftModel.shifts[0].id,
                                                  closed: true,
                                                  receptionist: shiftModel
                                                      .shifts[0].receptionist),
                                              context);
                                      if (result == "success") {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.clear();
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                '/login',
                                                (Route<dynamic> route) =>
                                                    false);
                                      }
                                    },
                                  ),
                                  TextButton(
                                    child: const Text(
                                      'No',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   content: Row(
                          //     children: [
                          //       Icon(
                          //         Icons.close,
                          //         color: Colors.redAccent,
                          //       ),
                          //       Container(
                          //         margin: EdgeInsets.symmetric(horizontal: 20),
                          //         child: Text(
                          //           "Are you sure to close current shift !!",
                          //           style: TextStyle(
                          //               color: Colors.black,
                          //               fontWeight: FontWeight.bold),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          //   action: SnackBarAction(
                          //     label: 'Yes, Close',
                          //     textColor: Colors.red,
                          //     onPressed: () async {
                          //       String result =
                          //           await Provider.of<ShiftViewModel>(context,
                          //                   listen: false)
                          //               .editShift(
                          //                   Shift(
                          //                       id: shiftModel.shifts[0].id,
                          //                       closed: true,
                          //                       receptionist: shiftModel
                          //                           .shifts[0].receptionist),
                          //                   context);
                          //       if (result == "success") {
                          //         SharedPreferences prefs =
                          //             await SharedPreferences.getInstance();
                          //         prefs.clear();
                          //         Navigator.of(context).pushNamedAndRemoveUntil(
                          //             '/login',
                          //             (Route<dynamic> route) => false);
                          //       }
                          //     },
                          //   ),
                          // ));
                        },
                        child: Text("Close Shift"))
                  ],
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
    required this.isSelected,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedTileColor: primaryColor,
      onTap: press,
      horizontalTitleGap: 0.0,
      selected: isSelected,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
