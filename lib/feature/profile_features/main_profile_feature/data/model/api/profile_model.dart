import 'recorde_model.dart';

class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int exams;
  final int opened;
  final int total;
  final List<ProfileRecordModel> records;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.exams,
    required this.opened,
    required this.total,
    required this.records,
  });

  factory ProfileModel.fromJson(json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      exams: json['exams'],
      opened: json['opened'],
      total: json['total'],
      records: (json['records'] as List)
          .map((record) => ProfileRecordModel.fromJson(record))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'exams': exams,
      'opened': opened,
      'total': total,
      'records': records.map((record) => record.toJson()).toList(),
    };
  }
}
