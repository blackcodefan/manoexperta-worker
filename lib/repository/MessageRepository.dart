import 'package:workerf/model/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepository{
  List<MessageModel> messages;

  MessageRepository(this.messages);

  factory MessageRepository.fromList(List<DocumentSnapshot> snapshots){
    List<MessageModel> _messages = [];
    snapshots.forEach((snapshot) {
      _messages.insert(0, MessageModel.fromMap(snapshot));
    });

    return MessageRepository(_messages);
  }
}