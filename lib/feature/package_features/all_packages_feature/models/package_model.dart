class PackageModel {
  int id;
  String name;
  String des;
  String img;
  int price;
  bool isOpned;

  PackageModel({
    required this.id,
    required this.name,
    required this.des,
    required this.img,
    required this.price,
    required this.isOpned,
  });

  // Constructor for a single JSON object
  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      name: json['name'],
      des: json['des'],
      img: json['img'],
      price: json['price'] ?? 0,
      isOpned: json['isOpned'] ?? false,
    );
  }

  // Constructor for a list of JSON objects
  static List<PackageModel> fromListJson(List<dynamic> jsonList) {
    return jsonList.map((json) => PackageModel.fromJson(json)).toList();
  }
}
