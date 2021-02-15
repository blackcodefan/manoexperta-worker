import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:workerf/Exception/AppException.dart';
import 'package:workerf/Exception/ErrorCode.dart';
import 'package:workerf/global/index.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/provider/GServiceProvider.dart';
import 'package:workerf/redux/index.dart';
import 'package:workerf/ui/Components/index.dart';

class Splash extends StatefulWidget{
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash>{

  void _handleInitialBuild(_Props props) async{

      try{
        Position location = await LocationLocalSave.getLocation();
        await props.fetchMarket(location);
        globalLocationData = location;
        if(props.marketState.error == null){
          globalMarket = props.marketState.market;
        }
      }on AppException catch(e){
        if(e.code == ErrorCode.noLocationSaved)
          CToast.warning('Incapaz de obtener la ubicación. Es posible que la aplicación no funcione correctamente');
      }

    Navigator.pushReplacementNamed(context, '/market');
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return StoreConnector<AppState, _Props>(
        converter: (store) => _Props.mapStateToProps(store),
        onInitialBuild: (props) => this._handleInitialBuild(props),
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
                          Color(0xFF5832DC),
                          Color(0xFF7730DA)
                        ])),
                child: Center(
                    child: Image(
                      image: AssetImage('assets/img/logo.png'),
                      width: screenSize.width/3,
                    ))));
      }
    );
  }
}

class _Props{
  final Function fetchMarket;
  final MarketState marketState;
  _Props({this.fetchMarket, this.marketState});

  static _Props mapStateToProps(Store<AppState> store){
    return _Props(
        fetchMarket: (Position position) => store.dispatch(market(position)),
        marketState: store.state.marketState
    );
  }
}