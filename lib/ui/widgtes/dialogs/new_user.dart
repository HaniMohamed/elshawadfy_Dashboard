import 'package:admin/models/user.dart';
import 'package:admin/services/new_user_service.dart';
import 'package:admin/ui/widgtes/header.dart';
import 'package:admin/view_model/patient_view_nodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NewUserDialog extends StatefulWidget {
  const NewUserDialog({Key? key, String? type}) : super(key: key);

  @override
  _NewUserDialogState createState() => _NewUserDialogState();
}

class _NewUserDialogState extends State<NewUserDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  String? _errorText;
  String _radioValue = 'm';
  String? choice;
  bool isLoading = false;

  save() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      User user = User(
          type: "P",
          username: usernameController.text,
          firstName: firstnameController.text,
          lastName: lastnameController.text,
          sex: choice,
          age: int.parse(ageController.text),
          phone: phoneController.text,
          address: addressController.text,
          notes: notesController.text);

      String result =
          await Provider.of<PatientViewModel>(context, listen: false)
              .newPatient(user, context);
      setState(() {
        isLoading = false;
        if (result == "success") {
          Navigator.pop(context);
        } else {
          _errorText = result;
        }
      });
    }
  }

  void radioButtonChanges(String? value) {
    setState(() {
      _radioValue = value!;
      switch (value) {
        case 'm':
          choice = value;
          break;
        case 'f':
          choice = value;
          break;

        default:
          choice = null;
      }
      debugPrint(choice); //Debug the choice in console
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: usernameController,
                    keyboardType: TextInputType.name,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[A-Za-z]")),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cannot be empty';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      save();
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Username',
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
                  child: TextFormField(
                    controller: firstnameController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cannot be empty';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      save();
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      icon: Icon(Icons.title),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: lastnameController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cannot be empty';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      save();
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      icon: Icon(Icons.title),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("type:"),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Radio(
                        value: 'm',
                        groupValue: _radioValue,
                        onChanged: radioButtonChanges,
                      ),
                      Text(
                        "male",
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      Radio(
                        value: 'f',
                        groupValue: _radioValue,
                        onChanged: radioButtonChanges,
                      ),
                      Text(
                        "female",
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cannot be empty';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      save();
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Age',
                      icon: Icon(Icons.calendar_today),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cannot be empty';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      save();
                    },
                    style: TextStyle(color: Colors.black),
                    maxLength: 11,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      icon: Icon(Icons.phone),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: addressController,
                    keyboardType: TextInputType.streetAddress,
                    onFieldSubmitted: (value) {
                      save();
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Address',
                      icon: Icon(Icons.location_city),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)),
                    ),
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
                    style: TextStyle(color: Colors.black),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        child: Text("Add"),
                        onPressed: () {
                          save();
                        },
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      ElevatedButton(
                        child: Text("Close"),
                        style:
                            ElevatedButton.styleFrom(primary: Colors.blueGrey),
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
