import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:liness/core/utils/constant/global_data.dart';
import 'package:liness/core/utils/constant/my_string.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/helper/secure_storage_helper%20.dart';
import 'package:liness/core/utils/helper/user_data/caching_user_data.dart';
import 'package:liness/core/utils/networking/api_consumer.dart';
import 'package:liness/feature/auth/login/data/model/token_model.dart';

import '../helper/user_data/access_user_data.dart';

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final tokenModel = await AccessUserData.getCachingUserToken();

    if (tokenModel != null) {
      final now = DateTime.now();

      // Parse token expiry time - handle both ISO string and timestamp
      DateTime? expiry;
      try {
        // Try to parse as ISO string first
        expiry = DateTime.tryParse(tokenModel.time);
        // If parsing fails, try as timestamp
        if (expiry == null) {
          final timestamp = int.tryParse(tokenModel.time);
          if (timestamp != null) {
            expiry = DateTime.fromMillisecondsSinceEpoch(timestamp);
          }
        }
      } catch (e) {
        debugPrint("❌ Failed to parse token time in interceptor: $e");
      }

      // Check if the current request is NOT a refresh token request
      // This prevents an infinite loop: request -> interceptor -> refresh -> request -> interceptor...
      final isRefreshRequest = options.path.contains('refresh-token');

      if (!isRefreshRequest && expiry != null && now.isAfter(expiry)) {
        debugPrint("⚠️ Token expired, attempting refresh...");
        final newToken = await _refreshToken();
        if (newToken != null) {
          options.headers[MyString.userKey] = newToken.token;
          debugPrint("✅ Token refreshed in interceptor");
        } else {
          debugPrint("❌ Failed to refresh token in interceptor");
        }
      } else {
        options.headers[MyString.userKey] = tokenModel.token;
      }
    }

    options.headers[MyString.secretKeyy] = MyString.secretKey;

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Prevent infinite loop if the refresh token request itself fails with 401
    final isRefreshRequest = err.requestOptions.path.contains('refresh-token');

    if (!isRefreshRequest && err.response?.statusCode == 401) {
      final refreshToken = await AccessUserData.getCachingUserRehreshToken();
      if (refreshToken != null) {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // أعد الطلب الأصلي مع التوكن الجديد
          final requestOptions = err.requestOptions;
          requestOptions.headers[MyString.userKey] = newToken.token;

          final cloneReq = await Dio().fetch(requestOptions);
          return handler.resolve(cloneReq);
        }
      }
    }

    handler.next(err);
  }

  Future<TokenModel?> _refreshToken() async {
    try {
      final refreshTokenModel =
          await AccessUserData.getCachingUserRehreshToken();
      if (refreshTokenModel == null) {
        debugPrint("❌ No refresh token available");
        return null;
      }

      debugPrint("🔄 Attempting to refresh token...");
      final response = await getIt<ApiConsumer>().post(
        'user/refresh-token',
        data: {'refreshToken': refreshTokenModel.token},
      );

      // Handle nested response structure: { "token": { "token": "...", "time": "..." } }
      if (response != null && response['token'] != null) {
        // Extract token data from nested structure
        final tokenData = response['token'];
        final tokenString = tokenData['token'] ?? tokenData.toString();

        // Handle time - can be timestamp (number) or ISO string
        dynamic timeValue = tokenData['time'];
        String timeString;

        if (timeValue is int) {
          // Convert timestamp to ISO string
          timeString =
              DateTime.fromMillisecondsSinceEpoch(timeValue).toIso8601String();
        } else if (timeValue is String) {
          timeString = timeValue;
        } else {
          debugPrint("❌ Invalid time format: $timeValue");
          return null;
        }

        final newToken = TokenModel(
          token: tokenString,
          time: timeString,
        );

        await getIt<SecureStorageHelper>().saveData(
          key: MyString.token,
          value: jsonEncode(newToken.toJson()),
        );

        /// ✅ حفظ refresh token إذا رجع من السيرفر
        if (response['refreshToken'] != null) {
          final refreshTokenData = response['refreshToken'];
          final refreshTokenString =
              refreshTokenData['token'] ?? refreshTokenData.toString();

          dynamic refreshTimeValue = refreshTokenData['time'];
          String refreshTimeString = '';

          if (refreshTimeValue is int) {
            refreshTimeString =
                DateTime.fromMillisecondsSinceEpoch(refreshTimeValue)
                    .toIso8601String();
          } else if (refreshTimeValue is String) {
            refreshTimeString = refreshTimeValue;
          } else {
            debugPrint("❌ Invalid refresh time format: $refreshTimeValue");
            // Continue anyway - at least we updated the token
            refreshTimeString = DateTime.now().toIso8601String();
          }

          final newRefreshToken = TokenModel(
            token: refreshTokenString,
            time: refreshTimeString,
          );

          await getIt<SecureStorageHelper>().saveData(
            key: MyString.refreshToken,
            value: jsonEncode(newRefreshToken.toJson()),
          );

          gLoginUserModel?.refreshToken = newRefreshToken;
        }

        gLoginUserModel?.token = newToken;
        CahcingUserData.cachingLoginUserModel(userLoginModel: gLoginUserModel!);

        debugPrint("✅ Token refreshed successfully");
        return newToken;
      }

      debugPrint("❌ Invalid response structure for token refresh");
      return null;
    } catch (e, stack) {
      debugPrint("❌ Failed to refresh token: $e");
      debugPrint("Stack trace: $stack");
    }
    return null;
  }
}
