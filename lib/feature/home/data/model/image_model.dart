import 'package:equatable/equatable.dart';

class ImageModel extends Equatable {
  final String imageUrl;

  const ImageModel({required this.imageUrl});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imageUrl: json['imageUrl'] as String,
    );
  }

  @override
  List<Object?> get props => [imageUrl];

  @override
  String toString() => 'ImageModel(imageUrl: $imageUrl)';

  
}

 