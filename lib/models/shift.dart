class Shift {
  int? id;
  String? totalIncome;
  bool? closed;
  String? createdAt;
  String? updatedAt;
  Receptionist? receptionist;

  Shift(
      {this.id,
      this.totalIncome,
      this.closed,
      this.createdAt,
      this.updatedAt,
      this.receptionist});

  Shift.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalIncome = json['total_income'];
    closed = json['closed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    receptionist = json['receptionist'] != null
        ? new Receptionist.fromJson(json['receptionist'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['total_income'] = this.totalIncome;
    data['closed'] = this.closed;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.receptionist != null) {
      data['receptionist'] = receptionist!.id;
    }
    return data;
  }
}

class Receptionist {
  int? id;

  String? username;

  Receptionist({
    this.id,
    this.username,
  });

  Receptionist.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;

    data['username'] = this.username;

    return data;
  }
}
