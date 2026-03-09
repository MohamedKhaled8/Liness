class ProfileRecordModel {
  final int id;
  final String name;
  final String date;
  final String img;
  final String grade;

  ProfileRecordModel({
    required this.id,
    required this.name,
    required this.date,
    required this.img,
    required this.grade,
  });

  // Factory constructor for single JSON object
  factory ProfileRecordModel.fromJson(Map<String, dynamic> json) {
    return ProfileRecordModel(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      img: json['img'],
      grade: json['grade'] ?? '',
    );
  }

  // Method to create a list of ProfileRecordModel from a list of JSON objects
  static List<ProfileRecordModel> fromListJson(List<dynamic> jsonList) {
    return jsonList.map((json) => ProfileRecordModel.fromJson(json)).toList();
  }

  // Method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'img': img,
      'grade': grade,
    };
  }
}
