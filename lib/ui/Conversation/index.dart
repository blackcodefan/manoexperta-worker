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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image/image.dart' as ImgPkg;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'MessageInput.dart';

class Conversation extends StatefulWidget
{
  final ConversationModel model;

  Conversation(this.model);

  _Conversation createState() => _Conversation();
}

class _Conversation extends State<Conversation>
{
  ConversationProvider _provider = ConversationProvider();
  ImagePicker _imagePicker = ImagePicker();
  final YYDialog _dialog = YYDialog();
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
      }else if(element.type == DocumentChangeType.added){
        _messages.add(element.doc);

      }else{
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

  void _call() async
  {
    if (await canLaunch('tel:${widget.model.clientMobile}'))
      launch('tel:${widget.model.clientMobile}');
    else
      print('No disponible');
  }

  void _sendText() async{
    String text = _inputController.text.trim();
    if(text.isEmpty) return;
    MessageModel message = MessageModel(
      owner: "expert",
      type: "text",
      content: text,
        delivered: false);

    _repository.messages.insert(0, message);
    setState(() { });
    _inputController.text = "";
    _scroll();
    await _provider.send(message);
    await _provider.notifyUser(
        widget.model.clientDevices,
        widget.model.id,
        description: text);
  }

  void _sendImage(File image)async{
    Navigator.pop(context);
    String imageName = image.path.split('/').last;
    MessageModel message = MessageModel(
      owner: "expert",
      type: "file",
      content: imageName,
      delivered: false,
      file: image
    );

    _repository.messages.insert(0, message);
    setState(() { });
    _scroll();
    try{
      String url = await _provider.uploadImage(image);
      message.url = url;
      await _provider.send(message);
      await _provider.notifyUser(
          widget.model.clientDevices,
          widget.model.id,
          attachment: url);
    }catch(e){
      print(e);
    }
  }

  void _sendLocation(LocationModel location) async{
    Navigator.pop(context);
    MessageModel message = MessageModel(
        owner: "expert",
        type: "location",
        content: location.address.addressLine,
        delivered: false,
        location: GeoPoint(location.address.coordinates.latitude, location.address.coordinates.longitude),
        memory: ImgPkg.encodePng(location.image)
    );

    _repository.messages.insert(0, message);
    setState(() { });
    _scroll();
    try{
      String url = await _provider.uploadLocation(location.image);
      message.url = url;
      await _provider.send(message);
      await _provider.notifyUser(
          widget.model.clientDevices,
          widget.model.id,
          description: location.address.addressLine,
          attachment: url);

    }catch(e){
      print(e);
    }
  }

  void _scroll(){
    _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut);
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
                        fit: BoxFit.fill,
                      )),
                    Padding(
                      padding: EdgeInsets.only(right: 20)),
                    Text(
                      widget.model.clientName,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )]),
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: ()=> Navigator.pop(context),
                )),
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
                      call: _call,
                      sendMessage: _sendText,
                      sendImage: _openImageDialog,
                      sendLocation: _pickLocation,
                    )]
                ))
            )));
  }

  void _pickImage(ImageSource source) async{
    _dialog?.dismiss();
    PickedFile image = await _imagePicker.getImage(source: source);
    if(image != null){
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          compressFormat: ImageCompressFormat.jpg,
          maxWidth: 500,
          maxHeight: 500,
          androidUiSettings: AndroidUiSettings(
              toolbarColor: Color(0xFF7C2EDA),
              toolbarTitle: "Recorte de imagen",
              toolbarWidgetColor: Colors.white,
              statusBarColor: Color(0xFF7C2EDA),
              backgroundColor: Colors.white,
              activeControlsWidgetColor: Color(0xFF7C2EDA)
          ));
      _fileSendConfirmDialog(croppedImage);
    }
  }

  YYDialog _openImageDialog() {
    return _dialog.build(context)
      ..gravity = Gravity.bottom
      ..gravityAnimationEnable = true
      ..backgroundColor = Colors.transparent
      ..barrierDismissible = true
      ..dismissCallBack = () {_dialog.widgetList = [];}
      ..widget(Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 120,
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: FlatButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: FaIcon(FontAwesomeIcons.image, color: Color(0xFF5433DC))),
                ),
                Container(
                  width: 120,
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: FlatButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      child: FaIcon(FontAwesomeIcons.cameraRetro, color: Color(0xFF5433DC))),
                ),
              ])))
      ..show();
  }

  void _fileSendConfirmDialog(File file){
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled:false,
        backgroundColor: Colors.transparent,
        builder: (BuildContext _context){
          return Container(
              height: 400,
              padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FilePreview(file),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FlatButton(
                                color: Color(0xFFFF817F),
                                textColor: Colors.white,
                                child: Text('Cancel'),
                                onPressed: () =>Navigator.pop(context)),
                            FlatButton(
                                color: Colors.green,
                                textColor: Colors.white,
                                child: Text('Ok'),
                                onPressed: () => _sendImage(file))
                          ]),
                    )
                  ]));
        });
  }

  void _locationSendConfirmDialog(LocationModel location){
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled:false,
        backgroundColor: Colors.transparent,
        builder: (BuildContext _context){
          return Container(
              height: 400,
              padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    LocationPreview(location),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FlatButton(
                                color: Color(0xFFFF817F),
                                textColor: Colors.white,
                                child: Text('Cancel'),
                                onPressed: () =>Navigator.pop(context)),
                            FlatButton(
                                color: Colors.green,
                                textColor: Colors.white,
                                child: Text('Ok'),
                                onPressed: () => _sendLocation(location))
                          ]),
                    )
                  ]));
        });
  }

  void _pickLocation() async{
    var result = await Navigator.pushNamed(context, '/locationPicker');
    LocationModel location = result;
    if(location != null){
      _locationSendConfirmDialog(location);
    }
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