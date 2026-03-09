import 'dart:convert';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/constant/my_string.dart';
import 'package:liness/core/utils/helper/cash_helper.dart';
import 'package:liness/core/utils/constant/global_data.dart';
import 'package:liness/feature/auth/login/data/model/token_model.dart';
import 'package:liness/core/utils/helper/secure_storage_helper%20.dart';
import 'package:liness/feature/auth/login/data/model/login_user_model.dart';

class AccessUserData {
  AccessUserData._();

  static Future<LoginUserModel?> getCachingLoginUserModel() async {
    ////
    final decodedModel = await getIt<CacheHelper>().getData(
      key: MyString.loginModelKey,
    );
    ////
    if (decodedModel != null) {
      gLoginUserModel = LoginUserModel.fromJson(
        jsonDecode(decodedModel),
      );
    }
    ////
    return gLoginUserModel;
    ////
  }

  static Future<TokenModel?> getCachingUserToken() async {
    ////
    final decodedModel = await getIt<SecureStorageHelper>().getData(
      key: MyString.token,
    );

    ////
    if (decodedModel != null) {
      return TokenModel.fromJson(jsonDecode(decodedModel));
    }
    ////
    return null;
    ////
  }

  static Future<TokenModel?> getCachingUserRehreshToken() async {
    ////
    final decodedModel = await getIt<SecureStorageHelper>().getData(
      key: MyString.refreshToken,
    );

    ////
    if (decodedModel != null) {
      return TokenModel.fromJson(jsonDecode(decodedModel));
    }
    ////
    return null;
    ////
  }
}
