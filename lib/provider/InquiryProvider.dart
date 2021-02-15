import 'dart:io';

import 'package:workerf/global/index.dart';
import 'package:workerf/model/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire/geoflutterfire.dart' as GFF;

class InquiryProvider{
  final geo = GFF.Geoflutterfire();

  static Stream<List<DocumentSnapshot>> inquiryStream(){
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('inquiries');
    final geo = GFF.Geoflutterfire();
    GFF.GeoFirePoint _center = geo.point(latitude: globalLocationData.latitude, longitude: globalLocationData.longitude);
    String field = 'location';

    return geo.collection(collectionRef: collectionReference)
        .within(center: _center, radius: currentUser.range, field: field, strictMode: true);
  }
  
  static Future<void> placeBid(InquiryModel model, double budget) async{

    CollectionReference inquiryReference = FirebaseFirestore.instance.collection('inquiries');
    CollectionReference bidReference = FirebaseFirestore.instance.collection('bids');

    BidModel bid = BidModel(
        inqId: model.id,
        clientId: model.clientId,
        expertId: currentUser.userId,
        inqImage: model.image,
        expertFName: currentUser.firstName,
        expertLName: currentUser.lastName,
        expertAvatar: currentUser.avatar,
        budget: budget);

    bidReference.doc("${model.id}_${currentUser.userId}").set(bid.toMap());
    return inquiryReference
        .doc(model.id)
        .update(model.bidToMap());
  }

  static Future<void> updateBid(InquiryModel model, double budget) async{

    CollectionReference bidReference = FirebaseFirestore.instance.collection('bids');

    return bidReference.doc("${model.id}_${currentUser.userId}").update({"budget": budget});
  }

  static Stream<DocumentSnapshot> fetchInquiry(String inqId){
    return FirebaseFirestore.instance.collection('inquiries').doc(inqId).snapshots();
  }

  static Stream<DocumentSnapshot> fetchBid(String bidId){
    return FirebaseFirestore.instance.collection('bids').doc(bidId).snapshots();
  }

  Future<String> uploadImage(File image, String dir, {String uniqueName})async{
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

  static Future<DocumentSnapshot> getClient(int clientId) async{
    return await FirebaseFirestore
        .instance
        .collection('users_on_map')
        .doc(clientId.toString())
        .get();
  }
}