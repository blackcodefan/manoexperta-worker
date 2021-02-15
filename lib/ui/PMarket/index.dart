import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:upgrader/upgrader.dart';
import 'package:workerf/global/index.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/provider/index.dart';
import 'package:workerf/repository/index.dart';
import 'package:workerf/ui/Components/index.dart';
import 'package:workerf/ui/style.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';

class PMarket extends StatefulWidget{
  _PMarket createState() => _PMarket();
}

class _PMarket extends State<PMarket>{
  MarketRepository _repository = MarketRepository(markets:[]);
  LatLng _groupValue;
  bool _loading = false;

  void _load(){
    setState(() {
      _loading = true;
    });
  }

  void _loaded(){
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMarket();
  }

  void _fetchMarket() async{
    _load();
    UserQueryResult res = await UserProvider.fetchMarkets();
    _repository = res.data;
    _loaded();
  }

  void _login(_Props props) async{
    if(_groupValue == null){
      CToast.warning('Por favor seleccione mercado');
      return;
    }
    globalLocationData = Position(latitude: _groupValue.latitude, longitude:_groupValue.longitude);
    LocationLocalSave prefs = LocationLocalSave(location: globalLocationData);
    await prefs.setLocation();
    globalMarket = props.marketState.market;
    await props.getProfile(props.authState.user.token);
    eSocket.socketConfig();
    Navigator.pop(context);
  }

  void _chooseLocation(_Props props, LatLng location) async{
    setState(() {
      _groupValue = location;
    });
    await props.fetchMarket(Position(latitude: location.latitude, longitude: location.longitude));
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final appcastURL = 'http://ws.manoexperta.com/version/ae';
    final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);

    return StoreConnector<AppState, _Props>(
        converter: (store) => _Props.mapStateToProps(store),
        builder: (context, props){

          return UpgradeAlert(
              appcastConfig: cfg,
              showIgnore: false,
              messages: UpgraderMessages(code: 'es'),
              child: Scaffold(
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
                                      '¿Dónde te encuentras?',
                                      style: appbarTitle),
                                  elevation: 0.0,
                                  backgroundColor: Colors.transparent,
                                  actions: [
                                    IconButton(
                                        icon: Icon(Icons.check),
                                        onPressed: () => _login(props))
                                  ]),
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
                                      alignment: Alignment.center,
                                      constraints: BoxConstraints(minHeight: screenSize.height * 0.88),
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CountryItem(
                                                value: _groupValue,
                                                countryName: "Bolivia",
                                                flag: "https://manoexperta.s3.amazonaws.com/flutter/BO_Flag.png",
                                                models: _repository.markets.where((element) => element.countryCode == 'BO').toList(),
                                                onChange: (value) => _chooseLocation(props, value)),
                                            CountryItem(
                                                value: _groupValue,
                                                countryName: "Mexico",
                                                flag: "https://manoexperta.s3.amazonaws.com/flutter/MX_Flag.png",
                                                models: _repository.markets.where((element) => element.countryCode == 'MX').toList(),
                                                onChange: (value) => _chooseLocation(props, value)),
                                            CountryItem(
                                                value: _groupValue,
                                                countryName: "USA",
                                                flag: "https://manoexperta.s3.amazonaws.com/flutter/US_Flag.png",
                                                models: _repository.markets.where((element) => element.countryCode == 'US').toList(),
                                                onChange: (value) => _chooseLocation(props, value)),
                                          ]),
                                    )),
                              )),
                          Positioned(
                              top: 0, left: 0,
                              child: props.marketState.loading || props.authState.loading || _loading
                                  ?FullScreenLoader():Container())
                        ],
                      ))));
        });
  }
}

class CountryItem extends StatelessWidget{
  final List<MarketModel> models;
  final String countryName;
  final String flag;
  final LatLng value;
  final Function onChange;
  CountryItem({
    @required this.models,
    @required this.countryName,
    @required this.flag,
    @required this.value,
    @required this.onChange
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 5),
        child: ExpandableNotifier(
            child: ScrollOnExpand(
                child: ExpandablePanel(
                    header: Container(
                        height: 80,
                        padding: EdgeInsets.all(10),
                        child: Row(
                            children: [
                              ClipOval(
                                  child: FadeInImage.assetNetwork(
                                      width: 60,
                                      height: 60,
                                      placeholder: 'assets/img/spinner-sm.gif',
                                      image: flag)),
                              Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(countryName,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)))
                            ])),
                    expanded: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(maxHeight: 200, minHeight: 30),
                        child: ListView.builder(
                            itemCount: models.length,
                            itemBuilder: (context, int index){
                              return Container(
                                  child:Row(
                                    children: [
                                      Radio(
                                          value: models[index].location,
                                          groupValue: value,
                                          onChanged: (val) =>onChange(val)),
                                      Text(models[index].name)
                                    ],
                                  ));
                            }))
                ))
        ));
  }
}

class _Props{
  final Function authenticate;
  final Function getProfile;
  final Function initProfile;
  final Function fetchMarket;
  final Function getNotification;
  final Function addDevice;
  final AuthState authState;
  final MarketState marketState;

  _Props({
    this.authenticate,
    this.getProfile,
    this.initProfile,
    this.fetchMarket,
    this.getNotification,
    this.addDevice,
    this.authState,
    this.marketState});

  static _Props mapStateToProps(Store<AppState> store){
    return _Props(
      authState: store.state.authState,
      authenticate: (String email, String password) => store.dispatch(logInAction(email, password)),
      getProfile: (String token) => store.dispatch(getProfileAction(token)),
      initProfile: (String token) => store.dispatch(initWorker(token)),
      fetchMarket: (Position position) => store.dispatch(market(position)),
      marketState: store.state.marketState,
      getNotification: (String token) => store.dispatch(updateProfile(token)),
      addDevice: (UserModel user) => store.dispatch(updateUser(user)),
    );
  }
}