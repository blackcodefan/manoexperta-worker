import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workerf/global/index.dart';

class InquiryModel{

  String id;
  int inqId;
  int clientId;
  String deviceId;
  int catId;
  String address;
  LatLng location;
  String description;
  String image;
  List<Bidder> bidders;
  int time;
  bool active;

  bool get hasBid{
    return bidders.where((element) => element.expertId == currentUser.userId).toList().length > 0;
  }

  int get unread{
    for(int i = 0; i < bidders.length; i ++){
      if(bidders[i].expertId == currentUser.userId){
        return bidders[i].eUnread;
      }
    }
    return 0;
  }

  InquiryModel.fromMap(DocumentSnapshot snapshot){
    id = snapshot.id;
    inqId = snapshot['inqId'];
    clientId = snapshot['clientId'];
    deviceId = snapshot['deviceId'];
    catId = snapshot['catId'];
    location = LatLng(snapshot['location']['geopoint'].latitude, snapshot['location']['geopoint'].longitude);
    address = snapshot['address'];
    description = snapshot['description'];
    image = snapshot['image'];
    time = snapshot['timestamp'];
    bidders = Bidder.fromList(snapshot['bidders']);
    active = snapshot['active'];
  }

  Map<String, dynamic> bidToMap() {
    List<Map> _bidders = [];
    bidders.forEach((bidder) {
      _bidders.add({
        "expertId": bidder.expertId,
        "unread": bidder.unread,
        "eUnread": bidder.eUnread
      });
    });

    _bidders.add({
      "expertId": currentUser.userId,
      "unread": 0,
      "eUnread": 0
    });
    return {"bidders": _bidders};
  }

  Map<String, List<Map>> setUnread(int expertId){
    List<Map<String, dynamic>> _bidders = [];
    bidders.forEach((bidder) {
      _bidders.add({
        "expertId": bidder.expertId,
        "unread": expertId == bidder.expertId?bidder.unread + 1:bidder.unread,
        "eUnread": bidder.eUnread
      });
    });

    return {"bidders": _bidders};
  }

  Map<String, List<Map>> clearUnread(int expertId){
    List<Map<String, dynamic>> _bidders = [];
    bidders.forEach((bidder) {
      _bidders.add({
        "expertId": bidder.expertId,
        "unread": bidder.unread,
        "eUnread": 0
      });
    });

    return {"bidders": _bidders};
  }
}

class Bidder{
  int expertId;
  int unread;
  int eUnread;

  Bidder({this.expertId, this.unread, this.eUnread});

  static List<Bidder> fromList(List<dynamic> bidders){
    List<Bidder> _bidders = [];
    bidders.forEach((bidder) {
      _bidders.add(Bidder(expertId: bidder['expertId'], unread: bidder['unread'], eUnread: bidder['eUnread']));
    });

    return _bidders;
  }
}