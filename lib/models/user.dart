class User {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? sex;
  int? age;
  BloodType? bloodType;
  BloodType? department;
  String? phone;
  String? address;
  String? notes;
  String? type;

  User(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.sex,
      this.age,
      this.bloodType,
      this.department,
      this.phone,
      this.address,
      this.notes,
      this.type});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    sex = json['sex'];
    age = json['age'];
    bloodType = json['blood_type'] != null
        ? new BloodType.fromJson(json['blood_type'])
        : null;
    department = json['department'] != null
        ? new BloodType.fromJson(json['department'])
        : null;
    phone = json['phone'];
    address = json['address'];
    notes = json['notes'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['sex'] = this.sex;
    data['age'] = this.age;
    if (this.bloodType != null) {
      data['blood_type'] = this.bloodType!.toJson();
    }
    if (this.department != null) {
      data['department'] = this.department!.toJson();
    }
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['notes'] = this.notes;
    data['type'] = this.type;
    return data;
  }
}

class BloodType {
  int? id;
  String? name;
  String? notes;
  String? createdAt;
  String? updatedAt;

  BloodType({this.id, this.name, this.notes, this.createdAt, this.updatedAt});

  BloodType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    notes = json['notes'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['notes'] = this.notes;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
