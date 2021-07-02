class Radiology {
  int? id;
  String? name;
  String? price;
  String? medicalInsuranceDiscount;
  String? notes;
  String? createdAt;
  String? updatedAt;
  int? doctor;

  Radiology(
      {this.id,
      this.name,
      this.price,
      this.medicalInsuranceDiscount,
      this.notes,
      this.createdAt,
      this.updatedAt,
      this.doctor});

  Radiology.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    medicalInsuranceDiscount = json['medical_insurance_discount'];
    notes = json['notes'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    doctor = json['doctor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['medical_insurance_discount'] = this.medicalInsuranceDiscount;
    data['notes'] = this.notes;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['doctor'] = this.doctor;
    return data;
  }
}
