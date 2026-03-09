import 'package:liness/core/utils/helper/sub_text.dart';
import 'package:liness/core/utils/constant/global_data.dart';

class VideoModel {
  String videoLink;
  final String sessionName;
  final String sessionImgae;
  final String fileLink;
  final String fileTitle;
  final String iv;

  VideoModel({
    required this.videoLink,
    required this.sessionName,
    required this.sessionImgae,
    required this.fileLink,
    required this.fileTitle,
    required this.iv,
  });

  factory VideoModel.fromJson(json) {
    return VideoModel(
      sessionName: json['name'] ?? '',
      videoLink: SubTextUtils.textD(
        subText: json['video'] ?? '',
        subTexterK: subk, //.substring(15, 87),
        // kIv: json['iv'],
      ),
      sessionImgae: json['img'] ?? '',
      fileLink: json['link'] ?? '',
      fileTitle: json['linkText'] ?? '',
      iv: json['iv'] ?? '',
    );
  }
}
