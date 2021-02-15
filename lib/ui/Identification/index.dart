import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/provider/index.dart';
import 'package:workerf/ui/Components/index.dart';
import 'package:workerf/ui/style.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';

class Identification extends StatefulWidget{
  _Identification createState() => _Identification();
}

class _Identification extends State<Identification>{
  ImagePicker _imagePicker = ImagePicker();
  File _img, _img2;
  bool _front = true;

  bool _loading = false;

  void _load() {
    setState(() {
      _loading = true;
    });
  }

  void _loaded() {
    setState(() {
      _loading = false;
    });
  }

  void _pickImage(ImageSource source) async{
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
      setState(() {
        _front?_img = croppedImage:_img2 = croppedImage;
      });
    }else{
      setState(() {
        _front?_img = null:_img2 = null;
      });
    }
  }

  void _upload(_Props props) async{
    if(_img == null || _img2 == null) return;
    UserModel user = props.authState.user;

    DateTime date = DateTime.now();
    String uniqueName = 'USERID_${user.userId}_${date.year}_${date.month}_${date.day}_${date.hour}_${date.minute}_${date.second}';
    String name2 = uniqueName + '_back';

    _load();
    String url = await GServiceProvider.uploadImage(_img, 'idImage', uniqueName: uniqueName);
    String url2 = await GServiceProvider.uploadImage(_img2, 'idImage', uniqueName: name2);
    _loaded();
    await props.update(user.token, url, url2);

    user.idUrl = url;
    user.idUrl2 = url2;
    await props.updateStore(user);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;

    return StoreConnector<AppState, _Props>(
      converter: (store) => _Props.mapStateToProps(store),
      builder: (context, props){
        UserModel user = props.authState.user;
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
                          Color(0xFF6732DB)
                        ],
                        stops: [0.05, 0.3]
                    )),
                child: Stack(
                  children: [
                    Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(
                            centerTitle: true,
                            title: Text(
                                'Carga una foto de tu CI',
                                style: appbarTitle),
                            elevation: 0.0,
                            backgroundColor: Colors.transparent,
                            leading: IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                onPressed: () => Navigator.pop(context))),
                        body: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30))),
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: SingleChildScrollView(
                                child: Container(
                                    constraints: BoxConstraints(minHeight: screenSize.height * 0.88),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              GestureDetector(
                                                onTap: () =>setState((){_front = true;}),
                                                child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        color: _front?Color(0xFF7E2EDA):Color(0xFFE5E5E5),
                                                        borderRadius: BorderRadius.circular(10)),
                                                    child: _img != null
                                                        ?Image.file(_img, width: 250)
                                                        :user.idUrl.isNotEmpty
                                                        ?FadeInImage.assetNetwork(placeholder: 'assets/img/spinner-sm.gif', image: user.idUrl, width: 250)
                                                        :Image.asset('assets/img/id.png'), width:  150)),
                                              GestureDetector(
                                                onTap: () =>setState((){_front = false;}),
                                                child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        color: _front?Color(0xFFE5E5E5):Color(0xFF7E2EDA),
                                                        borderRadius: BorderRadius.circular(10)),
                                                    child: _img2 != null
                                                        ?Image.file(_img2, width: 250)
                                                        :user.idUrl2.isNotEmpty
                                                        ?FadeInImage.assetNetwork(placeholder: 'assets/img/spinner-sm.gif', image: user.idUrl2, width: 250)
                                                        :Image.asset('assets/img/id.png'), width:  150))
                                            ]),
                                          Column(
                                              children: [
                                                Container(
                                                    padding:EdgeInsets.all(10),
                                                    child: Text('Elige una opción',
                                                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Column(
                                                          children: [
                                                            GestureDetector(
                                                                onTap: () => _pickImage(ImageSource.gallery),
                                                                child: Container(
                                                                    child: Icon(Icons.image, size: 50),
                                                                    width: 60,
                                                                    height: 60,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        color: Color(0xFFD9D9D9)
                                                                    ))),
                                                            Container(padding: EdgeInsets.all(5),child: Text('Galería'))
                                                          ]),
                                                      Column(
                                                          children: [
                                                            GestureDetector(
                                                                onTap: () => _pickImage(ImageSource.camera),
                                                                child: Container(
                                                                    child: Icon(Icons.camera_alt, size: 50),
                                                                    width: 60,
                                                                    height: 60,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        color: Color(0xFFD9D9D9)
                                                                    ))),
                                                            Container(
                                                                padding: EdgeInsets.all(5),
                                                                child: Text('Cámera'))
                                                          ]),
                                                    ]),
                                                BigButton(
                                                    labelText: 'Usar esta imagen',
                                                    start: Color(0xFF5033DC),
                                                    end: Color(0xFF7E30DA),
                                                    onTap: () => _upload(props))
                                              ])
                                        ])
                                ))
                        )),
                    Positioned(
                        top: 0, left: 0,
                        child: _loading || props.authState.loading?FullScreenLoader():Container())
                  ]
                )));
      });
  }
}

class _Props{
  final AuthState authState;
  final Function update;
  final Function updateStore;
  _Props({this.authState, this.update, this.updateStore});

  static _Props mapStateToProps(Store<AppState> store){
    return _Props(
        authState: store.state.authState,
        updateStore: (UserModel user) => store.dispatch(updateUser(user)),
        update: (String token, String docUrl, String docUrl2) => store.dispatch(updateProfile(token, docUrl: docUrl, docUrl2: docUrl2)));
  }
}