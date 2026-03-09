import 'package:equatable/equatable.dart';

class RegisterUserModel extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String pPhone;
  final String year;
  final String state;
  final String password;

  const RegisterUserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.pPhone,
    required this.year,
    required this.state,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'pPhone': pPhone,
      'year': year,
      'state': state,
      'password': password,
    };
  }

factory RegisterUserModel.fromJson(Map<String, dynamic> map) {
  return RegisterUserModel(
    name: map['name'] != null ? map['name'] as String : '', 
    email: map['email'] != null ? map['email'] as String : '',
    phone: map['phone'] != null ? map['phone'] as String : '', 
    pPhone: map['pPhone'] != null ? map['pPhone'] as String : '', 
    year: map['year'] != null ? map['year'] as String : '', 
    state: map['state'] != null ? map['state'] as String : '',
    password: map['password'] != null ? map['password'] as String : '', 
  );
}


  @override
  List<Object?> get props => [name, email, phone, pPhone, year, state, password];
}
