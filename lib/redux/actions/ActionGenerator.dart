import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:redux_api_middleware/redux_api_middleware.dart';
import 'package:workerf/global/index.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/repository/index.dart';

class BackendActionGenerator{
  final String method;
  final String endpoint;
  final List<String> types;
  final Map body;

  BackendActionGenerator({
    @required this.method,
    @required this.endpoint,
    @required this.types,
    this.body});

  dynamic generate(){
    if(body != null)
      return {
      RSAA: {
        "method": method,
        "endpoint": endpoint,
        "types": types,
        "headers": {
          'Content-Type': 'text/plain; charset=UTF-8',
          'Authorization': 'Basic ' + base64Encode(utf8.encode('$appId:$appSecret'))
        },
        "body":jsonEncode(body)
      }
    };
    else
      return {
        RSAA: {
          "method": method,
          "endpoint": endpoint,
          "types": types,
          "headers": {
            'Content-Type': 'text/plain; charset=UTF-8',
            'Authorization': 'Basic ' + base64Encode(utf8.encode('$appId:$appSecret'))
          }
        }
      };
  }
}

class LocalStorageActionGenerator{
  String type;

  LocalStorageActionGenerator(this.type);

  Map setAction(String email, String password)
    => {
      "type": type,
      "payload":{
        "email": email,
        "password": password
      }
    };
}

class UserUpdateActionGenerator{
  String type;
  UserModel user;
  UserUpdateActionGenerator(this.type, this.user);

  Map generate()=>{
    "type": type,
    "payload": user
  };
}

class ProjectsUpdateActionGenerator{
  String type;
  ProjectRepository repository;
  ProjectsUpdateActionGenerator(this.type, this.repository);

  Map generate() =>{
    "type": type,
    "payload": repository
  };
}