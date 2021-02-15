import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:workerf/ui/Components/index.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workerf/repository/index.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/provider/index.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:image/image.dart' as ImgPkg;
import 'package:marquee_widget/marquee_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'MessageInput.dart';

class HConversation extends StatefulWidget
{
  final ConversationModel model;

  HConversation(this.model);

  _HConversation createState() => _HConversation();
}

class _HConversation extends State<HConversation>
{
  ConversationProvider _provider = ConversationProvider();
  final _inputController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  StreamSubscription<QuerySnapshot> _controller;
  List<DocumentSnapshot> _messages = [];
  MessageRepository _repository = MessageRepository([]);

  @override
  void initState() {
    super.initState();
    _provider.setup(widget.model);
    _controller = _provider.conversationStream(_streamListener);
  }

  void _streamListener(QuerySnapshot snapshot){
    List<DocumentChange> documentChanges = snapshot.docChanges;

    documentChanges.forEach((element) {
      if(element.type == DocumentChangeType.removed){
        _messages.removeWhere((message) {
          return element.doc.id == message.id;
        });
      }
      else if(element.type == DocumentChangeType.added){
        _messages.add(element.doc);
      }
      else{
        int indexWhere = _messages.indexWhere((product) {
          return element.doc.id == product.id;
        });
        if (indexWhere >= 0) {
          _messages[indexWhere] = element.doc;
        }
      }
    });

    setState(() {
      _repository = MessageRepository.fromList(_messages);
    });
  }

  void _onTap(){
    CToast.info("No puedes enviar mensajes a este usuario");
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0xFF7F30DA),
                      Color(0xFF6732DB)],
                    stops: [0.05, 0.3])),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/img/spinner-sm.gif',
                        image: widget.model.clientAvatar,
                        width: 50,
                        height: 50,
                        fit: BoxFit.fill)),
                    Padding(
                      padding: EdgeInsets.only(right: 20)),
                    Text(
                      widget.model.clientName,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]),
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: ()=> Navigator.pop(context))),
              body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        itemCount: _repository.messages.length,
                          itemBuilder: (context, int index){

                          MessageModel model = _repository.messages[index];
                          return model.type == "text"
                              ?TextMessage(model: model)
                              :model.type == "file"
                              ?ImageMessage(model: model)
                              :LocationMessage(model: model);
                          })),
                    MessageInput(
                      controller: _inputController,
                      call: _onTap,
                      sendMessage: _onTap,
                      sendImage: _onTap,
                      sendLocation: _onTap)]
                ))
            )));
  }

  @override
  void dispose() {
    _controller?.cancel();
    super.dispose();
  }
}

class TextMessage extends StatelessWidget{
  final MessageModel model;
  TextMessage({
    @required this.model
  }):assert(
  model != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 250),
      child: Bubble(
        color: model.owner == 'client'?Colors.white:Color(0xFF7C2EDA),
        margin: BubbleEdges.only(top: 10),
        alignment: model.owner == 'client'?Alignment.topLeft:Alignment.topRight,
        nip: model.owner == 'client'?BubbleNip.leftTop:BubbleNip.rightTop,
        child: Text(model.content,
        style: TextStyle(color: model.owner == 'client'?Colors.black:Colors.white))),
    );
  }
}

class ImageMessage extends StatelessWidget{
  final MessageModel model;
  ImageMessage({
    @required this.model
  }):assert(
  model != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/imageViewer', arguments: model.url),
      child: Bubble(
        margin: BubbleEdges.only(top: 10),
        color: model.owner == 'client'?Colors.white:Color(0xFF7C2EDA),
        alignment: model.owner == 'client'?Alignment.topLeft:Alignment.topRight,
        nip: model.owner == 'client'?BubbleNip.leftTop:BubbleNip.rightTop,
        child: Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Column(
            children: [
              model.url == null?
              Image.file(model.file)
                  :FadeInImage.assetNetwork(
                  placeholder: 'assets/img/spinner-sm.gif',
                  image: model.url),
              Text(model.content,
                  style: TextStyle(color: model.owner == 'client'?Colors.black:Colors.white))
            ])
        )),
    );
  }
}

class LocationMessage extends StatelessWidget{
  final MessageModel model;
  LocationMessage({
    @required this.model
  }):assert(
  model != null);

  Future<void> goToLocation() async{
    String url = 'geo:${model.location.latitude},${model.location.longitude}';
    if (Platform.isIOS) {
      url = 'http://maps.apple.com/?ll=${model.location.latitude},${model.location.longitude}';
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      CToast.warning("lo siento, no se puede mostrar la ubicación");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: goToLocation,
      child: Bubble(
          color: model.owner == 'client'?Colors.white:Color(0xFF7C2EDA),
          margin: BubbleEdges.only(top: 10),
          alignment: model.owner == 'client'?Alignment.topLeft:Alignment.topRight,
          nip: model.owner == 'client'?BubbleNip.leftTop:BubbleNip.rightTop,
          child: Container(
            constraints: BoxConstraints(maxWidth: 200),
            child: Column(
                children: [
                  model.url == null?
                  Image.memory(Uint8List.fromList(model.memory))
                      :FadeInImage.assetNetwork(
                      placeholder: 'assets/img/spinner-sm.gif',
                      image: model.url),
                  Text(model.content,
                      style: TextStyle(color: model.owner == 'client'?Colors.black:Colors.white))
                ]),
          )),
    );
  }
}

class FilePreview extends StatelessWidget{
  final File file;

  FilePreview(this.file);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 300, maxHeight: 200),
            child: Image.file(file, fit: BoxFit.fill)),
        Container(
            child: Marquee(child: Text(file.path))),
      ],
    );
  }
}

class LocationPreview extends StatelessWidget{
  final LocationModel location;

  LocationPreview(this.location);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            constraints: BoxConstraints(maxWidth: 300, maxHeight: 200),
            child: Image.memory(ImgPkg.encodePng(location.image), fit: BoxFit.fill)),
        Container(
            child: Marquee(child: Text(location.address.addressLine))),
      ],
    );
  }
}