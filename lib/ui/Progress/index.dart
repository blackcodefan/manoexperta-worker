import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workerf/global/index.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/provider/index.dart';
import 'package:workerf/ui/Components/index.dart';
import 'BadgeButton.dart';
import 'package:workerf/ui/style.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';

class Progress extends StatefulWidget{
  _Progress createState() => _Progress();
}

class _Progress extends State<Progress>{
  final YYDialog _dialog = YYDialog();
  GoogleMapController _controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  int _unread = 0;

  void _onMapCreate(controller){
    setState(() {
      _controller = controller;
    });
  }

  void _fetch(_Props props)async{
    await props.fetch(props.authState.user.token, props.authState.user.activeProject);
    _setCameraAndMarker(props.detailState.detail.location, props.detailState.detail.workerLocation);
  }

  void _setCameraAndMarker(LatLng position, LatLng expert){
        _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14)));

    markers[MarkerId('project')] =Marker(
        markerId: MarkerId('project'),
        draggable: false,
        position: LatLng(position.latitude, position.longitude));

        markers[MarkerId('expert')] =Marker(
            markerId: MarkerId('expert'),
            draggable: false,
            position: LatLng(expert.latitude, expert.longitude));

    setState(() { });
  }

  void _iSocketListener(InternalSocketArgs args){
    if(!mounted) return;
    if(args.type == InternalSocketT.locationUpdate)
      setState(() {
        markers[MarkerId('expert')] =Marker(
            markerId: MarkerId('expert'),
            draggable: false,
            position: LatLng(args.data.latitude, args.data.longitude));
      });
    else if(args.type == InternalSocketT.complete){
      _finishDialog(_onCompleteConfirm, labelText: "Proyecto completado por el cliente");
    }else if(args.type == InternalSocketT.cancel){
      _finishDialog(_onCancelConfirm, labelText: "Proyecto cancelado por el cliente");
    }else if(args.type == InternalSocketT.notification && args.data['reqid'] == currentUser.activeProject.toString()){
      setState(() {
        _unread ++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    iSocket.socket.subscribe(_iSocketListener);
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    //final Size screenSize = MediaQuery.of(context).size;

    return StoreConnector<AppState, _Props>(
      onInitialBuild: (props) => _fetch(props),
      converter: (store) => _Props.mapStateToProps(store),
      builder: (context, props){
        ProjectDetailModel _detail = props.detailState.detail;

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
                                'Trabajo aceptado',
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
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    _detail.description,
                                    style: TextStyle(color: Colors.black)),
                                Padding(
                                  padding: EdgeInsets.only(bottom:2, top: 2),
                                  child: Text(
                                    'Datos de contacto',
                                    style: TextStyle(color: Color(0xFF7A30DA)),
                                    textAlign: TextAlign.left
                                  )),
                                Text(_detail.address),
                                Padding(
                                  padding: EdgeInsets.only(top:3, bottom: 3),
                                  child: Text(
                                    'Dirigite al trabajo. Ya te esperan',
                                    style: TextStyle(color: Color(0xFF1B998B), fontWeight: FontWeight.bold),
                                  )),
                                Expanded(
                                    child: GoogleMap(
                                      onMapCreated: _onMapCreate,
                                        markers: Set<Marker>.of(markers.values),
                                      initialCameraPosition: CameraPosition(
                                          target: _detail.location,
                                          zoom: 8),
                                      onTap: (value) =>print(value)
                                    )),
                                BadgeButton(
                                    labelText: 'Chatear con ${_detail.clientFName}',
                                    start: Color(0xFF5033DC),
                                    end: Color(0XFF7E30DA),
                                    msgCount: _unread,
                                    onTap: () =>_toConversation(props)),
                                BigButton(
                                  labelText: 'Terminar',
                                  start: Color(0xFF1B998B),
                                  end: Color(0XFF1B998B),
                                  onTap: ()=> Navigator.pushNamed(context, '/terminate'),
                                )])
                        )),
                    Positioned(
                        top: 0, left: 0,
                        child: props.detailState.loading?FullScreenLoader():Container())
                  ]
                )));
      });
  }

  void _toConversation(_Props props){
    ConversationModel model = ConversationModel.fromProjectDetail(
        "project",
        currentUser.activeProject,
        props.detailState.detail);
    setState(() {
      _unread = 0;
    });
    Navigator.pushNamed(context, '/conversation', arguments: model);
  }

  void _onCompleteConfirm(){
    _dialog.dismiss();
    UserModel user = store.state.authState.user;
    user.activeProject = 0;
    store.dispatch(updateUser(user));
    Navigator.pushNamed(context, '/terminate');
  }

  void _onCancelConfirm(){
    _dialog.dismiss();
    UserModel user = store.state.authState.user;
    user.activeProject = 0;
    store.dispatch(updateUser(user));
    Navigator.pushNamedAndRemoveUntil(context, '/map', (route) => false);
  }

  YYDialog _finishDialog(Function onConfirm, {String labelText}) {
    return _dialog.build(context)
      ..gravity = Gravity.center
      ..gravityAnimationEnable = true
      ..backgroundColor = Colors.transparent
      ..barrierDismissible = false
      ..dismissCallBack = () {_dialog.widgetList = [];}
      ..widget(FinishDialog(
          labelText,
          onConfirm: () =>onConfirm()))
      ..show();
  }

  @override
  void dispose() {
    iSocket.socket.unsubscribe(_iSocketListener);
    super.dispose();
  }
}

class _Props{
  final AuthState authState;
  final DetailState detailState;
  final Function fetch;
  _Props({this.authState, this.detailState, this.fetch});

  static _Props mapStateToProps(Store<AppState> store){
    return _Props(
        authState: store.state.authState,
        detailState: store.state.detailState,
        fetch: (String token, int reqId) => store.dispatch(getDetail(token, reqId))
    );
  }
}