import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workerf/Exception/index.dart';

class CredentialModel{
  String email;
  String password;
  String loginType;

  CredentialModel({
    @required this.email,
    @required this.password,
    @required this.loginType
  }):assert(email != null &&
      password != null &&
      loginType != null);

  factory CredentialModel.fromMap(Map credential){
    return CredentialModel(email: credential['email'], password: credential['password'], loginType: "me");
  }

  Future<void> setCredential() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('credential', [email, password, 'me']);
  }

  static Future<CredentialModel> getCredential() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('credential'))
    {
      throw AppException(code: ErrorCode.noCredential, errorMessage: "No saved credential");
    }else{
      List<String> savedCredential = prefs.getStringList('credential');
      return CredentialModel(
          email: savedCredential[0],
          password: savedCredential[1],
          loginType: savedCredential[2]);
    }
  }

  static Future<void> eraseCredential() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('credential');
  }
}