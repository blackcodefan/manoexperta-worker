import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/ui/Components/index.dart';
import 'package:workerf/ui/style.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';

class Terminate extends StatefulWidget{
  _Terminate createState() => _Terminate();
}

class _Terminate extends State<Terminate>{

  void _complete(_Props props) async{
    UserModel user = props.authState.user;
    ProjectDetailModel detail = props.detailState.detail;
    await props.finish(user.token, user.activeProject, detail.location, "1");
    if(props.detailState.error == null || props.detailState.error['errorcode'] == "closed"){
      user.activeProject = 0;
      props.updateStore(user);
      Navigator.pushNamedAndRemoveUntil(context, '/map', (route) => false);
    }else{
      CToast.error(props.detailState.error['errormsg']);
    }
  }

  void _noClient(_Props props) async{
    UserModel user = props.authState.user;
    if(user.activeProject == 0) return;
    ProjectDetailModel detail = props.detailState.detail;
    await props.finish(user.token, user.activeProject, detail.location, "2");
    if(props.detailState.error == null || props.detailState.error['errorcode'] == "closed"){
      user.activeProject = 0;
      props.updateStore(user);
      Navigator.pushNamedAndRemoveUntil(context, '/map', (route) => false);
    }else{
      CToast.error(props.detailState.error['errormsg']);
    }
  }

  void _cancel(_Props props) async{
    UserModel user = props.authState.user;
    if(user.activeProject == 0) return;
    ProjectDetailModel detail = props.detailState.detail;
    await props.finish(user.token, user.activeProject, detail.location, "3");
    if(props.detailState.error == null || props.detailState.error['errorcode'] == "closed"){
      user.activeProject = 0;
      props.updateStore(user);
      Navigator.pushNamedAndRemoveUntil(context, '/map', (route) => false);
    }else{
      CToast.error(props.detailState.error['errormsg']);
    }
  }

  @override
  Widget build(BuildContext context) {

    //final Size screenSize = MediaQuery.of(context).size;

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
                                'Terminar',
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
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '¿Qué sigue?',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                                Text('A partir de este punto el contacto es directo entre cliente y experto. ¡Mucho éxito!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Image(
                                    image: AssetImage('assets/img/handshake.png'),
                                    width: 200),
                                Text(
                                  '¿En qué quedaron?',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                    child: Column(
                                        children: [
                                          BigButton(
                                              labelText: 'Contacté al cliente',
                                              start: Color(0xFF5033DC),
                                              end: Color(0XFF7E30DA),
                                              onTap: ()=>_complete(props)),
                                          BigButton(
                                              labelText: 'El cliente no existia',
                                              start: Color(0xFFF25F5C),
                                              end: Color(0XFFF25F5C),
                                              onTap: ()=> _noClient(props)),
                                          BigButton(
                                              labelText: 'Tuve que cancelar',
                                              start: Color(0xFFF25F5C),
                                              end: Color(0XFFF25F5C),
                                              onTap: ()=> _cancel(props)
                                          )]))]),
                        )),
                    Positioned(
                        top: 0, left: 0,
                        child: props.detailState.loading?FullScreenLoader():Container())
                  ]
                )));
      }
    );
  }
}

class _Props{
  final AuthState authState;
  final DetailState detailState;
  final Function updateStore;
  final Function fetch;
  final Function finish;
  _Props({this.authState, this.detailState, this.updateStore, this.fetch, this.finish});

  static _Props mapStateToProps(Store<AppState> store){
    return _Props(
        authState: store.state.authState,
        detailState: store.state.detailState,
        updateStore: (UserModel user) => store.dispatch(updateUser(user)),
        finish: (String token, int reqId, LatLng location, String finishCode) => store.dispatch(finishDetail(token, reqId, location, finishCode))
    );
  }
}