import 'package:dartz/dartz.dart';
import 'package:liness/core/utils/error/exception.dart';
import 'package:liness/core/utils/error/model/error_model.dart';
import 'package:liness/core/utils/networking/api_constant.dart';
import 'package:liness/core/utils/networking/dio_consumer.dart';
import 'package:liness/feature/auth/login/data/model/login_user_model.dart';

class LoginRepository {
  final DioConsumer api;

  LoginRepository({
    required this.api,
  });

  Future<Either<ErrorModel, LoginUserModel>> signIn({
    required String email,
    required String password,
    // required String deviceId,
  }) async {
    try {
      final response = await api.post(
        EndPoints.login,
        data: {
          "email": email,
          "password": password,
          // "deviceId": deviceId,
        },
      );

      final user = LoginUserModel.fromJson(response);

      return Right(user);
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }
}
