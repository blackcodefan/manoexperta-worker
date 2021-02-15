import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  String documentId;
  String owner;
  String type;
  String content;
  GeoPoint location;
  String url;
  Timestamp timestamp;
  File file;
  List<int> memory;
  bool delivered;

  MessageModel({
    this.owner,
    this.type,
    this.content,
    this.location,
    this.url,
    this.timestamp,
    this.file,
    this.memory,
    this.delivered});

  MessageModel.fromMap(DocumentSnapshot snapshot){
    Map data = snapshot.data();
    documentId = snapshot.id;
    owner = data['owner'];
    type = data['type'];
    content = data['content'];
    timestamp = data['timestamp'];
    type == 'location'?location = data['location']:location = null;
    type == 'location' || type == 'file'?url = data['url']:url = null;
    delivered = true;
  }

  Map<String, dynamic> toMap()=> {
    "owner": owner,
    "type": type,
    "content": content,
    "url": url,
    "location": location,
    "timestamp": FieldValue.serverTimestamp()
  };
}