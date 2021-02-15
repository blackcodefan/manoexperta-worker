import 'ErrorCode.dart';

class AppException implements Exception {
  final ErrorCode code;
  final String errorMessage;
  final dynamic data;

  AppException({this.code, this.errorMessage, this.data});
}