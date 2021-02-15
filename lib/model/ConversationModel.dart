import 'DeviceModel.dart';
import 'ProjectDetailModel.dart';

class ConversationModel{
  int id;
  String chatType;

  int clientId;
  String clientAvatar;
  String clientName;
  String clientDevices;
  String clientMobile;

  int expertId;
  String expertName;
  String expertAvatar;
  String expertDevices;
  String expertMobile;

  ConversationModel({this.chatType, this.id, this.clientName, this.clientAvatar});

  ConversationModel.fromProjectDetail(String type, int idd, ProjectDetailModel detail){
    id = idd;
    chatType = type;

    clientId = detail.clientId;
    clientAvatar = detail.clientAvatar;
    clientName = detail.clientFName;
    clientMobile = detail.clientMobile;
    clientDevices = detail.clientDevices;

    expertId = detail.workerId;
    expertName = detail.workerFName;
    expertAvatar = detail.workerAvatar;
    expertDevices = detail.workerDevices;
    expertMobile = detail.workerMobile;
  }

  Map<String, dynamic> toMap() => {
    "client": clientId,
    "clientAvatar": clientAvatar,
    "clientName": clientName,
    "clientMobile": clientMobile,
    "expert": expertId,
    "expertAvatar": expertAvatar,
    "expertName": expertName,
    "expertMobile": expertMobile
  };
}