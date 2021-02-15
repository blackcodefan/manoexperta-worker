import 'package:flutter/material.dart';
import 'package:workerf/ui/Components/index.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:workerf/ui/style.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';

class RFriend extends StatefulWidget{
  final int reqId;
  RFriend(this.reqId);

  _RFriend createState() => _RFriend();
}

class _RFriend extends State<RFriend>{
  MaskedTextController _controller = MaskedTextController(mask: '00000');

  Future<void> _submit(_Props props) async{
    if(_controller.text.isNotEmpty) {
      int friendId = int.parse(_controller.text);
      await props.invitedBy(widget.reqId, friendId);
      if(props.authState.error == null){
        Navigator.pushReplacementNamed(context, '/choose');
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
                                  'ID de Referencia',
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
                                child: Container(
                                  constraints: BoxConstraints(minHeight: screenSize.height * 0.88),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text('¡manoexperta te premia!',
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center),
                                        Text('Gana \$50 pesos por referenciar'),
                                        Divider(thickness: 10, color: Colors.transparent),
                                        Image.asset('assets/img/refer.png', width: 250),
                                        Container(
                                            constraints: BoxConstraints(maxWidth: 250),
                                            child: Text('Si alguien te refirió ayúdalo a ganar. Solo escribe su ID',
                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center)),
                                        Container(
                                            margin: EdgeInsets.only(top: 40),
                                            width: screenSize.width * 0.6,
                                            child: TextFormField(
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15),
                                                controller: _controller,
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(left: 5),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(0)),
                                                        gapPadding: 1,
                                                        borderSide: BorderSide(
                                                            color: Color(0xFF7E30DA))),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(0)),
                                                        gapPadding: 1,
                                                        borderSide: BorderSide(
                                                            color: Color(0xFF7E30DA)
                                                        )))
                                            )),
                                        Container(
                                            margin: EdgeInsets.only(bottom: 40),
                                            padding: EdgeInsets.all(20),
                                            child: Row(
                                              children: [
                                                SmallButton(
                                                    width: 80,
                                                    height: 30,
                                                    start: Color(0xFFCF2A28),
                                                    end: Color(0xFFCF2A28),
                                                    labelText: 'Omitir',
                                                    onTap: () =>Navigator.pushReplacementNamed(context, '/choose')),
                                                SmallButton(
                                                  width: 80,
                                                  height: 30,
                                                  start: Color(0xFF5E3DD3),
                                                  end: Color(0xFF5E3DD3),
                                                  labelText: 'Registrar',
                                                  onTap: () => _submit(props),
                                                )],
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            )),
                                        Text('Ahora te toca ganar a ti. Este es tu ID.',
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center),
                                        Text(widget.reqId.toString(),
                                          style: TextStyle(fontWeight: FontWeight.bold,
                                              fontSize: 40,
                                              color: Colors.red))
                                      ]),
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
  final Function invitedBy;
  final AuthState authState;

  _Props({this.invitedBy, this.authState});

  static _Props mapStateToProps(Store<AppState> store){
    return _Props(
      invitedBy: (int me, int friend) => store.dispatch(recommend(me, friend)),
      authState: store.state.authState
    );
  }
}