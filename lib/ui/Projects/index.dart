import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workerf/Exception/index.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/repository/index.dart';
import 'package:workerf/ui/Components/index.dart';
import 'card.dart';
import 'package:workerf/ui/style.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';

class Projects extends StatefulWidget{
  _Projects createState() => _Projects();
}

class _Projects extends State<Projects>{

  void _fetch(_Props props)async{
    await props.fetch(props.authState.user.token, props.authState.user.location);
  }

  void _apply(_Props props, int reqId) async{
    await props.apply(props.authState.user.token, reqId);
    if(props.projectState.error == null){
      UserModel user = props.authState.user;
      user.activeProject = reqId;
      props.updateStoreUser(user);

      Navigator.pushNamedAndRemoveUntil(context, '/progress', (route) => false);
    }else{
      AppException exception = props.projectState.error;

      CToast.warning(exception.errorMessage);

      switch(exception.code){
        case ErrorCode.session:
          Navigator.pushNamedAndRemoveUntil(context, '/choose', (route) => false);break;
        case ErrorCode.busy:
          break;
        case ErrorCode.badRate:
          Navigator.pushReplacementNamed(context, '/support');break;
        case ErrorCode.notVerified:
          Navigator.pushReplacementNamed(context, '/identification');break;
        case ErrorCode.category:
          Navigator.pushReplacementNamed(context, '/category');break;
        case ErrorCode.range:
          Navigator.pop(context);break;
        case ErrorCode.manager:
          Navigator.pop(context);break;
        case ErrorCode.beaten:
          Navigator.pop(context);break;
        case ErrorCode.inactive:
          Navigator.pop(context);break;
        case ErrorCode.blocked:
          Navigator.pushReplacementNamed(context, '/support');break;
        case ErrorCode.maxApply:
          Navigator.pushReplacementNamed(context, '/support');break;
        case ErrorCode.invalid:
          Navigator.pushReplacementNamed(context, '/profile');break;
        case ErrorCode.delay:
          _projectDelay(context, props, exception.errorMessage, exception.data, reqId);break;
        default:
          print('');

      }
    }
  }

  void _decline(_Props props, int reqId) async{
    await props.decline(props.authState.user.token, reqId);
    if(props.projectState.error == null){
      ProjectRepository repository = props.projectState.repository;
      repository.deleteById(reqId);
      props.update(repository);
    }else{
      CToast.error(props.projectState.error);
    }
  }

  Future<void> _projectDelay(BuildContext context, _Props props, String message, double delay, int reqId) async{

    AlertDialog alert = AlertDialog(
        title: Text('$message ...'),
        content: Container(
          width: 50,
          height: 50,
          child: SpinKitDoubleBounce(
            color: Colors.red),
        ));

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        });

    Timer(Duration(seconds: delay.toInt()), () {
      Navigator.pop(context);
      _apply(props, reqId);
    });
  }

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _Props>(
      onInitialBuild: (props) => _fetch(props),
      converter: (store) => _Props.mapStateToProps(store),
      builder: (context, props){

        ProjectRepository _repository = props.projectState.repository;
        List<ProjectModel> _projects = _repository.filter(props.authState.user);

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
                                'Solicitudes de clientes',
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
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.center,
                                    child: RichText(
                                        text: TextSpan(
                                            text: 'Mostrando trabajos cerca de: ',
                                            style: TextStyle(color: Color(0xFF7A2EDA), fontSize: 17),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: props.authState.user.address.addressLine,
                                                  style: TextStyle(color: Colors.black, fontSize: 15)
                                              )]),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center)),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 10)),
                                Expanded(
                                    child: !props.projectState.loading && _projects.length < 1
                                        ?NoResult()
                                        :ListView.builder(
                                        itemCount: _projects.length,
                                        itemBuilder: (context, int index){
                                          ProjectModel _project = _projects[index];
                                          return ProjectCard(
                                              reqId: _project.id,
                                              description: _project.description,
                                              distance: _project.distance,
                                              imgUrl: _project.img,
                                              accept: () => _apply(props, _project.id),
                                              decline: () => _decline(props, _project.id),
                                              viewImage: (url) => Navigator.pushNamed(context, '/imageViewer', arguments: url),
                                          );
                                        }))
                              ]),
                        )),
                    Positioned(
                        top: 0, left: 0,
                        child: props.projectState.loading?FullScreenLoader():Container())
                  ],
                )));
      }
    );
  }
}

class NoResult extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/img/notfound.png'),
            width: 200),
          Text('No hay trabajos cerca',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25)),
          Text('¡Atento! Las oportunidades llegan en un abrir y cerrar de ojos',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16))
        ]),
    );
  }
}

class _Props{
  final AuthState authState;
  final ProjectState projectState;
  final Function fetch;
  final Function apply;
  final Function decline;
  final Function update;
  final Function updateStoreUser;

  _Props({
    this.authState,
    this.projectState,
    this.fetch,
    this.apply,
    this.decline,
    this.update,
    this.updateStoreUser
  });

  static _Props mapStateToProps(Store<AppState> store){
    return _Props(
        authState: store.state.authState,
        projectState: store.state.projectState,
        fetch: (String token, LatLng location) => store.dispatch(getProjects(token, location)),
        apply: (String token, int reqId) => store.dispatch(applyProject(token, reqId)),
        decline: (String token, int reqId) => store.dispatch(declineProject(token, reqId)),
        update: (ProjectRepository repository) => store.dispatch(updateProjects(repository)),
        updateStoreUser: (UserModel user) => store.dispatch(updateUser(user))
    );
  }
}