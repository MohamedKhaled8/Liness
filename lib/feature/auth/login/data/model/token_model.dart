class TokenModel {
  final String token;
  final String time;

  TokenModel({
    required this.token,
    required this.time,
  });

  factory TokenModel.fromJson(json) {
    return TokenModel(
      token: json['token'],
      time: json['time'],
    );
  }

  toJson() {
    return {
      'token': token,
      'time': time,
    };
  }
}
