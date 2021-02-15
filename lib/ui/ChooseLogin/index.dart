import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:workerf/model/HintModel.dart';
import 'package:workerf/ui/Components/index.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';

class ChooseLogin extends StatefulWidget{
  _ChooseLogin createState() => _ChooseLogin();
}

class _ChooseLogin extends State<ChooseLogin>{
  Random random = new Random();
  Timer timer;
  List<HintModel> hints = [HintModel.init()];
  HintModel _currentHint = HintModel.init();

  void _hints(_Props props) async{
    await props.fetch();
    setState(() {
      hints = props.state.hints;
    });
  }

  @override
  void initState() {
    super.initState();
    _loopHints();
  }

  void _loopHints(){
      timer = Timer.periodic(Duration(seconds: 5), (timer) {
        int index = random.nextInt(hints.length);
        _currentHint = hints[index];
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;

    return StoreConnector<AppState, _Props>(
      onInitialBuild: (props) => _hints(props),
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
                child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Container(
                        color: Colors.transparent,
                        child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(top: 50, bottom: 30),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Image(
                                        image: AssetImage('assets/img/logo-brand.png'),
                                        width: screenSize.width * 0.6,
                                      ))),
                              Expanded(
                                  child: Container(
                                      width: screenSize.width,
                                      height: screenSize.height * 0.7,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30),
                                              topLeft: Radius.circular(30))),
                                      padding: EdgeInsets.all(30),
                                      child: SingleChildScrollView(
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          constraints: BoxConstraints(maxHeight: 150),
                                                          child: Column(
                                                              children: [
                                                                Text(
                                                                    _currentHint.title,
                                                                    style: TextStyle(
                                                                        fontSize: 20,
                                                                        fontWeight: FontWeight.bold),
                                                                    textAlign: TextAlign.center),
                                                                Text(
                                                                    _currentHint.hint,
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.bold),
                                                                    textAlign: TextAlign.center)
                                                              ])),
                                                      FadeInImage.assetNetwork(
                                                          placeholder: 'assets/img/spinner-sm.gif',
                                                          image: _currentHint.img,
                                                          height: 150
                                                      )]),
                                                Padding(padding: EdgeInsets.all(40)),
                                                Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      BigButton(
                                                          labelText: 'Iniciar sesión',
                                                          start: Color(0xFF5033DC),
                                                          end: Color(0xFF7E30DA),
                                                          onTap: () =>Navigator.pushNamed(context, '/login')),
                                                      BigButtonOutline(
                                                          labelText: 'Registrarme',
                                                          onTap: () => Navigator.pushNamed(context, '/register')),
                                                      Navigator.canPop(context)?
                                                          GestureDetector(
                                                            onTap: () => Navigator.pop(context),
                                                            child: Text(props.marketState.market.marketHandle, style: TextStyle(color: Color(0xFF5432DC))))
                                                          :Container()
                                                    ])]
                                          ))))
                            ])))));
      }
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

class _Props{
  final HintState state;
  final MarketState marketState;
  final Function fetch;

  _Props({this.state, this.marketState, this.fetch});

  static _Props mapStateToProps(Store<AppState> store){
    return _Props(
      state: store.state.hintState,
      marketState: store.state.marketState,
      fetch: () => store.dispatch(getHint()));
  }
}