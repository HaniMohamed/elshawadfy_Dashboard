import 'package:admin/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatefulWidget {
  Function? function;

  SideMenu(this.function);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int _selectedIndex = 0;
  List<String> menuTitles = [
    "Dashboard",
    "Patients",
  ];

  List<String> menuImages = [
    "assets/icons/menu_dashbord.svg",
    "assets/icons/patients.svg",
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: menuTitles.length,
                itemBuilder: (BuildContext context, int index) {
                  return DrawerListTile(
                    title: menuTitles[index],
                    svgSrc: menuImages[index],
                    isSelected: index == _selectedIndex,
                    press: () {
                      widget.function!(index);
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  );
                }),
          )
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
