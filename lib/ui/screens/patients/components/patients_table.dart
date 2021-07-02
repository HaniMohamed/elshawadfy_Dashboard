import 'dart:math';
import 'package:admin/models/user.dart';
import 'package:admin/responsive.dart';
import 'package:admin/services/crud_users_services.dart';
import 'package:admin/ui/widgtes/dialogs/new_edit_user_dialog.dart';
import 'package:admin/view_model/patient_view_model.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:admin/shared/constants.dart';
import 'package:provider/provider.dart';

class PatientsTable extends StatefulWidget {
  const PatientsTable({
    Key? key,
  }) : super(key: key);

  @override
  State<PatientsTable> createState() => _PatientsTableState();
}

class _PatientsTableState extends State<PatientsTable> {
  List<User> patients = [];
  bool isLoading = false;

  getPatients() async {
    setState(() {
      isLoading = true;
    });
    patients = await Provider.of<PatientViewModel>(context, listen: false)
        .getPatients(context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getPatients();
  }

  bool sort = false;
  int sortIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Consumer<PatientViewModel>(
                    builder: (context, patientModel, child) {
                      return DataTable2(
                        columnSpacing: defaultPadding,
                        sortAscending: sort,
                        sortColumnIndex: sortIndex,
                        dataRowHeight: 80,
                        columns: [
                          DataColumn(
                            label: Text("Name"),
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                sort = !sort;
                                sortIndex = columnIndex;
                              });
                              onSortColumn(columnIndex, ascending);
                            },
                          ),
                          if (Responsive.isDesktop(context))
                            DataColumn(
                              label: Text("Sex"),
                            ),
                          DataColumn(
                            label: Text("Phone"),
                          ),
                          if (!Responsive.isMobile(context))
                            DataColumn(
                              label: Text("Date"),
                            ),
                          if (Responsive.isDesktop(context))
                            DataColumn(
                              label: Text("Notes"),
                            ),
                          DataColumn(
                            label: Row(
                              children: [
                                Text("Actions"),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                        ],
                        rows: patientModel.users
                            .map((user) => patientDataRow(user, context))
                            .toList(),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  onSortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        patients.sort((a, b) => a.username!.compareTo(b.username!));
      } else {
        patients.sort((a, b) => b.username!.compareTo(a.username!));
      }
    }
    if (columnIndex == 3) {
      if (ascending) {
        patients.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
      } else {
        patients.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      }
    }
  }

  DataRow patientDataRow(User user, context) {
    DateTime date = DateTime.parse(user.createdAt.toString());
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors
                    .primaries[Random().nextInt(Colors.primaries.length)]
                    .shade400,
                child: Text(user.username!.substring(0, 2).toString()),
              ),
              Container(
                width: Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.width * 0.2
                    : MediaQuery.of(context).size.width * 0.06,
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(user.username!),
              ),
            ],
          ),
        ),
        if (Responsive.isDesktop(context)) DataCell(Text(user.sex.toString())),
        DataCell(Text(user.phone.toString())),
        if (!Responsive.isMobile(context))
          DataCell(Text(
            "${date.year}/${date.month}/${date.day}",
            textAlign: TextAlign.center,
          )),
        if (Responsive.isDesktop(context))
          DataCell(Text(user.notes.toString())),
        DataCell(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: IconButton(
                  onPressed: () {
                    showEditUserDialog(context, user);
                  },
                  icon: Icon(Icons.edit)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.redAccent,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Are you sure to delete patient (${user.username}) !!",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      action: SnackBarAction(
                        label: 'Yes, Delete',
                        textColor: Colors.red,
                        onPressed: () async {
                          String status = await Provider.of<PatientViewModel>(
                                  context,
                                  listen: false)
                              .deletePatient(user, context);
                        },
                      ),
                    ));
                  },
                  icon: Icon(Icons.delete_forever)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.perm_contact_calendar_outlined,
                    color: Colors.blue,
                  )),
            ),
          ],
        )),
      ],
    );
  }

  showEditUserDialog(context, User? user) {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Patient (${user!.username})'),
            content: NewEditUserDialog(
              type: "P",
              isEditing: true,
              user: user,
            ),
          );
        });
  }
}
