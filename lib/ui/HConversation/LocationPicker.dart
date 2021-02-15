import 'package:workerf/model/index.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:workerf/provider/index.dart';
import 'package:workerf/global/index.dart';
import 'package:image/image.dart' as imgPkg;
import 'package:workerf/ui/Components/index.dart';
import 'AutoComplete.dart';
import 'package:workerf/ui/style.dart';

class LocationPicker extends StatefulWidget{
  _LocationPicker createState() => _LocationPicker();
}

class _LocationPicker extends State<LocationPicker>{
  TextEditingController _autocompleteController = TextEditingController();
  GoogleMapController _controller;
  Position _currentLocation;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Address _address;

  void _autoComplete(Address address){
    _autocompleteController.text = address.addressLine;
    _address = address;
    _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(address.coordinates.latitude, address.coordinates.longitude),
            zoom: 14)));

    markers[MarkerId('marker')] =Marker(
        markerId: MarkerId('marker'),
        draggable: true,
        position: LatLng(address.coordinates.latitude, address.coordinates.longitude),
        onDragEnd: (value) => _setCameraAndMarker(Position(latitude: value.latitude, longitude: value.longitude)));

    setState(() { });
  }

  void _locationUpdateListener(InternalSocketArgs args){
    if(mounted && args.type == InternalSocketT.locationUpdate)
      setState(() {
        _currentLocation = args.data;
      });
  }

  void _setCameraAndMarker(Position position){
    _setAddress(position);
    _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14)));

    markers[MarkerId('marker')] =Marker(
        markerId: MarkerId('marker'),
        draggable: true,
        position: LatLng(position.latitude, position.longitude),
        onDragEnd: (value) => _setCameraAndMarker(Position(latitude: value.latitude, longitude: value.longitude)));

    setState(() { });
  }

  void _setAddress(Position position) async{
    try{
      Address address = await GServiceProvider.getAddressFromLocation(position);
      _autocompleteController.text = address.addressLine;
      _address = Address(
          addressLine: address.addressLine,
          coordinates: Coordinates(position.latitude, position.longitude));
    }catch (e){
      print(e);
      CToast.warning('Lo siento, no podemos obtener la ubicación por ahora.');
    }

  }

  void _mapCreateCallBack(GoogleMapController controller){
    _controller = controller;
    _setCameraAndMarker(_currentLocation);
  }

  void _done()async{
    if(_address == null) return;
    final imageBytes = await _controller.takeSnapshot();
    imgPkg.Image image = imgPkg.decodeImage(imageBytes);
    imgPkg.Image cropped = imgPkg.copyCrop(image, (image.width/2).floor() - 200, (image.height/2).floor() - 100, 400, 200);
    Navigator.pop(context, LocationModel(image: cropped, address: _address));
  }

  @override
  void initState() {
    super.initState();
    _currentLocation = globalLocationData;
    iSocket.socket.subscribe(_locationUpdateListener);
  }

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;

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
                    stops: [0.05, 0.3])),
            child: Stack(
                children: [
                  Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                          centerTitle: true,
                          title: Text(
                              '¿Donde lo necesitas?',
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
                        child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: GoogleMap(
                                      markers: Set<Marker>.of(markers.values),
                                      onMapCreated: _mapCreateCallBack,
                                      onTap: (value) => _setCameraAndMarker(Position(latitude: value.latitude, longitude: value.longitude)),
                                      initialCameraPosition: CameraPosition(
                                          target: LatLng(19.36573,-99.113848),
                                          zoom: 8))),
                              Container(
                                  padding: EdgeInsets.all(40),
                                  child: AutoComplete(
                                      controller: _autocompleteController,
                                      onAutoComplete: _autoComplete)),
                              Positioned(
                                  bottom: 20,
                                  child: Container(
                                      width: screenSize.width * 0.7,
                                      margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                      child: Column(
                                          children: <Widget>[
                                            BigButton(
                                                labelText: 'Localizame',
                                                start: Color(0xFF5033DC),
                                                end: Color(0XFF7E30DA),
                                                onTap: () => _setCameraAndMarker(
                                                    Position(
                                                        latitude: _currentLocation.latitude,
                                                        longitude: _currentLocation.longitude))),
                                            BigButton(
                                              labelText: 'Usar esta Ubicacion',
                                              start: Color(0xFF1B998B),
                                              end: Color(0XFF1B998B),
                                              onTap: _done,
                                            )])))]),
                      ))]
            )));
  }

  @override
  void dispose() {
    iSocket.socket.unsubscribe(_locationUpdateListener);
    super.dispose();
  }
}