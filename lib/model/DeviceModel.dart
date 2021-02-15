import 'package:flutter/material.dart';

enum DevicePlatform{
  android,
  ios
}

class Device{
  DevicePlatform platform;
  String deviceId;

  Device({
    @required this.platform,
    @required this.deviceId
  }):assert(
  platform != null &&
      deviceId != null);

  static List<Device> fromDynamicList(List<dynamic> devices){
    List<Device> _devices = [];
    devices.forEach((device) {
      _devices.add(Device(
          platform: device['platform'] == 'A'?DevicePlatform.android:DevicePlatform.ios,
          deviceId: device['deviceID']));
    });

    return _devices;
  }
}