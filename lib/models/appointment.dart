import 'package:admin/models/insurance.dart';
import 'package:admin/models/radiology.dart';
import 'package:admin/models/shift.dart';
import 'package:admin/models/user.dart';

Map<String, bool?> sides = {
  "Unknown": null,
  "Right": true,
  "Left": false,
};

class Appointment {
  int? id;
  int? patientID;
  int? supervisorID;
  Shift? shift;
  int? shiftID;
  Insurance? insurance;
  int? insuranceID;
  List? radiologyIDs;
  String? notes;
  String? totalPrice;
  String? actualPrice;
  String? createdAt;
  String? updatedAt;
  User? patient;
  User? supervisor;
  bool? side; // 1 = left, 2 = right
  String? anotherSupervisor;
  List<Radiology>? radiology;

  Appointment(
      {this.id,
      this.patientID,
      this.supervisorID,
      this.shiftID,
      this.insuranceID,
      this.radiologyIDs,
      this.notes,
      this.totalPrice,
      this.actualPrice,
      this.createdAt,
      this.updatedAt,
      this.patient,
      this.supervisor,
      this.anotherSupervisor,
      this.radiology,
      this.side});

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notes = json['notes'];
    totalPrice = json['total_price'];
    actualPrice = json['actual_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    patient =
        json['patient'] != null ? new User.fromJson(json['patient']) : null;
    shift = json['shift'] != null ? new Shift.fromJson(json['shift']) : null;
    insurance = json['insurance'] != null
        ? new Insurance.fromJson(json['insurance'])
        : null;
    supervisor = json['supervisor'] != null
        ? new User.fromJson(json['supervisor'])
        : null;
    anotherSupervisor = json['another_supervisor'];
    side = json['side'];
    if (json['radiology'] != null) {
      radiology = [];
      json['radiology'].forEach((v) {
        radiology!.add(new Radiology.fromJson(v));
      });
    }
  }

  String? get sideKey {
    if (side == null) {
      return null;
    } else if (side == true) {
      return "Right";
    } else {
      return "Left";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notes'] = this.notes;
    data['total_price'] = this.totalPrice;
    data['actual_price'] = this.actualPrice;
    data['patient'] = this.patientID!;
    data['supervisor'] = this.supervisorID ?? null;
    data['shift'] = this.shiftID ?? null;
    data['insurance'] = this.insuranceID ?? null;
    data['another_supervisor'] = this.anotherSupervisor ?? null;
    data['radiology'] = this.radiologyIDs!;
    data['side'] = this.side ?? "null";

    return data;
  }
}
