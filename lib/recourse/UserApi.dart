import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:workerf/Exception/index.dart';
import 'package:workerf/global/index.dart';

class UserApi{

  Map authTokenGenerate()
  {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$appId:$appSecret'));

    Map<String, String> header =
    {
      "Content_Type": "text/plain; charset=UTF-8",
      "Authorization": basicAuth
    };
    return header;
  }

  Future<Map> market(LatLng location) async{
    String url = 'https://back.manoexperta.com/rest/markets/${location.latitude},${location.longitude}';
    Map header = authTokenGenerate();
    Response response = await get(url,headers: header).timeout(Duration(seconds: 5));

    if(response.statusCode == 200){
      Map responseBody = jsonDecode(response.body);

      if(responseBody['SUCCESS']){
        return responseBody['data'];
      }else{
        throw AppException(code: ErrorCode.session, errorMessage: responseBody['errormsg']);
      }
    }else{
      throw AppException(code: ErrorCode.internal, errorMessage: "Algo salió mal");
    }

  }

  Future<List> fetchMarkets() async{
    String url = 'https://back.manoexperta.com/rest/tools/markets/0';
    Map header = authTokenGenerate();
    Response response = await get(url,headers: header).timeout(Duration(seconds: 15));
    if(response.statusCode == 200){
      Map responseBody = jsonDecode(response.body);

      if(responseBody['success']){
        return responseBody['data'];
      }else{
        throw AppException(code: ErrorCode.session, errorMessage: responseBody['errormsg']);
      }
    }else{
      throw AppException(code: ErrorCode.internal, errorMessage: "Algo salió mal");
    }
  }
}