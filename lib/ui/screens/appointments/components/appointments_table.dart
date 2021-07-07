import 'dart:developer' as Developer;
import 'dart:math';
import 'package:admin/models/appointment.dart';
import 'package:admin/models/user.dart';
import 'package:admin/responsive.dart';
import 'package:admin/ui/widgtes/dialogs/new_edit_appointment_dialog.dart';
import 'package:admin/ui/widgtes/dialogs/new_edit_user_dialog.dart';
import 'package:admin/view_model/appointment_view_model.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:admin/shared/constants.dart';
import 'package:provider/provider.dart';

class AppointmentsTable extends StatefulWidget {
  const AppointmentsTable({
    Key? key,
  }) : super(key: key);

  @override
  State<AppointmentsTable> createState() => _AppointmentsTableState();
}

class _AppointmentsTableState extends State<AppointmentsTable> {
  List<Appointment> appointments = [];
  bool isLoading = false;

  getAppointments() async {
    setState(() {
      isLoading = true;
    });
    appointments =
        await Provider.of<AppointmentViewModel>(context, listen: false)
            .getAppointments(context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getAppointments();
  }

  bool sort = false;
  int sortIndex = 3;

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
                : Consumer<AppointmentViewModel>(
                    builder: (context, appointmentModel, child) {
                      return DataTable2(
                        columnSpacing: defaultPadding,
                        sortAscending: sort,
                        sortColumnIndex: sortIndex,
                        dataRowHeight: 80,
                        columns: [
                          DataColumn(
                            label: Text("Patient"),
                          ),
                          DataColumn(
                            label: Text("Rays"),
                          ),
                          DataColumn(
                            label: Text("Tot. Price"),
                          ),
                          if (!Responsive.isMobile(context))
                            DataColumn(
                              label: Text("Date"),
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
                        rows: appointmentModel.appointments
                            .map((appointment) =>
                                appointmentDataRow(appointment, context))
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
    if (columnIndex == 3) {
      if (ascending) {
        appointments.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
      } else {
        appointments.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      }
    }
  }

  DataRow appointmentDataRow(Appointment appointment, context) {
    DateTime date = DateTime.parse(appointment.createdAt.toString());
    List<String>? rays = [];
    appointment.radiology!.forEach((e) {
      Developer.log(e.name.toString());
      rays.add(e.name.toString());
    });

    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors
                    .primaries[Random().nextInt(Colors.primaries.length)]
                    .shade400,
                child: Text(
                    appointment.patient!.username!.substring(0, 2).toString()),
              ),
              Container(
                width: Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.width * 0.2
                    : MediaQuery.of(context).size.width * 0.06,
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(appointment.patient!.username!),
              ),
            ],
          ),
        ),
        DataCell(Text(rays.join(", "))),
        DataCell(Text(appointment.totalPrice.toString())),
        if (!Responsive.isMobile(context))
          DataCell(Text(
            "${date.year}/${date.month}/${date.day}",
            textAlign: TextAlign.center,
          )),
        if (Responsive.isDesktop(context))
          DataCell(Text(appointment.notes.toString())),
        DataCell(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: IconButton(
                  onPressed: () {
                    showEditAppointmentDialog(context, appointment);
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
                              "Are you sure to delete appointment of (${appointment.patient!.username}) !!",
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
                          String status =
                              await Provider.of<AppointmentViewModel>(context,
                                      listen: false)
                                  .deleteAppointment(appointment, context);
                        },
                      ),
                    ));
                  },
                  icon: Icon(Icons.delete_forever)),
            ),
          ],
        )),
      ],
    );
  }

  showEditAppointmentDialog(context, Appointment? appointment) {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text('New Appointment for (${appointment!.patient!.username})'),
            content: NewEditAppointmentDialog(
              isEditing: true,
              appointment: appointment,
            ),
          );
        });
  }
}
