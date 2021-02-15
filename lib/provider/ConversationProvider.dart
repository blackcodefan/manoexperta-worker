import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:workerf/global/index.dart';
import 'package:workerf/model/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart';
import 'package:http/http.dart';

class ConversationProvider{
  final CollectionReference _fireStoreRef = FirebaseFirestore.instance.collection('chat');
  DocumentReference _chatRef;

  Future<void> setup(ConversationModel model) async{
    _chatRef = _fireStoreRef.doc('${model.chatType}_${model.id}');
    DocumentSnapshot snapshot = await _chatRef.get();
    if(snapshot.data() == null){
      Map<String, dynamic> initialData = model.toMap();
      await _chatRef.set(initialData);
    }
  }

  StreamSubscription<QuerySnapshot> conversationStream(Function onData){
    return _chatRef.collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen(onData);
  }

  Future<void> send(MessageModel message)async{

    message.timestamp = Timestamp.now();
    Future<void> snapshot = _chatRef
        .collection('messages')
        .add(message.toMap());
    return snapshot;
  }

  Future<String> uploadImage(File image)async{
    final StorageReference fireStorage = FirebaseStorage.instance.ref();
    String imageName = image.path.split('/').last;

    final StorageUploadTask task = fireStorage.child('chatImage/$imageName').putFile(image);
    StorageTaskSnapshot  storageTaskSnapshot = await task.onComplete;
    String url = await storageTaskSnapshot.ref.getDownloadURL();
    return url;
  }

  Future<String> uploadLocation(Image location) async{
    final StorageReference fireStorage = FirebaseStorage.instance.ref();
    final StorageUploadTask task = fireStorage.child(
        'locationImage/' + DateTime.now().millisecondsSinceEpoch.toString())
        .putData(encodePng(location));
    var storageTaskSnapshot = await task.onComplete;
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future notifyUser(String userDeviceId, int reqId, {String description, String attachment}) async
  {
    String url = 'https://fcm.googleapis.com/fcm/send';
    var header = {
      "Content-Type": "application/json",
      "Authorization": notificationAuthKey
    };

    String body = jsonEncode({
      "to" : userDeviceId,
      "notification" : {
        "body" : "Tienes mensajes no leídos",
        "title": "Mensaje no leído",
        "image": attachment
      },
      "data" : {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "type": "unread_message",
        "body": description,
        "reqid": reqId,
        "source": "request"
      }});

    try
    {
      Response response = await post(url, headers: header, body: body)
          .timeout(Duration(seconds: 15));
      return jsonDecode(response.body);
    }
    catch (e)
    {
      print(e);
      return null;
    }
  }
}

class InqConversationProvider{
  final CollectionReference _fireStoreRef = FirebaseFirestore.instance.collection('bids');
  CollectionReference _chatRef;

  void setup(String inqId, int expertId){
    _chatRef = _fireStoreRef.doc("${inqId}_$expertId").collection('messages');
  }

  StreamSubscription<QuerySnapshot> conversationStream(Function onData){
    return _chatRef.orderBy('timestamp').snapshots().listen(onData);
  }

  Future<void> setUnread(InquiryModel model, int expertId, String bidId, int unread) async{
    FirebaseFirestore.instance
        .collection('bids')
        .doc(bidId)
        .update({"unread": unread});
    return FirebaseFirestore.instance
        .collection('inquiries')
        .doc(model.id)
        .update(model.setUnread(expertId));
  }

  Future<void> clearUnread(InquiryModel model, int expertId) async{
    return FirebaseFirestore.instance
        .collection('inquiries')
        .doc(model.id)
        .update(model.clearUnread(expertId));
  }

  Future<void> send(MessageModel message)async{
    message.timestamp = Timestamp.now();
    Future<void> snapshot = _chatRef
        .add(message.toMap());
    return snapshot;
  }

  Future<String> uploadImage(File image)async{
    final StorageReference fireStorage = FirebaseStorage.instance.ref();
    String imageName = image.path.split('/').last;

    final StorageUploadTask task = fireStorage.child('chatImage/$imageName').putFile(image);
    StorageTaskSnapshot  storageTaskSnapshot = await task.onComplete;
    String url = await storageTaskSnapshot.ref.getDownloadURL();
    return url;
  }

  Future<String> uploadLocation(Image location) async{
    final StorageReference fireStorage = FirebaseStorage.instance.ref();
    final StorageUploadTask task = fireStorage.child(
        'locationImage/' + DateTime.now().millisecondsSinceEpoch.toString())
        .putData(encodePng(location));
    var storageTaskSnapshot = await task.onComplete;
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future notifyUser(String userDeviceId, {String description, String attachment}) async
  {
    String url = 'https://fcm.googleapis.com/fcm/send';
    var header = {
      "Content-Type": "application/json",
      "Authorization": notificationAuthKey
    };

    String body = jsonEncode({
      "to" : userDeviceId,
      "notification" : {
        "body" : "Tienes mensajes no leídos",
        "title": "Mensaje no leído",
        "image": attachment
      },
      "data" : {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "type": "unread_message",
        "body": description,
        "source": "inquiry"
      }});

    try
    {
      Response response = await post(url, headers: header, body: body)
          .timeout(Duration(seconds: 15));
      return jsonDecode(response.body);
    }
    catch (e)
    {
      print(e);
      return null;
    }
  }
}