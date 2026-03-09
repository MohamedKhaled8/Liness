import 'package:dartz/dartz.dart';
import 'package:liness/core/utils/error/exception.dart';
import 'package:liness/core/utils/error/model/error_model.dart';
import 'package:liness/core/utils/networking/api_constant.dart';
import 'package:liness/core/utils/networking/dio_consumer.dart';

class RegisterRepository {
  final DioConsumer dioConsumer;

  RegisterRepository({required this.dioConsumer});

  Future<Either<ErrorModel, String>> registerUser({
    required String name,
    required String phone,
    required String pPhone,
    required String email,
    required String password,
    required String year,
    required String state,
    // required String deviceId,
  }) async {
    try {
      await dioConsumer.post(
        EndPoints.register,
        data: {
          "name": name,
          "phone": phone,
          "email": email,
          "password": password,
          "pPhone": pPhone,
          "year": year,
          "state": state,
          // "deviceId": deviceId,
        },
      );
      ////
      return const Right("تم إنشاء حساب جديد بنجاح");
      ////
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }
}
