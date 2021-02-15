import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workerf/recourse/UserApi.dart';
import 'package:workerf/repository/index.dart';

class UserProvider{
  static Future<UserQueryResult> market(LatLng location) async{
    UserApi _userApi = UserApi();
    try{
      Map response = await _userApi.market(location);
      return UserQueryResult(true, data: response);
    }catch(e){
      return UserQueryResult(false, data: e.message);
    }
  }

  static Future<UserQueryResult> fetchMarkets() async{
    UserApi _userApi = UserApi();
    try{
      List response = await _userApi.fetchMarkets();
      MarketRepository repository = MarketRepository.fromList(response);
      return UserQueryResult(true, data: repository);
    }catch(e){
      return UserQueryResult(false, data: e.message);
    }
  }
}

class UserQueryResult{
  final bool success;
  final dynamic data;
  UserQueryResult(this.success, {this.data});
}