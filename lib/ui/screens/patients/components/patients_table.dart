import 'dart:math';

import 'package:admin/models/RecentFile.dart';
import 'package:admin/models/user.dart';
import 'package:admin/services/get_users_service.dart';
import 'package:admin/view_model/patient_view_nodel.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
                        columns: [
                          DataColumn(
                            label: Text("Name"),
                          ),
                          DataColumn(
                            label: Text("Sex"),
                          ),
                          DataColumn(
                            label: Text("Phone"),
                          ),
                          DataColumn(
                            label: Text("Date"),
                          ),
                          DataColumn(
                            label: Text("notes"),
                          ),
                        ],
                        // rows: List.generate(
                        //   patientModel.users.length,
                        //   (index) => patientDataRow(patients[index]),
                        rows: patientModel.users
                            .map((user) => patientDataRow(user))
                            .toList(),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

DataRow patientDataRow(User user) {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(user.username!),
            ),
          ],
        ),
      ),
      DataCell(Text(user.sex.toString())),
      DataCell(Text(user.phone.toString())),
      DataCell(Text(
        "${date.hour}:${date.minute}\n${date.year}/${date.month}/${date.day}",
        textAlign: TextAlign.center,
      )),
      DataCell(Text(user.notes.toString())),
    ],
  );
}
