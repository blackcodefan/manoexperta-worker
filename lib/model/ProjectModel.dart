import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProjectModel{
  int id;
  String description;
  String img;
  LatLng _location;
  int catId;
  int clientId;
  int exclusive;
  List<dynamic> blocked;
  String timestamp;
  double distance;

  LatLng get location => _location;

  void  calcDistance(LatLng myLocation){
    const R = 6371000;
    double f1 = _location.latitude * pi / 180;
    double f2 = myLocation.latitude * pi /180;
    double df = (_location.latitude - myLocation.latitude) * pi / 180;
    double dr = (_location.longitude - myLocation.longitude) * pi /180;
    double a = pow(sin(df/2), 2) + cos(f1) * cos(f2) * pow(sin(dr/2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    distance = R * c / 100;
  }

  ProjectModel.fromMap(Map data){
    id = data['reqid'];
    description = data['describe'];
    img = data['imgurl'];
    _location = convertStringToPosition(data['latlng']);
    catId = data['catid'];
    clientId = data['userid'];
    exclusive = data['exclusive'];
    blocked = data['blockedxp'];
    timestamp = data['dtstamp'];
  }

  ProjectModel.fromSocketMessage(Map data){
    id = data['reqId'];
    description = data['description'];
    img = data['img'];
    _location = LatLng(data['location']['_lat'], data['location']['_lng']);
    catId = data['catId'];
    exclusive = data['exclusive'];
    blocked = data['blockedXp'];
  }

  ProjectModel.fromInquirySocket(Map data){
    id = data['reqId'];
    description = data['description'];
    img = data['img'];
    _location = LatLng(double.parse(data['location']['_lat']), double.parse(data['location']['_lng']));
    catId = data['catId'];
    exclusive = int.parse(data['exclusive']);
    blocked = data['blockedXp'];
  }

  LatLng convertStringToPosition(String positionString)
  {
    List result = positionString.split(',');
    var position = LatLng(double.parse(result[0]), double.parse(result[1]));
    return position;
  }
}