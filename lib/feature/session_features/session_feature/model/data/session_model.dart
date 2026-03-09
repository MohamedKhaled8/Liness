import 'package:equatable/equatable.dart';
import '../../helper/enums/session_types.dart';
import 'package:liness/core/utils/widgets/custom_teacher_card_widget/model/teacher_card_model.dart';

class SessionModel extends Equatable {
  int id;
  final String sessionImage;
  String sessionName;
  final String payLink;
  final int sessionPrice;
  int sessionTimes;
  final SessionTypesEnum sessionType;
  final bool isExamDone;
  bool isClosed;
  final TeacherCardModel teacherModel;

  SessionModel({
    required this.id,
    required this.sessionImage,
    required this.sessionName,
    required this.payLink,
    required this.isExamDone,
    required this.sessionPrice,
    required this.sessionTimes,
    required this.sessionType,
    required this.isClosed,
    required this.teacherModel,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      //// I WILL SET THIS LATER WHEN USER CALL REQUEST TO GET SESSION DATA
      id: 0,
      sessionImage: json['img'] ?? '',
      isExamDone: json['result'] ?? false,
      sessionName: json['name'] ?? '',
      payLink: json['payLink'] ?? '',
      sessionPrice: json['price'] as int,
      sessionTimes: json['times'] ?? 0,
      sessionType: json['type'] == 'video'
          ? SessionTypesEnum.video
          : json['type'] == 'exam'
              ? SessionTypesEnum.exam
              : SessionTypesEnum.examAndVideo,
      isClosed: json['state'] == "closed",
      teacherModel: TeacherCardModel.fromJson(
        json['teacher'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': '',
      'image': sessionImage,
      'result': isExamDone,
      'name': sessionName,
      'payLink': payLink,
      'price': sessionPrice,
      'times': sessionTimes,
      'type': sessionType.toString(),
      'state': isClosed,
      'teacher': teacherModel.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        sessionImage,
        sessionName,
        sessionPrice,
        sessionTimes,
        sessionType,
        isClosed,
        teacherModel,
      ];
}

// final SessionModel sessionModelDemo = SessionModel(
//   sessionImage: ImageAssetsManger.cover,
//   id: 0,
//   sessionName: "تطبيقات القيم العظمي والصغري الجزء الثاني (الجمعة)",
//   sessionPrice: 50,
//   isExamDone: false,
//   sessionTimes: 12,
//   payLink: '',
//   sessionType: getSessionEnumFromString(type: "SessionTypesEnum.video"),
//   isClosed: true,
//   teacherModel: const TeacherCardModel(
//     id: 1,
//     image: ImageAssetsManger.mrmohamedmostafa,
//     nameTeacher: "Mr.Mohamed Mustafa",
//     job: "Math",
//     description: "DESCRIPTION",
//     facebookLink: "ffsdfsd",
//     youtubeLink: "dsfsdfsd",
//     tiktokLink: "dsfsdf",
//   ),
// );