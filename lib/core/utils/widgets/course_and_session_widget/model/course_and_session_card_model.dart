
class CourseAndSessionCardModel {
  final int id;
  final String image;
  final String subject;
  final String subjectAr;
  final String courseName;
  final String sessionName;
  final String subTitle;
  final String teacherName;
  final int teacherId;
  final int? courseId;
  final bool isCourseType;

  CourseAndSessionCardModel({
    required this.id,
    required this.image,
    required this.subject,
    required this.subjectAr,
    required this.courseName,
    required this.sessionName,
    required this.subTitle,
    required this.teacherName,
    required this.teacherId,
    required this.courseId,
    required this.isCourseType,
  });

  factory CourseAndSessionCardModel.fromJson(
    Map<String, dynamic> map,
    // String? teacherName,
  ) {
    return CourseAndSessionCardModel(
      id: map['id'] as int,
      image: map['img'] as String,
      subject: map['subject'] ?? '',
      subjectAr: map['subjectAr'] ?? '',
      sessionName: map['isCourse'] == false ? map['name'] ?? '' : '',
      courseName: map['name'] != null ? map['name'] ?? '' : map['course'] ?? '',
      subTitle: map['des'] as String,
      teacherName: map['teacher'], //teacherName,
      teacherId: map['teacherID'], //teacherId,
      courseId: map['courseID'],
      isCourseType: map['isCourse'],
    );
  }

  // Constructor to create a list of CourseAndSessionCardModel from a list of JSON
  static List<CourseAndSessionCardModel> fromListJson(list) {
    final List<CourseAndSessionCardModel> listModel = [];

    for (int index = 0; index < list.length; index++) {
      listModel.add(
        CourseAndSessionCardModel.fromJson(
          list[index],
        ),
      );
    }

    return listModel;
  }
}

// final List<CourseAndSessionCardModel> coursesCardDemo = List.generate(
//   50,
//   (index) => CourseAndSessionCardModel(
//     id: 1,
//     image: ImageAssetsManger.chimecalSubject,
//     subject: "math grade 3",
//     sessionName: "math grade 3",
//     courseName: "تطبيقات القيم العظمي والصغري الجزء الثاني (الجمعة)",
//     subTitle: "تطبيقات القيم العظمي والصغري الجزء الاول (الاربع)",
//     teacherName: "mr. mohamed moustafa",
//     teacherId: 1212,
//     courseId: 1212,
//     isCourseType: true,
//     subjectAr: '',
//     //year: '',
//   ),
// );

// final List<CourseAndSessionCardModel> sessionsCardDemo = List.generate(
//   7,
//   (index) => CourseAndSessionCardModel(
//     id: 1,
//     image: ImageAssetsManger.chimecalSubject,
//     sessionName: "math grade 3",
//     courseId: 1212,
//     teacherId: 1212,
//     subject: "math grade 3",
//     courseName: "نهايات الدوال الاسية و اللوغاريتمية",
//     subTitle: "نهايات الدوال الاسية و اللوغاريتمية",
//     teacherName: "mr. mohamed moustafa",
//     isCourseType: false,
//     subjectAr: '',
//     // year: '',
//   ),
// );
