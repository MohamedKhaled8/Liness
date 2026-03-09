import '../constant/change_translate_and_theme.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/feature/subject_feature/data/model/subject_model.dart';

class GetSubjectImage {
  String getSubjectImage(SubjectModel subject) {
    // Convert all subject names to both lowercase and uppercase
    String nameArLower = subject.nameAr.toLowerCase();
    String nameEnLower = subject.nameEn.toLowerCase();
    // String nameArUpper = subject.nameAr.toUpperCase();
    // String nameEnUpper = subject.nameEn.toUpperCase();

    if (ChangeTranslateAndTheme.isArabic && nameArLower.isNotEmpty) {
      switch (nameArLower) {
        case 'الرياضيات':
          return "assets/images/png/math2.png";
        case 'الكيمياء':
          return ImageAssetsManger.chimecalSubject;
        case 'اللغة الإنجليزية':
          return ImageAssetsManger.englishSubject;
        case 'الفيزياء':
          return ImageAssetsManger.physicsSubject;
        case 'اللغة الفرنسية':
          return ImageAssetsManger.frenchSubject;
        case 'الأحياء':
          return ImageAssetsManger.bioSubject;
        case 'الجغرافيا':
          return ImageAssetsManger.geographySubject;
        case 'اللغة العربية':
          return "assets/images/jpg/arabic.jpeg";
        case 'التاريخ':
          return ImageAssetsManger.historySubject;
        case 'الفلسفة':
          return ImageAssetsManger.philosopherSubject;
        case 'علم النفس':
          return ImageAssetsManger.psychologySubject;
        case 'الجيولوجيا':
          return ImageAssetsManger.geologySubject;
      }
    } else {
      switch (nameEnLower) {
        case 'math':
          return "assets/images/png/math2.png";
        case 'chemistry':
          return ImageAssetsManger.chimecalSubject;
        case 'english':
          return ImageAssetsManger.englishSubject;
        case 'physics':
          return ImageAssetsManger.physicsSubject;
        case 'french':
          return ImageAssetsManger.frenchSubject;
        case 'biology':
          return ImageAssetsManger.bioSubject;
        case 'geography':
          return ImageAssetsManger.geographySubject;
        case 'arabic':
          return "assets/images/jpg/arabic.jpeg";
        case 'history':
          return ImageAssetsManger.historySubject;
        case 'philosophy':
          return ImageAssetsManger.philosopherSubject;
        case 'psychology':
          return ImageAssetsManger.psychologySubject;
        case 'geology':
          return ImageAssetsManger.geologySubject;
      }
    }

    // switch (nameArUpper) {
    //   case 'الرياضيات':
    //     return "assets/images/jpg/math.jpg";
    //   case 'الكيمياء':
    //     return ImageAssetsManger.chimecalSubject;
    //   case 'اللغة الإنجليزية':
    //     return ImageAssetsManger.englishSubject;
    //   case 'الفيزياء':
    //     return ImageAssetsManger.physicsSubject;
    //   case 'اللغة الفرنسية':
    //     return ImageAssetsManger.frenchSubject;
    //   case 'الأحياء':
    //     return ImageAssetsManger.bioSubject;
    //   case 'الجغرافيا':
    //     return ImageAssetsManger.geographySubject;
    //   case 'اللغة العربية':
    //     return "assets/images/jpg/arabic.jpeg";
    //   case 'التاريخ':
    //     return ImageAssetsManger.historySubject;
    //   case 'الفلسفة':
    //     return ImageAssetsManger.philosopherSubject;
    //   case 'علم النفس':
    //     return ImageAssetsManger.psychologySubject;
    //   case 'الجيولوجيا':
    //     return ImageAssetsManger.geologySubject;
    // }

    // switch (nameEnUpper) {
    //   case 'MATH':
    //     return "assets/images/jpg/math.jpg";
    //   case 'CHEMISTRY':
    //     return ImageAssetsManger.chimecalSubject;
    //   case 'ENGLISH':
    //     return ImageAssetsManger.englishSubject;
    //   case 'PHYSICS':
    //     return ImageAssetsManger.physicsSubject;
    //   case 'FRENCH':
    //     return ImageAssetsManger.frenchSubject;
    //   case 'BIOLOGY':
    //     return ImageAssetsManger.bioSubject;
    //   case 'GEOGRAPHY':
    //     return ImageAssetsManger.geographySubject;
    //   case 'ARABIC':
    //     return "assets/images/jpg/arabic.jpeg";
    //   case 'HISTORY':
    //     return ImageAssetsManger.historySubject;
    //   case 'PHILOSOPHY':
    //     return ImageAssetsManger.philosopherSubject;
    //   case 'PSYCHOLOGY':
    //     return ImageAssetsManger.psychologySubject;
    //   case 'GEOLOGY':
    //     return ImageAssetsManger.geologySubject;
    // }

    return ImageAssetsManger.languageSubject;
  }
}
