import 'token_model.dart';
import 'package:equatable/equatable.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class LoginUserModel extends Equatable {
   TokenModel token;
   TokenModel refreshToken;
  String name;
  String email;
  String phone;
  final int code;

  LoginUserModel({
    required this.token,
    required this.refreshToken,
    required this.name,
    required this.email,
    required this.phone,
    required this.code,
  });

  @override
  List<Object> get props => [token, name, email, code];

  factory LoginUserModel.fromJson(map) {
    return LoginUserModel(
      token: TokenModel.fromJson(map['token']),
      refreshToken: TokenModel.fromJson(map['refreshToken']),
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] ?? '',
      code: map['code'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'token': token.toJson(),
      'refreshToken': refreshToken.toJson(),
      'name': name,
      'email': email,
      'phone': phone,
      'code': code,
    };
  }
}
