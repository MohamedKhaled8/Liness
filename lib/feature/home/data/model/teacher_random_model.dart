import 'package:equatable/equatable.dart';

class TeacherRandomModel extends Equatable {
  final int id;
  final String name;
  final String job;
  final String facebook;
  final String youtube;
  final String instagram;
  final String tiktok;
  final String img;

  const TeacherRandomModel({
    required this.id,
    required this.name,
    required this.job,
    required this.facebook,
    required this.youtube,
    required this.instagram,
    required this.tiktok,
    required this.img,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        job,
        facebook,
        youtube,
        instagram,
        tiktok,
        img,
      ];

  // Factory method to create a Teacher instance from JSON
  factory TeacherRandomModel.fromJson(Map<String, dynamic> json) {
    return TeacherRandomModel(
      id: json['id'] as int,
      name: json['name'] as String,
      job: json['job'] as String,
      facebook: json['facebook'] as String,
      youtube: json['youtube'] as String,
      instagram: json['instagram'] as String,
      tiktok: json['tiktok'] as String,
      img: json['img'] as String,
    );
  }

  // Method to convert a Teacher instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'job': job,
      'facebook': facebook,
      'youtube': youtube,
      'instagram': instagram,
      'tiktok': tiktok,
      'img': img,
    };
  }
}
