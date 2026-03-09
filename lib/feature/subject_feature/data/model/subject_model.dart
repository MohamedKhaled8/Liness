import 'package:equatable/equatable.dart';

class SubjectModel extends Equatable {
  final int id;
  final String nameAr;
  final String nameEn;
  final String img;
  final int year;

  const SubjectModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.img,
    required this.year,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] as int,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      img: json['img'] as String,
      year: json['year'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'img': img,
      'year': year,
    };
  }

  @override
  List<Object?> get props => [id, nameAr, nameEn, img, year];
}
