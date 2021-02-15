import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:workerf/global/index.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart' as GFF;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workerf/ui/Components/index.dart';

import 'InternalSocketProvider.dart';

class GServiceProvider{

//  static Future<Position> fetchLocation() async{
//    Geolocator geoLocator = Geolocator();
//    Position position;
//    try{
//      position = await geoLocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//          .timeout(Duration(seconds: 5));
//      return position;
//    }on TimeoutException catch(e){
//      return position;
//    }
//  }
//
//  static Future<void> listenLocationUpdate() async{
//    Geolocator geoLocator = Geolocator();
//    try{
//      LocationOptions locationOptions = LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 5000, distanceFilter: 20);
//      geoLocator.getPositionStream(locationOptions).listen((Position position) {
//        iSocket.trigger(InternalSocketT.locationUpdate, data: position);
//        GServiceProvider.updateLocation(position);
//      });
//    }catch(e){
//      CToast.warning("incapaz de obtener la ubicación. Es posible que la aplicación no funcione correctamente");
//    }
//
//  }
//
//  static updateLocation(Position position){
//    final geo = GFF.Geoflutterfire();
//    final CollectionReference _fireStoreRef2 = FirebaseFirestore.instance.collection('users_on_map');
//    GFF.GeoFirePoint myLocation = geo.point(latitude: position.latitude, longitude: position.longitude);
//    _fireStoreRef2.doc('${currentUser.userId}')
//        .set(currentUser.toMap(myLocation.data));
//  }
//
//  static Stream<DocumentSnapshot> expertLocationStream(int expertId){
//    final CollectionReference _fireStoreRef = FirebaseFirestore.instance.collection('users_on_map');
//    return _fireStoreRef.doc('$expertId')
//        .snapshots();
//  }
//
//  static Stream<List<DocumentSnapshot>> nearByExpertStream(LatLng center, double range){
//    CollectionReference collectionReference = FirebaseFirestore.instance.collection('users_on_map');
//
//    final geo = GFF.Geoflutterfire();
//    GFF.GeoFirePoint _center = geo.point(latitude: center.latitude, longitude: center.longitude);
//    String field = 'position';
//    return geo.collection(collectionRef: collectionReference)
//        .within(center: _center, radius: range, field: field, strictMode: true);
//  }

  static Future<Address> getAddressFromLocation(Position position) async{
    final coordinate = new Coordinates(position.latitude, position.longitude);
    List<Address>  addresses = await Geocoder.local.findAddressesFromCoordinates(coordinate)
        .timeout(Duration(seconds: 15));
    return addresses.first;
  }

  static Future<List<Address>> getAddressFromString(String addressLine) async{
    List<Address> addresses = await Geocoder.local.findAddressesFromQuery(addressLine)
        .timeout(Duration(seconds: 5));
    return addresses;
  }

  static Future getDistance(LatLng position1, LatLng position2) async
  {
    double distanceInMeters = await Geolocator().distanceBetween(position1.latitude, position1.longitude, position2.latitude, position2.longitude);
    return distanceInMeters/1000;
  }

  static Future<String> uploadImage(image, String dir, {String uniqueName})async{
    final StorageReference fireStorage = FirebaseStorage.instance.ref();
    String imageName;
    uniqueName == null? imageName = image.toString().split('/').last: imageName = uniqueName;

    try{
      final StorageUploadTask task = fireStorage.child('$dir/$imageName').putFile(image);
      StorageTaskSnapshot  storageTaskSnapshot = await task.onComplete;
      String url = await storageTaskSnapshot.ref.getDownloadURL();
      return url;
    }catch(e){
      return null;
    }
  }

}