import 'package:liness/core/utils/constant/image_assets_manger.dart';

class TeacherRecentSessionModel {
  final String image;
  final String nameTeacher;
  final String nameCource;
  TeacherRecentSessionModel({
    required this.image,
    required this.nameTeacher,
    required this.nameCource,
  });
}

final List<TeacherRecentSessionModel> teacherResentSessionModelDemo =
    List.generate(50, (index) {
  return TeacherRecentSessionModel(
    image: ImageAssetsManger.chimecalSubject,
    nameTeacher: "Mohamed Mostafa",
    nameCource: "Math",
  );
});
