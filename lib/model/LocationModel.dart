import 'package:geocoder/model.dart';
import 'package:image/image.dart';

class LocationModel{
  Image image;
  Address address;

  LocationModel({this.image, this.address}):assert(image != null && address != null);
}