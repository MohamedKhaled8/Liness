import 'package:dartz/dartz.dart';
import '../model/api/profile_model.dart';
import 'package:liness/core/utils/error/exception.dart';
import 'package:liness/core/utils/constant/global_data.dart';
import 'package:liness/core/utils/error/model/error_model.dart';
import 'package:liness/core/utils/networking/api_constant.dart';
import 'package:liness/core/utils/networking/dio_consumer.dart';
import 'package:liness/core/utils/helper/user_data/caching_user_data.dart';


class ProfileRepository {
  final DioConsumer dioConsumer;

  ProfileRepository({required this.dioConsumer});

  Future<Either<ErrorModel, ProfileModel>> getProfileData() async {
    try {
      ////
      final response = await dioConsumer.get(
        EndPoints.userProfile,
      );
      ////
      final profileModel = ProfileModel.fromJson(response);
      ////
      gLoginUserModel?.email = profileModel.email;
      gLoginUserModel?.name = profileModel.name;
      gLoginUserModel?.phone = profileModel.phone;
      ////
      if (gLoginUserModel != null) {
        CahcingUserData.cachingLoginUserModel(userLoginModel: gLoginUserModel!);
      }
      ////
      return Right(profileModel);
      ////
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }
}
