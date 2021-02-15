import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:workerf/ui/Components/index.dart';
import 'package:workerf/ui/style.dart';

import 'package:workerf/redux/index.dart';
import 'package:redux/redux.dart';

class RecoverPwd extends StatefulWidget{
  _RecoverPwd createState() => _RecoverPwd();
}

class _RecoverPwd extends State<RecoverPwd>{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  
  void _submit(_Props props) async{
    if(_formKey.currentState.validate()){
      String email = _emailController.text.trim();
      await props.recover(email);
      if(props.authState.error == null){
        CToast.info('Por favor revise su correo electrónico.');
        Navigator.pop(context);
      }else{
        CToast.warning(props.authState.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

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
                                'Recuperar tu contraseña',
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
                                  padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.1),
                                  constraints: BoxConstraints(minHeight: screenSize.height * 0.8),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(top: 50, bottom: 30),
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Image(
                                                  image: AssetImage('assets/img/forgetpassword.png'),
                                                  width: screenSize.width * 0.6,
                                                ))),
                                        Text(
                                            'Ingresa tu e-mail',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold
                                            ),
                                            textAlign: TextAlign.center),
                                        Form(
                                            key: _formKey,
                                            child: TextInputField(
                                                labelText: 'E-mail',
                                                validator: TextInputField.emailValidator,
                                                controller: _emailController)),
                                        BigButton(
                                            labelText: 'Recuperar',
                                            start: Color(0xFF5033DC),
                                            end: Color(0XFF7E30DA),
                                            onTap: () => _submit(props))])
                              )),
                        )),
                    Positioned(
                        top: 0, left: 0,
                        child: props.authState.loading?FullScreenLoader():Container())
                  ]
                )));
      }
    );
  }
}

class _Props{
  final AuthState authState;
  final Function recover;
  _Props({this.authState, this.recover});

  static _Props mapStateToProps(Store<AppState> store){
    return _Props(
        authState: store.state.authState,
        recover: (String email) => store.dispatch(recoverPwd(email))
    );
  }
}