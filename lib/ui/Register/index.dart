import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workerf/global/index.dart';
import 'package:workerf/provider/index.dart';
import 'package:workerf/ui/Components/index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workerf/ui/style.dart';

import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';


class Register extends StatefulWidget{
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>{
  ImagePicker _imagePicker = ImagePicker();
  File img;
  bool _loading = false;

  final YYDialog _dialog = YYDialog();
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = MaskedTextController(mask: '+${globalMarket.callPrefix}-0000-000000', text: '+${globalMarket.callPrefix}');
  final _passwordController = TextEditingController();

  bool _acceptTAP = false;

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

  void _submit(_Props props)async{
    if(!_acceptTAP){
      CToast.warning('Debes aceptar los términos y condiciones');
      return;
    }
    if(_formKey.currentState.validate()){
      String firstName = _firstNameController.text.trim();
      String lastName = _lastNameController.text.trim();
      String mobile = _phoneController.text
          .replaceAll('-', '')
          .replaceAll('+1', '001')
          .replaceAll("+52", "052")
          .replaceAll("+591", "591");
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String avatar;
      if(img != null){
        _load();
        avatar = await GServiceProvider.uploadImage(img, 'profileImage');
        _loaded();
      }

      await props.signUp(avatar: avatar, email: email, firstName: firstName,
          lastName: lastName, mobile: mobile, password: password, marketHandle: globalMarket.marketHandle);
      if(props.authState.error == null){
        int userId = props.authState.user.userId;
        if(globalMarket.enrollAlert.isNotEmpty)
          CToast.info(globalMarket.enrollAlert);
        if(globalMarket.enrollOpen.isNotEmpty)
        launch('${globalMarket.enrollOpen}/?email=$email&userid=$userId');
        if(globalMarket.reference)
          Navigator.pushNamedAndRemoveUntil(context, '/friend', (route) => false, arguments: userId);
        else Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }else{
        CToast.warning(props.authState.error);
      }
    }
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
      setState(() {
        img = croppedImage;
      });
    }else{
      setState(() {
        img = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    final Size screenSize = MediaQuery.of(context).size;

    return StoreConnector<AppState, _Props>(
      converter: (store) => _Props.mapStateToProps(store),
      builder: (context, props){
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
                                  'Regístrate',
                                  style: appbarTitle),
                              elevation: 0.0,
                              backgroundColor: Colors.transparent,
                              leading: IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                onPressed: () => Navigator.pop(context),
                              )),
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
                                child: Form(
                                  key: _formKey,
                                  child: Container(
                                    constraints: BoxConstraints(minHeight: screenSize.height * 0.82),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Stack(
                                              alignment: Alignment.center,
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: ClipOval(
                                                        child: Image(
                                                            image: img == null ?AssetImage('assets/img/unknown.png'):FileImage(img),
                                                            width: 80,
                                                            height: 80,
                                                            fit: BoxFit.fill))),
                                                Positioned(
                                                    bottom: 0,
                                                    right: 0,
                                                    child: IconButton(
                                                        icon: Icon(Icons.camera_alt),
                                                        iconSize: 30,
                                                        color: Color(0xFF6E29BD),
                                                        onPressed: _openImgDialog
                                                    ))]),
                                          TextInputField(
                                              labelText: 'Nombre',
                                              validator: TextInputField.firstNameValidator,
                                              controller: _firstNameController),
                                          TextInputField(
                                              labelText: 'Apellido',
                                              validator: TextInputField.lastNameValidator,
                                              controller: _lastNameController),
                                          TextInputField(
                                              labelText: 'Email',
                                              validator: TextInputField.emailOptionalValidator,
                                              controller: _emailController),
                                          Container(
                                              padding: EdgeInsets.only(left: 5),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  'Para tu acceso y para recibir información de tus trabajos',
                                                  style: TextStyle(fontSize: 9))),
                                          TextInputField(
                                              labelText: 'Celular',
                                              validator: TextInputField.phoneValidator,
                                              controller: _phoneController),
                                          Container(
                                              padding: EdgeInsets.only(left: 5),
                                              alignment: Alignment.centerLeft,
                                              child: Text('Tu teléfono es necesario para contactar con el experto',
                                                  style: TextStyle(fontSize: 9))),
                                          PasswordInputField(
                                              labelText: 'Contraseña',
                                              validator: PasswordInputField.passwordOptionalValidator,
                                              controller: _passwordController),
                                          Container(
                                              padding: EdgeInsets.only(left: 5),
                                              alignment: Alignment.centerLeft,
                                              child: Text('La que gustes, es para ingresar a manoexperta',
                                                  style: TextStyle(fontSize: 9))),
                                          Container(
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Checkbox(
                                                        value: _acceptTAP,
                                                        onChanged: (bool accept)  => setState(() {_acceptTAP = accept;})),
                                                    RichText(
                                                        overflow: TextOverflow.ellipsis,
                                                        text: TextSpan(text: 'Acepto los ',
                                                            style: TextStyle(color: Colors.black, fontSize: 12),
                                                            children: <TextSpan>[
                                                              TextSpan(text: 'Términos, Condiciones',
                                                                  style: TextStyle(color: Colors.blue),
                                                                  recognizer: TapGestureRecognizer()..onTap = ()=> Navigator.pushNamed(context, '/tac', arguments: 'terms')),
                                                              TextSpan(text: ' y '),
                                                              TextSpan(text: 'Politica \nde Privacidad',
                                                                  style: TextStyle(color: Colors.blue),
                                                                  recognizer: TapGestureRecognizer()..onTap = ()=> Navigator.pushNamed(context, '/tac', arguments: 'privacy'))
                                                            ])
                                                    )
                                                  ])),
                                          BigButton(
                                              labelText: 'Siguiente',
                                              start: Color(0xFF5033DC),
                                              end: Color(0XFF7E30DA),
                                              onTap: () => _submit(props)),
                                        ]),
                                  ),
                                )),
                          )),
                      Positioned(
                          top: 0, left: 0,
                          child: _loading || props.authState.loading?FullScreenLoader():Container())
                    ]
                ))
        );
      }
    );
  }

  YYDialog _openImgDialog() {
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
}

class _Props{
  final AuthState authState;
  final Function signUp;
  _Props({this.authState,  this.signUp});

  static _Props mapStateToProps(Store<AppState> store){
    return _Props(
        authState: store.state.authState,
        signUp: ({
          String avatar,
          String email,
          String firstName,
          String lastName,
          String mobile,
          String password,
          String marketHandle
            }) => store.dispatch(
            register(
                avatar: avatar,
                email: email,
                firstName: firstName,
                lastName: lastName,
                mobile: mobile,
                password: password,
                marketHandle: marketHandle
            ))
    );
  }
}