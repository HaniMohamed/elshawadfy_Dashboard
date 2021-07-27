import 'package:admin/models/radiology.dart';
import 'package:admin/models/user.dart';

class Appointment {
  int? id;
  int? patientID;
  int? supervisorID;
  List? radiologyIDs;
  String? notes;
  String? totalPrice;
  String? createdAt;
  String? updatedAt;
  User? patient;
  User? supervisor;
  String? anotherSupervisor;
  List<Radiology>? radiology;

  Appointment(
      {this.id,
      this.patientID,
      this.supervisorID,
      this.radiologyIDs,
      this.notes,
      this.totalPrice,
      this.createdAt,
      this.updatedAt,
      this.patient,
      this.supervisor,
      this.anotherSupervisor,
      this.radiology});

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notes = json['notes'];
    totalPrice = json['total_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    patient =
        json['patient'] != null ? new User.fromJson(json['patient']) : null;
    supervisor = json['supervisor'] != null
        ? new User.fromJson(json['supervisor'])
        : null;
    anotherSupervisor = json['another_supervisor'];

    if (json['radiology'] != null) {
      radiology = [];
      json['radiology'].forEach((v) {
        radiology!.add(new Radiology.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notes'] = this.notes;
    data['total_price'] = this.totalPrice;

    data['patient'] = this.patientID!;
    data['supervisor'] = this.supervisorID ?? null;
    data['another_supervisor'] = this.anotherSupervisor ?? null;
    data['radiology'] = this.radiologyIDs!;

    return data;
  }
}
