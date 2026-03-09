import 'dart:convert';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/constant/my_string.dart';
import 'package:liness/core/utils/helper/cash_helper.dart';
import 'package:liness/core/utils/constant/global_data.dart';
import 'package:liness/core/utils/helper/secure_storage_helper%20.dart';
import 'package:liness/feature/auth/login/data/model/login_user_model.dart';

class CahcingUserData {
  CahcingUserData._();

  static void cachingLoginUserModel({
    required LoginUserModel userLoginModel,
  }) async {
    ////
    await getIt<CacheHelper>().saveData(
      key: MyString.loginModelKey,
      value: jsonEncode(
        userLoginModel.toJson(),
      ),
    );
    ////
    gLoginUserModel = userLoginModel;
    ////
  }

  static void cachingUserTokens({
    required LoginUserModel userLoginModel,
  }) async {
    ////
    await getIt<SecureStorageHelper>().saveData(
      key: MyString.token,
      value: jsonEncode(
        userLoginModel.token.toJson(),
      ),
    );
    ////
    await getIt<SecureStorageHelper>().saveData(
      key: MyString.refreshToken,
      value: jsonEncode(
        userLoginModel.refreshToken.toJson(),
      ),
    );
    ////
  }
}
