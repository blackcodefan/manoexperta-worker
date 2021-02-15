import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProjectDetailModel{
  int categoryId;
  String categoryName;
  String categoryImg;
  String address;
  String description;
  LatLng location;

  int workerVote;
  bool workerVerified;
  String workerFName;
  String workerPartnerName;
  String workerPartnerLogo;
  LatLng workerLocation;
  String workerIdUrl;
  int workerSource;
  String workerAvatar;
  int workerId;
  double workerRate;
  String workerDevices;
  String workerMobile;

  String clientAvatar;
  int clientId;
  String clientDevices;
  String clientFName;
  String clientMobile;

  ProjectDetailModel({this.description, this.address, this.workerFName, this.location});

  factory ProjectDetailModel.init() =>ProjectDetailModel(
    description: "",
    address: "",
    workerFName: "",
    location: LatLng(19.2409, -99.0987)
  );

  ProjectDetailModel.fromMap(Map data){
    Map request = data['request'];
    Map client =data['client'];
    categoryId = request['catid'];
    categoryName = request['catname'];
    categoryImg = request['catimgurl'];
    address = request['address'];
    description = request['describe'];
    location = convertStringToPosition(request['latlng']);
    Map worker = data['worker'];
    if(worker != null){
      workerVote = worker['votes'];
      workerVerified = worker['isexpertverified'];
      workerFName = worker['firstname'];
      workerPartnerName = worker['partnername'];
      workerPartnerLogo = worker['partnerlogourl'];
      workerLocation = convertStringToPosition(worker['expertlastlatlng']);
      workerIdUrl = worker['expertdocurl'];
      workerSource = worker['expertsource'];
      workerAvatar = worker['expertavatar'];
      workerId = worker['userid'];
      workerRate = worker['stars'];
      workerDevices = worker['devices'];
      workerMobile = worker['mobile'];
    }
    clientAvatar = client['clientavatar'];
    clientId = client['userid'];
    clientDevices = client['devices'];
    clientFName = client['firstname'];
    clientMobile = client['mobile'];
  }

  LatLng convertStringToPosition(String positionString)
  {
    List result = positionString.split(',');
    var position = LatLng(double.parse(result[0]), double.parse(result[1]));
    return position;
  }
}
