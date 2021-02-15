// UI packages
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:workerf/global/index.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/provider/index.dart';
import 'package:workerf/redux/actions/LocalStorageAction.dart';
import 'package:workerf/redux/state/AuthState.dart';
import 'package:workerf/ui/Components/index.dart';
import 'style.dart';
import 'package:workerf/ui/style.dart';

// Logic packages
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';

class Login extends StatefulWidget{
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>{
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _navigate(UserModel user){

    if(!user.active){
      Navigator.pushNamedAndRemoveUntil(context, '/support', (route) => false);
    }else if(user.categories.length < 1){
      Navigator.pushNamedAndRemoveUntil(context, '/category', (route) => false);
    }else if(user.activeProject != 0){
      Navigator.pushNamedAndRemoveUntil(context, '/progress', (route) => false);
    }else{
      Navigator.pushNamedAndRemoveUntil(context, '/map', (route) => false);
    }
  }

  void _submit(BuildContext context, Props props)async{
    if(_formKey.currentState.validate()){
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      await props.authenticate(email, password);
      if(props.authState.error == null){

        await props.save(email, password);
        await props.getProfile(props.authState.user.token);
        eSocket.socketConfig();

        UserModel user = props.authState.user;

        if(props.authState.error == null){

          if(!props.authState.user.isExistDevice()){
            user.addDevice();
            props.addDevice(user);
            await props.getNotification(user.token);
          }

        }else if(props.authState.error == 'profile'){
          await props.initProfile(props.authState.user.token);
          await props.getProfile(props.authState.user.token);
          user = props.authState.user;
          user.addDevice();
          props.addDevice(user);
          await props.getNotification(user.token);
        }
        _navigate(user);

      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;

    return StoreConnector<AppState, Props>(
      converter: (store) => Props.mapStateToProps(store),
      builder: (context, props){
        AuthState authState = props.authState;
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
                                'Inicio de sesión',
                                style: appbarTitle),
                            elevation: 0.0,
                            backgroundColor: Colors.transparent,
                            leading: IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                onPressed: () =>Navigator.pop(context))),
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
                                    constraints: BoxConstraints(minHeight: screenSize.height * 0.8),
                                    child: Form(
                                        key: _formKey,
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.symmetric(vertical: 60),
                                                  child: Text('Ingresa tus datos', style: title)),
                                              Container(
                                                  child: Column(
                                                    children: [
                                                      TextInputField(
                                                          labelText: 'Email',
                                                          controller: _emailController,
                                                          validator: TextInputField.emailValidator),
                                                      PasswordInputField(
                                                          labelText: 'Contraseña',
                                                          validator: PasswordInputField.passwordValidator,
                                                          controller: _passwordController),
                                                      Container(
                                                        child: authState.error != null
                                                            ?Text(authState.error, style: TextStyle(color: Colors.red, fontSize: 12))
                                                            :Container()),
                                                      BigButton(
                                                          labelText: 'Iniciar sesion',
                                                          start: Color(0xFF5033DC),
                                                          end: Color(0XFF7E30DA),
                                                          onTap: () => _submit(context, props)),
                                                      SizedBox(
                                                          width: double.infinity,
                                                          child: Container(
                                                              padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                                                              child: RichText(
                                                                  textAlign: TextAlign.center,
                                                                  text: TextSpan(
                                                                      text: 'Olvidé mi contraseña',
                                                                      style: TextStyle(color: Color(0xFF7F30DA)),
                                                                      recognizer: TapGestureRecognizer()..onTap = ()=>Navigator.pushNamed(context, '/recoverPwd'))
                                                              )))],
                                                  ))
                                            ]))
                                ))
                        )),
                    Positioned(
                        top: 0, left: 0,
                        child: authState.loading?FullScreenLoader():Container())],
                )));
      }
    );
  }

}

class Props{
  final Function authenticate;
  final Function getProfile;
  final Function save;
  final Function initProfile;
  final Function getNotification;
  final Function addDevice;
  final AuthState authState;

  Props({this.authenticate,
    this.getProfile,
    this.save,
    this.initProfile,
    this.getNotification,
    this.addDevice,
    this.authState});

  static Props mapStateToProps(Store<AppState> store){
    return Props(
      authState: store.state.authState,
      authenticate: (String email, String password) => store.dispatch(logInAction(email, password)),
      getProfile: (String token) => store.dispatch(getProfileAction(token)),
      save: (String email, String password) => store.dispatch(setCredential(email, password)),
      getNotification: (String token) => store.dispatch(updateProfile(token)),
      addDevice: (UserModel user) => store.dispatch(updateUser(user)),
      initProfile: (String token) => store.dispatch(initWorker(token)),
    );
  }
}