import 'package:equatable/equatable.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';

class TeacherCardModel extends Equatable {
  final int id;
  final String image;
  final String nameTeacher;
  final String job;
  final String description;
  final String? facebookLink;
  final String? youtubeLink;
  final String? tiktokLink;
  final String? instagramLink;

  const TeacherCardModel({
    required this.id,
    required this.image,
    required this.nameTeacher,
    required this.job,
    required this.description,
    this.facebookLink,
    this.youtubeLink,
    this.tiktokLink,
    this.instagramLink,
  });

  factory TeacherCardModel.fromJson(Map<String, dynamic> map) {
    return TeacherCardModel(
      id: map['id'] as int,
      image: map['img'] as String,
      nameTeacher: map['name'] as String,
      job: map['job'] as String,
      description: map['des'] ?? '',
      facebookLink: map['facebook'],
      youtubeLink: map['youtube'],
      tiktokLink: map['tiktok'],
      instagramLink: map['instagram'],
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'img': image,
      'name': nameTeacher,
      'job': job,
      'des': description,
      'facebook': facebookLink,
      'youtube': youtubeLink,
      'tiktok': tiktokLink,
      'instagram': instagramLink,
    };
  }

  // Constructor to create a list of TeacherCardModel from a list of JSON
  static List<TeacherCardModel> fromListJson(list) {
    final List<TeacherCardModel> listModel = [];

    for (int index = 0; index < list.length; index++) {
      listModel.add(
        TeacherCardModel.fromJson(list[index]),
      );
    }

    return listModel;
  }

  @override
  List<Object?> get props => [
        id,
        image,
        nameTeacher,
        job,
        facebookLink,
        youtubeLink,
        tiktokLink,
        instagramLink,
      ];
}

final List<TeacherCardModel> teachersCardModelDemo = List.generate(
  10,
  (index) {
    return const TeacherCardModel(
      id: 1,
        image: ImageAssetsManger.chimecalSubject,

      nameTeacher: "Mohamed Mostafa",
      job: "Math",
      description: 'وصف',
    );
  },
);
