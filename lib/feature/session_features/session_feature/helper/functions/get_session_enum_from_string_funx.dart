import '../enums/session_types.dart';

SessionTypesEnum getSessionEnumFromString({required String type}) {
  if (SessionTypesEnum.video.toString() == type) {
    return SessionTypesEnum.video;
  } else if (SessionTypesEnum.exam.toString() == type) {
    return SessionTypesEnum.exam;
  } else {
    return SessionTypesEnum.examAndVideo;
  }
}
