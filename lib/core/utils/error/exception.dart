import 'package:dio/dio.dart';
import 'package:liness/core/utils/error/model/error_model.dart';

class ServerExeption implements Exception {
  final ErrorModel errorModel;
  ServerExeption({
    required this.errorModel,
  });
}

void handleDioException(DioException e) {
  final errorData = (e.response?.data is Map)
      ? (e.response?.data as Map).cast<String, dynamic>()
      : <String, dynamic>{};

  // If the server provides a message, used it. Otherwise, provide a default based on the exception type.
  String msgAr = errorData['msgAr'] ?? '';
  String msgEn = errorData['msgEn'] ?? '';

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      if (msgAr.isEmpty) {
        msgAr = "انتهت مهلة الاتصال بالخادم، يرجى المحاولة مرة أخرى";
        msgEn = "Connection timeout with the server, please try again";
      }
      break;
    case DioExceptionType.badCertificate:
      if (msgAr.isEmpty) {
        msgAr = "خطأ في شهادة الخدمة";
        msgEn = "Bad certificate error";
      }
      break;
    case DioExceptionType.cancel:
      if (msgAr.isEmpty) {
        msgAr = "تم إلغاء العملية";
        msgEn = "Operation cancelled";
      }
      break;
    case DioExceptionType.connectionError:
      if (msgAr.isEmpty) {
        msgAr = "تعذر الاتصال بالخادم، يرجى التأكد من اتصالك بالإنترنت";
        msgEn =
            "Could not connect to server, please check your internet connection";
      }
      break;
    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400:
        case 401:
        case 403:
          if (msgAr.isEmpty) {
            msgAr = "البيانات المدخلة غير صحيحة";
            msgEn = "Invalid credentials or data";
          }
          break;
        case 404:
          if (msgAr.isEmpty) {
            msgAr = "الصفحة أو الخدمة غير موجودة";
            msgEn = "Service or page not found";
          }
          break;
        case 409:
          if (msgAr.isEmpty) {
            msgAr = "حدث تعارض في البيانات";
            msgEn = "Conflict in data";
          }
          break;
        case 500:
        case 504:
          if (msgAr.isEmpty) {
            msgAr = "خطأ داخلي في الخادم، يرجى المحاولة لاحقاً";
            msgEn = "Internal server error, please try again later";
          }
          break;
        default:
          if (msgAr.isEmpty) {
            msgAr = "حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى";
            msgEn = "An unexpected error occurred, please try again";
          }
      }
      break;
    case DioExceptionType.unknown:
      if (msgAr.isEmpty) {
        msgAr = "خطأ في الاتصال بالإنترنت أو مشكلة غير معروفة";
        msgEn = "Network error or unknown issue occurred";
      }
      break;
  }

  throw ServerExeption(
    errorModel: ErrorModel(
      status: e.response?.statusCode ?? 0,
      msgAr: msgAr,
      msgEn: msgEn,
    ),
  );
}
