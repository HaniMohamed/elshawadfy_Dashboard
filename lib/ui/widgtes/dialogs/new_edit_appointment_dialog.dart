import 'package:admin/controllers/MenuController.dart';
import 'package:admin/models/appointment.dart';
import 'package:admin/models/insurance.dart';
import 'package:admin/models/radiology.dart';
import 'package:admin/models/shift.dart';
import 'package:admin/models/user.dart';
import 'package:admin/services/crud_insurance_services.dart';
import 'package:admin/services/crud_rays_services.dart';
import 'package:admin/services/crud_users_services.dart';
import 'package:admin/view_model/appointment_view_model.dart';
import 'package:admin/view_model/shift_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';

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
  TextEditingController actualPriceController = TextEditingController();
  TextEditingController anotherSupervisorNameController =
      TextEditingController();
  TextEditingController notesController = TextEditingController();
  List<User> doctors = [];
  List<Insurance> insurances = [];
  List<Radiology> rays = [];
  List<Radiology> selectedRays = [];
  List<MultiSelectItem<Radiology?>> _raysItems = [];
  double totPrice = 0.0;
  bool? side;

  String sidesDropdownValue = "Unknown";
  String? _errorText;
  bool isLoading = false;
  bool loadingRays = true;
  bool loadingDoctors = true;
  bool loadingInsurances = true;
  String doctorDropdownValue = 'Chose Doctor';
  String insuranceDropdownValue = 'Chose Insurance';
  bool isAnotherSupervisor = false;

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

  getInsurances() async {
    setState(() {
      loadingInsurances = true;
    });
    insurances = await CRUDInsurancesServices().getInsurances(context);
    insurances.insert(0, Insurance(id: null, name: "No Medical Insurance"));
    setState(() {
      loadingInsurances = false;
      if (widget.isEditing && widget.appointment!.insurance != null) {
        insuranceDropdownValue = insurances[insurances.indexWhere((element) =>
                element.name == widget.appointment!.insurance!.name)]
            .name!;
      } else
        insuranceDropdownValue = insurances[0].name!;
    });
  }

  getDoctors() async {
    setState(() {
      loadingDoctors = true;
    });
    doctors = await CRUDUsersServices().getUsers("D", context);
    setState(() {
      loadingDoctors = false;
      if (widget.isEditing && widget.appointment!.supervisor != null) {
        isAnotherSupervisor = false;
        anotherSupervisorNameController.text = "";
        doctorDropdownValue = doctors[doctors.indexWhere((element) =>
                element.username == widget.appointment!.supervisor!.username)]
            .username!;
      } else
        doctorDropdownValue = doctors[0].username!;
    });
  }

  save() async {
    List<Shift> shifts =
        await Provider.of<ShiftViewModel>(context, listen: false)
            .getShifts(context);
    int? shiftID = shifts[0].id;
    String result;
    if (selectedRays.isNotEmpty) {
      if (!isAnotherSupervisor ||
          anotherSupervisorNameController.text.isNotEmpty) {
        setState(() {
          _errorText = "";
          isLoading = true;
        });

        Appointment appointment = Appointment(
            patientID: widget.isEditing
                ? widget.appointment!.patient!.id
                : widget.patient!.id,
            insuranceID: insuranceDropdownValue == "No medical insurance"
                ? null
                : insurances
                    .lastWhere(
                        (element) => element.name == insuranceDropdownValue)
                    .id,
            supervisorID: isAnotherSupervisor
                ? null
                : doctors
                    .lastWhere(
                        (element) => element.username == doctorDropdownValue)
                    .id,
            anotherSupervisor: !isAnotherSupervisor
                ? null
                : anotherSupervisorNameController.text,
            totalPrice: totPrice.toString(),
            actualPrice: actualPriceController.text,
            radiologyIDs: selectedRays.map((e) => e.id).toList(),
            notes: notesController.text,
            shiftID: shiftID,
            side: sides[sidesDropdownValue]);

        if (widget.isEditing) {
          appointment.id = widget.appointment!.id;
          result =
              await Provider.of<AppointmentViewModel>(context, listen: false)
                  .editAppointment(appointment, context);
        } else
          result =
              await Provider.of<AppointmentViewModel>(context, listen: false)
                  .newAppointment(appointment, context);

        if (result == "success") {
          await Provider.of<ShiftViewModel>(context, listen: false).editShift(
              Shift(
                  id: shifts[0].id,
                  totalIncome: (double.parse(shifts[0].totalIncome!) +
                          double.parse(actualPriceController.text))
                      .toString(),
                  receptionist: shifts[0].receptionist),
              context);
          setState(() {
            isLoading = false;
            Navigator.pop(context);
            Provider.of<MenuController>(context, listen: false)
                .showPageIndex(1);
          });
        } else {
          setState(() {
            isLoading = false;
            _errorText = result;
          });
        }
      } else {
        setState(() {
          _errorText = "You should insert supervisor name !!";
        });
      }
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
    getInsurances();
    setState(() {
      actualPriceController.text = totPrice.toString();
    });
    if (widget.isEditing) {
      setState(() {
        patientNameController.text = widget.appointment!.patient!.firstName! +
            " " +
            widget.appointment!.patient!.lastName!;
        notesController.text = widget.appointment!.notes ?? "";
        if (widget.appointment!.supervisor == null) {
          isAnotherSupervisor = true;
          anotherSupervisorNameController.text =
              widget.appointment!.anotherSupervisor!;
        }
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
        actualPriceController.text = totPrice.toString();
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
                Divider(),
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
                      Spacer(),
                      Text(
                        "Side:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      DropdownButton<String>(
                        value: sidesDropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        underline: Container(
                          height: 2,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            sidesDropdownValue = newValue!;
                          });
                        },
                        items: sides.keys
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                    ],
                  ),
                ),
                Divider(),
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
                          : AbsorbPointer(
                              absorbing: isAnotherSupervisor,
                              child: Opacity(
                                opacity: isAnotherSupervisor ? 0.3 : 1.0,
                                child: SizedBox(
                                  height: 80,
                                  width: 150,
                                  child: SearchChoices.single(
                                    value: doctorDropdownValue,

                                    hint: "Select Doctor",
                                    searchHint: "Search..",
                                    icon: const Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    // elevation: 16,
                                    style: const TextStyle(color: Colors.white),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.black26,
                                    ),
                                    searchFn: (String keyword,
                                        List<DropdownMenuItem<String>> items) {
                                      List<int> ret = [];
                                      List<Text> texts =
                                          items.map<Text>((item) {
                                        return item.child as Text;
                                      }).toList();
                                      for (int i = 0; i < texts.length; i++) {
                                        if (texts[i]
                                            .data!
                                            .toLowerCase()
                                            .contains(keyword.toLowerCase())) {
                                          ret.add(i);
                                        }
                                      }

                                      if (keyword.isEmpty) {
                                        ret =
                                            Iterable<int>.generate(items.length)
                                                .toList();
                                      }
                                      return (ret);
                                    },
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        doctorDropdownValue = newValue!;
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
                                ),
                              ),
                            ),
                      Spacer(),
                      Checkbox(
                        value: isAnotherSupervisor,
                        onChanged: (bool? value) {
                          setState(() {
                            isAnotherSupervisor = value!;
                          });
                        },
                      ),
                      AbsorbPointer(
                        absorbing: !isAnotherSupervisor,
                        child: Opacity(
                          opacity: !isAnotherSupervisor ? 0.3 : 1.0,
                          child: Row(
                            children: [
                              Text("Another Dr:"),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5)),
                              SizedBox(
                                width: 200,
                                child: TextFormField(
                                  controller: anotherSupervisorNameController,
                                  enabled: true,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Supervisor name',
                                    hintText: 'Insert name of doctor',
                                    border: new OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.grey)),
                                    enabledBorder: new OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.blue)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Medical Insurance:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      loadingInsurances
                          ? CircularProgressIndicator()
                          : DropdownButton<String>(
                              value: insuranceDropdownValue,
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
                                  insuranceDropdownValue = newValue!;
                                });
                              },
                              items: insurances
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value.name,
                                  child: Text("${value.name}"),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
                Divider(),
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
                Divider(),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Tot. Price:"),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: SizedBox(
                            width: 80,
                            child: Text("$totPrice"),
                          ),
                        )
                      ],
                    )),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Actual Price: "),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: SizedBox(
                            width: 80,
                            child: TextFormField(
                              controller: actualPriceController,
                              keyboardType: TextInputType.number,
                              maxLength: 8,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                              ],
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.grey)),
                                enabledBorder: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.blue)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
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
