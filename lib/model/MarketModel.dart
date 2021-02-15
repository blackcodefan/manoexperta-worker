import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarketModel{
  String flag;
  String country;
  String name;
  String countryCode;
  bool hasChild;
  LatLng location;

  MarketModel.fromMap(Map market){
    flag = market['image'];
    country = market['country'];
    name = market['mktHandle'];
    countryCode = market['countryCode'];
    hasChild = market['hasChildren'];
    location = convertStringToPosition(market['latlng']);
  }

  LatLng convertStringToPosition(String positionString)
  {
    List result = positionString.split(',');
    var position = LatLng(double.parse(result[0]), double.parse(result[1]));
    return position;
  }
}