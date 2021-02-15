import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workerf/global/index.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/provider/GServiceProvider.dart';
import 'package:workerf/ui/Components/index.dart';
import 'package:workerf/ui/style.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';

class Profile extends StatefulWidget{
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile>{
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

  bool _acceptPush = false, _acceptEmail = false, _allowDirectHire = false;

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

  void _fillForm(_Props props){
    UserModel user = props.authState.user;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _emailController.text = user.email;
    _phoneController.text = user.mobileFormat;
    _acceptPush = user.pushNotification;
    _acceptEmail = user.emailNotification;
    _allowDirectHire = user.allowDirectHire;
    setState(() {});
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

  void _submit(BuildContext context, _Props props)async{
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

      UserModel user = props.authState.user;

      await props.update(
          user.token,
          firstName: firstName,
          lastName: lastName,
          mobile: mobile,
          email: email,
          password: password,
          avatar: avatar,
          pushNotification: _acceptPush,
          emailNotification: _acceptEmail,
          allowDirectHire: _allowDirectHire
      );

      user.email = email;
      user.firstName = firstName;
      user.lastName = lastName;
      user.mobile = mobile;
      if(avatar != null){
        user.avatar = avatar;
      }
      user.pushNotification = _acceptPush;
      user.emailNotification = _acceptEmail;
      user.allowDirectHire = _allowDirectHire;

      await props.updateStore(user);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    final Size screenSize = MediaQuery.of(context).size;

    return StoreConnector<AppState, _Props>(
      onInitialBuild: (props) => _fillForm(props),
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
                                  'Actualizar perfil',
                                  style: appbarTitle),
                              elevation: 0.0,
                              backgroundColor: Colors.transparent),
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
                                                        child: FadeInImage(
                                                            placeholder: AssetImage('assets/img/unknown.png'),
                                                            image: img != null?FileImage(img):NetworkImage(user.avatar),
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
                                                        onPressed: _openImageDialog
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
                                              validator: TextInputField.emailValidator,
                                              controller: _emailController),
                                          Container(
                                              padding: EdgeInsets.only(left: 5),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  'Para tu acceso y para recibir información de tus trabajos',
                                                  style: TextStyle(fontSize: 9))),
                                          TextInputField(
                                              labelText: 'Celular',
                                              validator: TextInputField.phoneOptionalValidator,
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
                                          Row(
                                              children: <Widget>[
                                                Switch(
                                                    activeColor: Color(0xFF7632DA),
                                                    value: _acceptPush,
                                                    onChanged: (bool status) => setState(() {_acceptPush = status;})),
                                                Text('Recibir Notificaciones Push')
                                              ]),
                                          Row(
                                              children: <Widget>[
                                                Switch(
                                                    activeColor: Color(0xFF7632DA),
                                                    value: _acceptEmail,
                                                    onChanged: (bool status)=> setState(() { _acceptEmail = status;})),
                                                Text('Recibir Correos Electrónicos')
                                              ]),
                                          Row(
                                              children: <Widget>[
                                                Switch(
                                                    activeColor: Color(0xFF7632DA),
                                                    value: _allowDirectHire,
                                                    onChanged: (bool status)=> setState(() { _allowDirectHire = status;})),
                                                Text('Permitir contratación directa')
                                              ]),
                                          BigButton(
                                              labelText: 'Actualizar',
                                              start: Color(0xFF5033DC),
                                              end: Color(0XFF7E30DA),
                                              onTap: () => _submit(context, props)),
                                          GestureDetector(
                                              onTap: () => Navigator.pushNamed(context, '/pMarket'),
                                              child: Text('Reiniciar el Mercado',
                                                  style: TextStyle(
                                                      color: Color(0xFF5032DC),
                                                      fontWeight: FontWeight.bold,
                                                      decoration: TextDecoration.underline))),
                                          Divider(thickness: 10, color: Colors.transparent),
                                        ]))
                                ))
                          )),
                      Positioned(
                          top: 0, left: 0,
                          child: _loading || props.authState.loading?FullScreenLoader():Container())
                    ])));
      });
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
        update: (String token,
          {
            String email,
            String firstName,
            String lastName,
            String mobile,
            String password,
            bool pushNotification,
            bool emailNotification,
            String avatar,
            bool allowDirectHire
          }) => store.dispatch(
          updateProfile(
              token,
              email: email,
              firstName: firstName,
              lastName: lastName,
              mobile: mobile,
              password: password,
              expertAvatar: avatar,
              notification: pushNotification,
              getEmail: emailNotification,
              allowDirectHire: allowDirectHire
          ))
    );
  }
}