import 'dart:developer' as Developer;
import 'dart:math';

import 'package:admin/models/appointment.dart';
import 'package:admin/responsive.dart';
import 'package:admin/shared/constants.dart';
import 'package:admin/ui/widgtes/dialogs/new_edit_appointment_dialog.dart';
import 'package:admin/view_model/appointment_view_model.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
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
                        // sortColumnIndex: sortIndex,
                        dataRowHeight: Responsive.isMobile(context) ? 120 : 80,
                        columns: [
                          DataColumn(
                            label: Text("Patient"),
                          ),
                          DataColumn(
                            label: Text("Rays"),
                          ),
                          if (!Responsive.isMobile(context))
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
                child: Text(appointment.patient!.firstName!
                        .substring(0, 1)
                        .toString() +
                    appointment.patient!.lastName!.substring(0, 1).toString()),
              ),
              Container(
                width: Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.width * 0.2
                    : MediaQuery.of(context).size.width * 0.06,
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                    "${appointment.patient!.firstName!} ${appointment.patient!.lastName!}"),
              ),
            ],
          ),
        ),
        DataCell(Text(rays.join(", "))),
        if (!Responsive.isMobile(context))
          DataCell(Text(appointment.totalPrice.toString())),
        if (!Responsive.isMobile(context))
          DataCell(Text(
            "${date.year}/${date.month}/${date.day}",
            textAlign: TextAlign.center,
          )),
        if (Responsive.isDesktop(context))
          DataCell(Text(appointment.notes.toString())),
        DataCell(Responsive.isMobile(context)
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: actionButtons(appointment),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: actionButtons(appointment),
              )),
      ],
    );
  }

  List<Widget> actionButtons(appointment) {
    return [
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
                        "Are you sure to delete appointment of (${appointment.patient!.firstName} ${appointment.patient!.lastName}) !!",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                action: SnackBarAction(
                  label: 'Yes, Delete',
                  textColor: Colors.red,
                  onPressed: () async {
                    String status = await Provider.of<AppointmentViewModel>(
                            context,
                            listen: false)
                        .deleteAppointment(appointment, context);
                  },
                ),
              ));
            },
            icon: Icon(Icons.delete_forever)),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: IconButton(
            onPressed: () {
              printing(appointment);
            },
            icon: Icon(
              Icons.print,
              color: Colors.blue,
            )),
      ),
    ];
  }

  printing(Appointment appointment) async {
    var data = await rootBundle.load("fonts/IRANSansWeb(FaNum)_Bold.ttf");

    Developer.log("Heellooooooo Dr. ${appointment.supervisor!.firstName}");
    DateTime date = DateTime.parse(appointment.createdAt.toString());
    List<String>? rays = [];
    appointment.radiology!.forEach((e) {
      Developer.log(e.name.toString());
      rays.add(e.name.toString());
    });
    final doc = pw.Document();

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a6,
        orientation: pw.PageOrientation.landscape,
        build: (pw.Context context) {
          return pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
            pw.Container(
                margin: pw.EdgeInsets.all(5),
                child: pw.Table(
                    border: pw.TableBorder.all(
                        color: PdfColor.fromHex("#000000"),
                        style: pw.BorderStyle.solid,
                        width: 2),
                    children: [
                      pw.TableRow(children: [
                        pw.Column(children: [
                          pw.Text('Name:',
                              style: pw.TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: pw.FontWeight.bold))
                        ]),
                        pw.Column(children: [
                          pw.Container(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Text(
                                  '${appointment.patient!.firstName} ${appointment.patient!.lastName}',
                                  textAlign: pw.TextAlign.center,
                                  textDirection: pw.TextDirection.rtl,
                                  style: pw.TextStyle(
                                      font: pw.Font.ttf(data), fontSize: 16.0)))
                        ]),
                      ]),
                      pw.TableRow(children: [
                        pw.Column(children: [
                          pw.Text('REF.PRO:',
                              style: pw.TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: pw.FontWeight.bold))
                        ]),
                        pw.Column(children: [
                          pw.Container(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Text(
                                  'د. ${appointment.supervisor!.firstName} ${appointment.supervisor!.lastName}',
                                  textAlign: pw.TextAlign.center,
                                  textDirection: pw.TextDirection.rtl,
                                  style: pw.TextStyle(
                                    font: pw.Font.ttf(data),
                                    fontSize: 16.0,
                                  )))
                        ]),
                      ]),
                      pw.TableRow(children: [
                        pw.Column(children: [
                          pw.Text('Date:',
                              style: pw.TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: pw.FontWeight.bold))
                        ]),
                        pw.Column(children: [
                          pw.Container(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Text(
                                  "${date.year}/${date.month}/${date.day}",
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(fontSize: 16.0)))
                        ]),
                      ]),
                      pw.TableRow(children: [
                        pw.Column(children: [
                          pw.Text('Scan:',
                              style: pw.TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: pw.FontWeight.bold))
                        ]),
                        pw.Column(children: [
                          pw.Container(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Text(rays.join(", "),
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(fontSize: 16.0)))
                        ]),
                      ]),
                      pw.TableRow(children: [
                        pw.Column(children: [
                          pw.Text('Age:',
                              style: pw.TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: pw.FontWeight.bold))
                        ]),
                        pw.Column(children: [
                          pw.Container(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Text("${appointment.patient!.age}",
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(fontSize: 16.0)))
                        ]),
                      ]),
                    ]))
          ]);
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  showEditAppointmentDialog(context, Appointment? appointment) {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                'New Appointment for (${appointment!.patient!.firstName} ${appointment.patient!.lastName})'),
            content: NewEditAppointmentDialog(
              isEditing: true,
              appointment: appointment,
            ),
          );
        });
  }
}
