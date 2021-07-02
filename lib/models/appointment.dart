import 'package:admin/models/radiology.dart';
import 'package:admin/models/user.dart';

class Appointment {
  int? id;
  String? notes;
  String? totalPrice;
  String? createdAt;
  String? updatedAt;
  User? patient;
  User? supervisor;
  List<Radiology>? radiology;

  Appointment(
      {this.id,
      this.notes,
      this.totalPrice,
      this.createdAt,
      this.updatedAt,
      this.patient,
      this.supervisor,
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.patient != null) {
      data['patient'] = this.patient!.toJson();
    }
    if (this.supervisor != null) {
      data['supervisor'] = this.supervisor!.toJson();
    }
    if (this.radiology != null) {
      data['radiology'] = this.radiology!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
