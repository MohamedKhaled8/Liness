import 'package:equatable/equatable.dart';

class SessionResentModel extends Equatable {
  final int id;
  final String name;
  final String img;
  final String des;
  final String course;

  const SessionResentModel({
    required this.id,
    required this.name,
    required this.img,
    required this.des,
    required this.course,
  });

  factory SessionResentModel.fromJson(Map<String, dynamic> json) {
    return SessionResentModel(
      id: json['id'] as int,
      name: json['name'] as String,
      img: json['img'] as String,
      des: json['des'] as String,
      course: json['course'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'img': img,
      'des': des,
      'course': course,
    };
  }

  @override
  List<Object?> get props => [id, name, img, des, course];
}
