import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:workerf/global/index.dart';

class BidModel{
  String id;
  String inqId;
  int clientId;
  int expertId;
  String inqImage;
  String expertFName;
  String expertLName;
  String expertAvatar;
  double budget;
  int unread;

  BidModel({
    @required this.inqId,
    @required this.clientId,
    @required this.expertId,
    @required this.inqImage,
    @required this.expertFName,
    @required this.expertLName,
    @required this.expertAvatar,
    @required this.budget,
    this.unread = 0});

  BidModel.fromMap(DocumentSnapshot snapshot){
    id = snapshot.id;
    inqId = snapshot['inqId'];
    clientId = snapshot['clientId'];
    expertId = snapshot['expertId'];
    inqImage = snapshot['inqImage'];
    expertFName = snapshot['expertFName'];
    expertLName = snapshot['expertLName'];
    expertAvatar = snapshot['expertAvatar'];
    budget = snapshot['budget'];
    unread = snapshot['unread'];
  }

  Map<String, dynamic> toMap() =>{
    "inqId": inqId,
    "clientId": clientId,
    "expertId": expertId,
    "deviceId": notificationToken,
    "inqImage": inqImage,
    "expertFName": expertFName,
    "expertLName": expertLName,
    "expertAvatar": expertAvatar,
    "budget": budget,
    "unread": 0
  };
}