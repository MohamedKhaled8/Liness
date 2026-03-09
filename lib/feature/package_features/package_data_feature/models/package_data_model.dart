import 'package:liness/core/utils/widgets/custom_teacher_card_widget/model/teacher_card_model.dart';
import 'package:liness/core/utils/widgets/course_and_session_widget/model/course_and_session_card_model.dart';

class PackageDataModel {
  String? payLink;
  bool notBuy;
  String name;
  String img;
  String des;
  int price;
  List<TeacherCardModel> teachersList;
  List<CourseAndSessionCardModel> sessionsList;

  PackageDataModel({
    this.payLink,
    required this.notBuy,
    required this.name,
    required this.img,
    required this.des,
    required this.price,
    required this.teachersList,
    required this.sessionsList,
  });

  factory PackageDataModel.fromJson(Map<String, dynamic> json) {
    return PackageDataModel(
      payLink: json['payLink'],
      notBuy: json['open'] ?? true,
      name: json['name'],
      img: json['img'],
      des: json['des'],
      price: json['price'],
      teachersList: TeacherCardModel.fromListJson(json['teachers']),
      sessionsList: CourseAndSessionCardModel.fromListJson(json['sessions']),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'payLink': payLink,
  //     'open': open,
  //     'name': name,
  //     'img': img,
  //     'des': des,
  //     'price': price,
  //     'teachers': teachersList.map((teacher) => teacher.toJson()).toList(),
  //     'sessions': sessionsList.map((session) => session.toJson()).toList(),
  //   };
  // }
}
