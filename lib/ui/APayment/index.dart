import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workerf/global/index.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/provider/index.dart';
import 'package:workerf/ui/Components/custom_dropdown_button.dart';
import 'package:workerf/ui/Components/index.dart';
import 'Input.dart';
import 'package:workerf/ui/style.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';


class APayment extends StatefulWidget{
  _APayment createState() => _APayment();
}

class _APayment extends State<APayment>{
  ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _cardNumberController = MaskedTextController(mask: '0000000000000000000000000');

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

  File _img;
  String _bank;

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
        _img = croppedImage;
      });
    }else{
      setState(() {
        _img = null;
      });
    }
  }

  void _update(_Props props) async{
    String cardNumber = _cardNumberController.text.trim();
    if(cardNumber.isEmpty) {
      CToast.info('Se requiere el número de tarjeta');
      return;
    }

    UserModel user = props.authState.user;
    String url;
    if(_img != null){
      DateTime date = DateTime.now();
      String uniqueName = 'BankNumber_USERID_${user.userId}_${date.year}_${date.month}_${date.day}_${date.hour}_${date.minute}_${date.second}';
      _load();
      url = await GServiceProvider.uploadImage(_img, 'bankAcct', uniqueName: uniqueName);
      _loaded();
      user.bankCardImg = url;
    }else if(user.bankCardImg != null && user.bankCardImg.isNotEmpty){
      url = user.bankCardImg;
    }else return;

    await props.update(user.token, url, cardNumber, _bank);

    user.bankCardNumber = cardNumber;
    user.bankId = _bank;
    await props.updateStore(user);
    Navigator.pop(context);
  }

  void _init(_Props props){
      setState(() {
        props.authState.user.bankId.isNotEmpty?
      _bank = props.authState.user.bankId:_bank = globalMarket.banks[0].id;
    });

    UserModel user = props.authState.user;
    _cardNumberController.text = user.bankCardNumber;
  }

  List<DropdownMenuItem> dropdownItems(){
    List<DropdownMenuItem> _items = [];
    globalMarket.banks.forEach((bank) {
      _items.add(DropdownMenuItem(
        value: bank.id,
        child: Text(bank.name, overflow: TextOverflow.ellipsis),
      ));
    });
    return _items;
  }

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;

    return StoreConnector<AppState, _Props>(
      onInitialBuild: (props) => _init(props),
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
                                'Datos bancarios',
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
                            padding: EdgeInsets.all(20),
                            child: SingleChildScrollView(
                                child: Container(
                                  height: screenSize.height * 0.82,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Para recibir tus pagos es necesario asociar una cuenta bancaria, Estta cuenta debe de estar registrada a tu nombre',
                                            style: TextStyle(fontSize: 15, color: Color(0xFF745CE3), fontWeight: FontWeight.bold)),
                                        CustomDropdownButton(
                                            value: _bank,
                                            width: 250,
                                            items: dropdownItems(),
                                            onChanged: (value) =>setState((){_bank = value;}),
                                            style: TextStyle(color: Color(0xFF444444))),
                                        Text('Ingresa tu cuenta CLABE(18 numeros)', style: TextStyle(fontSize: 16)),
                                        Container(
                                            child: CardNumberInput(controller: _cardNumberController)),
                                        Text('Sube tu estado de cuenta. Es importante que tu nombre y numero de cuenta sean visibles', style: TextStyle(fontSize: 16)),
                                        Container(
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            child: _img != null
                                                ?Image.file(_img, width: 150)
                                                :user.bankCardImg.isNotEmpty
                                                ?FadeInImage.assetNetwork(placeholder: 'assets/img/spinner-sm.gif', image: user.bankCardImg, width: 150)
                                                :Image.asset('assets/img/id.png')),
                                        Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            child: Row(
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
                                                GestureDetector(
                                                    onTap: () => _pickImage(ImageSource.camera),
                                                    child: Container(
                                                        child: Icon(Icons.camera_alt, size: 50),
                                                        width: 60,
                                                        height: 60,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            color: Color(0xFFD9D9D9)
                                                        )))
                                              ],
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            )),
                                        BigButton(
                                          labelText: 'Enviar',
                                          start: Color(0xFF5033DC),
                                          end: Color(0XFF7E30DA),
                                          onTap: () => _update(props),
                                        )]),
                                ))
                        )),
                    Positioned(
                        top: 0, left: 0,
                        child: _loading || props.authState.loading?FullScreenLoader():Container())
                  ],
                )));
      }
    );
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
        update: (String token, String bankDocUrl, String bankNumber, String bankId) => store.dispatch(updateProfile(token, expertBankDocUrl: bankDocUrl, bankCode: bankNumber, bankId: bankId)));
  }
}