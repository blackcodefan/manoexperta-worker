import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workerf/global/index.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/provider/index.dart';
import 'package:workerf/ui/Components/index.dart';
import 'package:workerf/ui/style.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';

class MapScreen extends StatefulWidget{
  _Map createState() => _Map();
}

class _Map extends State<MapScreen>{
  GoogleMapController _controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Address _address;
  Position _position;
  String _version = '';

  void _setVersion() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    iSocket.socket.subscribe(_socketListener);
    _setVersion();
  }

  void _onMapCreated(controller){
    _controller = controller;
    _setCameraAndMarker(globalLocationData);
  }

  void _setCameraAndMarker(Position position){
    _position = position;
    globalLocationData = position;
    _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14)));

    markers[MarkerId('marker')] =Marker(
        markerId: MarkerId('marker'),
        draggable: true,
        position: LatLng(position.latitude, position.longitude),
        onDragEnd: (value) => _setCameraAndMarker(Position(latitude: value.latitude, longitude: value.longitude)));

    _setAddress(position);
  }

  void _setAddress(Position position) async{
    try{
      Address address = await GServiceProvider.getAddressFromLocation(position);
      _address = Address(
          addressLine: address.addressLine,
          coordinates: Coordinates(position.latitude, position.longitude));
      setState(() {});
    }catch (e){
      print(e);
      //CToast.warning('Lo siento, no podemos obtener la ubicación por ahora.');
    }

  }

  void _socketListener(InternalSocketArgs args) async{
    if(mounted && args.type == InternalSocketT.locationUpdate){
      setState(() {
        _position = args.data;
      });
    }
  }

  void _initPosition(){
    _position = globalLocationData;
    _setCameraAndMarker(_position);
  }

  void _setExpertLocation(_Props props)async{
    if(props.marketState.market.identity && props.authState.user.verifiedStatus != 2){
      CToast.warning('Debe verificar su identidad.');
      Navigator.pushNamed(context, '/identification');
      return;
    }
//    if(globalMarket.payment && props.authState.user.bankVerifyStatus != 2){
//      CToast.warning('Debe verificar su cuenta bancaria.');
//      Navigator.pushNamed(context, '/aPayment');
//      return;
//    }


    UserModel user = props.authState.user;
    user.location = LatLng(_position.latitude, _position.longitude);
    user.address = _address;
    props.setLocation(user);

    Navigator.pushNamed(context, '/projects');
  }

  Future<void> _logout() async
  {
    await CredentialModel.eraseCredential();
    Navigator.pushNamedAndRemoveUntil(context, '/choose', (route) => false);
  }

  void _fetchLocation(_Props props){
    props.fetchMarket(globalLocationData);
  }

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;

    return StoreConnector<AppState, _Props>(
      converter: (store) => _Props.mapStateToProps(store),
        onInitialBuild: (props) => _fetchLocation(props),
      builder: (context, props){
        UserModel user = props.authState.user;
        MarketConfigModel market = props.marketState.market;
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
                    appBar: AppBar(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Actualiza tu ubicación',
                            style: appbarTitle,
                          ),
                          Text(
                            'Te notificaremos de trabajos disponibles aquí',
                            style: TextStyle(fontSize: 12),
                          )]),
                      centerTitle: true,
                      elevation: 0.0,
                      backgroundColor: Colors.transparent),
                    drawer: Drawer(
                        child: Column(
                            children: [
                              Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: <Color>[
                                          Color(0xFF5033DC),
                                          Color(0xFF7C30DA)
                                        ],
                                        stops: [0.6, 0.95]
                                    )),
                                  child: DrawerHeader(
                                      margin: EdgeInsets.only(bottom: 1),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              child: FadeInImage.assetNetwork(
                                                placeholder: 'assets/img/unknown.png',
                                                image: user.avatar,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.fill)),
                                            Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Text('${user.firstName} ${user.lastName}',
                                                      style: TextStyle(color: Colors.white),
                                                      overflow: TextOverflow.ellipsis
                                                  ),
                                                  Text('ID: ${user.userId}',
                                                    style: TextStyle(color: Colors.white, fontSize:20),
                                                  )])]))),
                              Expanded(
                                  child: Column(
                                      children: [
                                        Expanded(
                                            child: ListView(
                                              padding: EdgeInsets.zero,
                                                children: [
                                                  SidebarItem(
                                                      labelText: 'Actualizar mi perfil',
                                                      onTap: ()=> {Navigator.pop(context), Navigator.pushNamed(context, '/profile')}
                                                  ),
                                                  SidebarItem(
                                                      labelText: 'Verificar identidad',
                                                      onTap: ()=> {Navigator.pop(context), Navigator.pushNamed(context, '/identification')}
                                                  ),
                                                  SidebarItem(
                                                      labelText: 'Tus especialidades',
                                                      onTap: ()=> {Navigator.pop(context), Navigator.pushNamed(context, '/category')}),
                                                  SidebarItem(
                                                      labelText: 'Trabajos previos',
                                                      onTap: ()=> {Navigator.pop(context), Navigator.pushNamed(context, '/pProjects')}),
                                                  user.isPremium
                                                      ?Container():
                                                      SidebarItem(
                                                      labelText: 'Premium',
                                                      onTap: ()=> {Navigator.pop(context), Navigator.pushNamed(context, '/premium')}),
                                                  market.payment?
                                                  SidebarItem(
                                                      labelText: 'Pagos',
                                                      onTap: ()=> {
                                                        Navigator.pop(context),
                                                        currentUser.bankVerifyStatus == 2
                                                            ?Navigator.pushNamed(context, '/payments')
                                                            :Navigator.pushNamed(context, '/aPayment')
                                                      }):Container(),
                                                  SidebarItem(
                                                      labelText: 'Cotizaciones',
                                                      onTap: ()=> {Navigator.pop(context), Navigator.pushNamed(context, '/inquiry')}),
                                                  SidebarItem(
                                                      labelText: 'Ayuda',
                                                      onTap: ()=> {Navigator.pop(context), Navigator.pushNamed(context, '/support')}),
                                                  SidebarItem(
                                                      labelText: 'Salir',
                                                      onTap: ()=> _logout())])),
                                        Container(
                                            height: 80,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Image(
                                                    image: AssetImage('assets/img/logo-brand-blue.png'),
                                                    width: 180))),
                                        Text(_version,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold))
                                      ])
                              )])),
                    body: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30))),
                        child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: GoogleMap(
                                      markers: Set<Marker>.of(markers.values),
                                      onTap: (value) => _setCameraAndMarker(Position(latitude: value.latitude, longitude: value.longitude)),
                                      onMapCreated: _onMapCreated,
                                      initialCameraPosition: CameraPosition(
                                          target: LatLng(globalLocationData.latitude, globalLocationData.longitude),
                                          zoom: 8))),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                          margin: EdgeInsets.all(20),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Color(0xCC7C2EDA),
                                              borderRadius: BorderRadius.all(Radius.circular(10))),
                                          child: Row(
                                              children: [
                                                Icon(Icons.location_on, color: Colors.white),
                                                Padding(
                                                  padding: EdgeInsets.only(right: 5)),
                                                Expanded(
                                                    child: Text(
                                                        _address==null?"":_address.addressLine,
                                                        style: TextStyle(color: Colors.white),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis))
                                              ]))),
                                    GestureDetector(
                                      onTap: _initPosition ,
                                      child: Container(
                                          width: 40,
                                          height: 40,
                                          child: Icon(Icons.my_location, color: Colors.white),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: Color(0xFF5033DC)),
                                          margin: EdgeInsets.only(right: 10)))
                                  ]),
                              Positioned(
                                  bottom: 20,
                                  child: Container(
                                      width: screenSize.width * 0.7,
                                      margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                      child: BigButton(
                                          labelText: 'Usar esta ubicación',
                                          start: Color(0xFF5033DC),
                                          end: Color(0XFF7E30DA),
                                          onTap: ()=>_setExpertLocation(props)
                                      )))
                            ])
                    ))));
      }
    );
  }

  @override
  void dispose() {
    iSocket.socket.unsubscribe(_socketListener);
    super.dispose();
  }
}

class _Props{
  final AuthState authState;
  final MarketState marketState;
  final Function setLocation;
  final Function fetchMarket;
  _Props({this.authState, this.marketState, this.setLocation, this.fetchMarket});

  static _Props mapStateToProps(Store<AppState> store){
    return _Props(
        authState: store.state.authState,
        marketState: store.state.marketState,
        setLocation: (UserModel user) => store.dispatch(updateUser(user)),
      fetchMarket: (Position position) => store.dispatch(market(position)),
    );
  }
}