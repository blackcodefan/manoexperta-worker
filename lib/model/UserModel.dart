import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workerf/global/index.dart';

class UserModel{
  String token;
  int userId;
  String email;
  String password;
  String firstName;
  String lastName;
  String avatar;
  bool _active;
  int activeProject;
  int maxCat;
  String partnerName;
  double range;
  bool emailNotification;
  int bankVerifyStatus;
  int maxApply;
  String expertName;
  List<dynamic> channels;
  int applied;
  List<dynamic> categories;
  int verifiedStatus;
  String bankCardImg;
  String bankCardNumber;
  String bankId;
  String partnerLogo;
  String idUrl;
  String idUrl2;
  int source;
  bool pushNotification;
  String deviceId;
  String mobile;
  LatLng location;
  Address address;
  bool allowDirectHire;
  bool isPremium;

  UserModel({this.userId});

  UserModel.fromMap(Map data, Map tokenData){
    token = tokenData['tokenid'];
    userId = tokenData['userid'];
    if(data != null){
      email = data['email'];
      firstName = data['firstname'];
      lastName = data['lastname'];
      avatar = data['expertavatar'];
      _active = data['expertactive'];
      activeProject = data['activereq'];
      maxCat = data['maxcats'];
      partnerName = data['partnername'];
      range = data['maxkms'].toDouble();
      emailNotification = data['optmailnews'];
      bankVerifyStatus = data['expertbankverifiedstatus'];
      maxApply = data['maxapply'];
      expertName = data['expertname'];
      channels = data['channels'];
      applied = data['applied'];
      categories = data['categories'];
      verifiedStatus = data['expertverifiedstatus'];
      bankCardImg = data['expertbankdocurl'];
      bankCardNumber = data['expertbankclabe'];
      if(data['expertbankid'].runtimeType == int)
      bankId = data['expertbankid'].toString();
      else bankId = data['expertbankid'];
      partnerLogo = data['partnerlogourl'];
      idUrl = data['expertdocurl'];
      idUrl2 = data['expertdocurl2'];
      source = data['expertsource'];
      pushNotification = data['expertpushmsg'];
      deviceId = data['devices'];
      mobile = data['mobile'];
      allowDirectHire = data['expertShowInList'];
      isPremium = data['isPremium'];
    }
  }

  bool get active {
    if(_active == null) return false;
    else return _active;
  }

  String get mobileFormat => mobile.replaceFirst('001', '+1').replaceFirst('052', '+52').replaceFirst('591', '+591');

  List<dynamic> get expertChannels{
    if(channels.indexOf('expert') == -1)
    channels.add("expert");
    return channels;
  }

  bool isExistDevice() { return deviceId == notificationToken;}

  void addDevice(){
    deviceId = notificationToken;
  }

  Map<String, dynamic> toMap(Map position){
    return {
      "userId": userId,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "avatar": avatar,
      "mobile": mobile,
      "role": "expert",
      "categories": categories,
      "position": position
    };
  }
}