import 'package:admin/responsive.dart';
import 'package:admin/shared/constants.dart';
import 'package:admin/ui/widgtes/dialogs/new_user.dart';
import 'package:admin/ui/widgtes/header.dart';
import 'package:flutter/material.dart';

import 'components/patients_table.dart';
import 'components/storage_details.dart';

class PatientsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              title: "Patients",
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding * 1.5,
                              vertical: defaultPadding /
                                  (Responsive.isMobile(context) ? 2 : 1),
                            ),
                          ),
                          onPressed: () {
                            showAddUserDialog(context);
                          },
                          icon: Icon(Icons.add),
                          label: Text("Add New"),
                        ),
                      ),
                      SizedBox(height: defaultPadding),
                      PatientsTable(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) StarageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we dont want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: StarageDetails(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  showAddUserDialog(context) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add new Patient'),
            content: NewUserDialog(),
          );
        });
  }
}
