import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workerf/Exception/index.dart';

class LocationLocalSave{
  Position location;

  LocationLocalSave({@required this.location});

  Future<void> setLocation() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('location', jsonEncode({"latitude": location.latitude, "longitude": location.longitude}));
  }

  static Future<Position> getLocation() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('location'))
    {
      throw AppException(code: ErrorCode.noLocationSaved);
    }else{
      String data = prefs.getString('location');
      Map location = jsonDecode(data);

      return Position(latitude: location['latitude'], longitude: location['longitude']);
    }
  }
}