import 'package:admin/controllers/MenuController.dart';
import 'package:admin/models/appointment.dart';
import 'package:admin/models/radiology.dart';
import 'package:admin/models/user.dart';
import 'package:admin/services/crud_rays_services.dart';
import 'package:admin/services/crud_users_services.dart';
import 'package:admin/view_model/appointment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class NewEditAppointmentDialog extends StatefulWidget {
  Appointment? appointment;
  User? patient;
  bool isEditing = false;

  NewEditAppointmentDialog(
      {this.appointment, this.isEditing = false, this.patient});

  @override
  _NewEditAppointmentDialogState createState() =>
      _NewEditAppointmentDialogState();
}

class _NewEditAppointmentDialogState extends State<NewEditAppointmentDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController patientNameController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  List<User> doctors = [];
  List<Radiology> rays = [];
  List<Radiology> selectedRays = [];
  List<MultiSelectItem<Radiology?>> _raysItems = [];
  double totPrice = 0.0;

  String? _errorText;
  bool isLoading = false;
  bool loadingRays = true;
  bool loadingDoctors = true;
  String dropdownValue = 'Chose Doctor';

  getRays() async {
    setState(() {
      loadingRays = true;
    });
    rays = await CRUDRaysServices().getRays(context);
    setState(() {
      _raysItems = rays
          .map((ray) => MultiSelectItem<Radiology>(ray, ray.name!))
          .toList();
      if (widget.isEditing) {
        selectedRays = widget.appointment!.radiology!;
      }
      loadingRays = false;
    });
  }

  getDoctors() async {
    setState(() {
      loadingDoctors = true;
    });
    doctors = await CRUDUsersServices().getUsers("D", context);
    setState(() {
      loadingDoctors = false;
      dropdownValue = doctors[0].username!;
    });
  }

  save() async {
    String result;
    if (selectedRays.isNotEmpty) {
      setState(() {
        _errorText = "";
        isLoading = true;
      });

      Appointment appointment = Appointment(
          patientID: widget.isEditing
              ? widget.appointment!.patient!.id
              : widget.patient!.id,
          supervisorID: widget.isEditing
              ? widget.appointment!.supervisor!.id
              : doctors
                  .lastWhere((element) => element.username == dropdownValue)
                  .id,
          totalPrice: totPrice.toString(),
          radiologyIDs: selectedRays.map((e) => e.id).toList(),
          notes: notesController.text);

      if (widget.isEditing) {
        appointment.id = widget.appointment!.id;
        result = await Provider.of<AppointmentViewModel>(context, listen: false)
            .editAppointment(appointment, context);
      } else
        result = await Provider.of<AppointmentViewModel>(context, listen: false)
            .newAppointment(appointment, context);

      setState(() {
        isLoading = false;
        if (result == "success") {
          setState(() {
            Navigator.pop(context);
            Provider.of<MenuController>(context, listen: false)
                .showPageIndex(1);
          });
        } else {
          setState(() {
            _errorText = result;
          });
        }
      });
    } else {
      setState(() {
        _errorText = "You should select at least one ray !!";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDoctors();
    getRays();
    if (widget.isEditing) {
      setState(() {
        patientNameController.text = widget.appointment!.patient!.firstName! +
            " " +
            widget.appointment!.patient!.lastName!;
        notesController.text = widget.appointment!.notes ?? "";
      });
    } else {
      setState(() {
        patientNameController.text =
            widget.patient!.firstName! + " " + widget.patient!.lastName!;
      });
    }
  }

  calcPrice() {
    totPrice = 0.0;
    selectedRays.forEach((element) {
      setState(() {
        totPrice += double.parse(element.price!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: patientNameController,
                    enabled: false,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Patient name',
                      icon: Icon(Icons.person),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Rays:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      loadingRays
                          ? CircularProgressIndicator()
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                MultiSelectBottomSheetField(
                                  initialChildSize: 0.4,
                                  listType: MultiSelectListType.CHIP,
                                  searchable: true,
                                  initialValue: selectedRays,
                                  buttonText: Text("Select Rays"),
                                  title: Text("Available Rays:"),
                                  items: _raysItems,
                                  confirmText: Text(
                                    "Confirm",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  cancelText: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onConfirm: (values) {
                                    setState(() {
                                      selectedRays = values.cast();
                                      calcPrice();
                                    });
                                  },
                                  chipDisplay: MultiSelectChipDisplay(
                                    onTap: (value) {
                                      setState(() {
                                        selectedRays.remove(value);
                                        calcPrice();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Supervisor:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      Text("Dr.  "),
                      loadingDoctors
                          ? CircularProgressIndicator()
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.white),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.black26,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                  },
                                  items: doctors
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem<String>(
                                      value: value.username,
                                      child: Text(
                                          "${value.firstName} ${value.lastName}"),
                                    );
                                  }).toList(),
                                ),
                              ],
                            )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: notesController,
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                    onFieldSubmitted: (value) {
                      save();
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Notes',
                      icon: Icon(Icons.notes),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)),
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Text("Tot. Price: $totPrice")),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: _errorText == null
                      ? Container()
                      : Text(
                          "$_errorText",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  alignment: Alignment.center,
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              child: Text("Save"),
                              style: ElevatedButton.styleFrom(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 40)),
                              onPressed: () {
                                save();
                              },
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10)),
                            ElevatedButton(
                              child: Text("Close"),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueGrey,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 40)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                )
              ],
            )),
      ),
    );
  }
}
