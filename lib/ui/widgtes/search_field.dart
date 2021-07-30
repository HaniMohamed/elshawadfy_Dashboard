import 'package:admin/controllers/MenuController.dart';
import 'package:admin/shared/constants.dart';
import 'package:admin/view_model/patient_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: TextField(
        keyboardType: TextInputType.phone,
        controller: searchController,
        maxLength: 11,
        decoration: InputDecoration(
          hintText: "Search",
          fillColor: secondaryColor,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: InkWell(
            onTap: () {
              Provider.of<MenuController>(context, listen: false)
                  .showPageIndex(0);
              Provider.of<PatientViewModel>(context, listen: false)
                  .getPatients(context, phone: searchController.text);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        searchController.text = "";
                        Provider.of<PatientViewModel>(context, listen: false)
                            .getPatients(context, phone: searchController.text);
                      });
                    },
                    icon: Icon(Icons.clear)),
                Container(
                  padding: EdgeInsets.all(defaultPadding * 2),
                  margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/Search.svg",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
