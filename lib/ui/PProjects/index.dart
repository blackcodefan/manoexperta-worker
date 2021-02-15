import 'package:flutter/material.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/ui/Components/index.dart';
import 'PJobCard.dart';
import 'package:workerf/ui/style.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';


class PProjects extends StatefulWidget{
  _PProjects createState() => _PProjects();
}

class _PProjects extends State<PProjects>{

  void _fetch(_Props props){
    props.fetch(props.authState.user.token);
  }

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _Props>(
      onInitialBuild: (props) => _fetch(props),
      converter: (store) => _Props.mapStateToProps(store),
      builder: (context, props){

        List<PProjectModel> projects = props.pProjectState.projects;

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
                                'Trabajos previos',
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
                          child: projects.length > 0?ListView.builder(
                              itemCount: projects.length,
                              itemBuilder: (context, int index){
                                PProjectModel project = projects[index];
                                return PJobCard(
                                    isRated: true,
                                    rate: project.rate,
                                    username: project.lastName,
                                    describe: project.description,
                                    comment: project.comment,
                                    clientAvatar: project.avatar,
                                    reqId: project.reqId);
                              }):_NoResult(),
                        )),
                    Positioned(
                        top: 0, left: 0,
                        child: props.pProjectState.loading?FullScreenLoader():Container())
                  ],
                )));
      }
    );
  }
}

class _NoResult extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/noprevwork.png',
                width: 200),
            Text('Sin paquetes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
          ]),
    );
  }
}

class _Props{
  final AuthState authState;
  final PProjectState pProjectState;
  final Function updateStore;
  final Function fetch;
  _Props({this.authState, this.pProjectState, this.updateStore, this.fetch});

  static _Props mapStateToProps(Store<AppState> store){
    return _Props(
        authState: store.state.authState,
        pProjectState: store.state.pProjectState,
        updateStore: (UserModel user) => store.dispatch(updateUser(user)),
        fetch: (String token) => store.dispatch(getPProject(token))
    );
  }
}