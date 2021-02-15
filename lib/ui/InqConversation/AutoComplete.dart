import 'dart:async';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:rxdart/rxdart.dart';
import 'package:workerf/global/index.dart';

class AutoComplete extends StatefulWidget {
  final Function onAutoComplete;
  final TextEditingController controller;

  AutoComplete({this.controller, this.onAutoComplete});
  _AutoCompleteState createState() => _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete>
{
  TextEditingController _controller;
  final _queryBehavior = BehaviorSubject<String>.seeded('');

  PlacesAutocompleteResponse _response;
  GoogleMapsPlaces _places;
  Timer _debounce;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _places = GoogleMapsPlaces(apiKey: googleMapApiBrowserKey);
    _searching = false;

    _queryBehavior.stream.listen(doSearch);
  }

  void _onQueryChange() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () {
      if(!_queryBehavior.isClosed) {
        _queryBehavior.add(_controller.text);
      }
    });
  }

  Future<Null> doSearch(String value) async {
    if (mounted && value.isNotEmpty) {
      setState(() {
        _searching = true;
      });

      final res = await _places.autocomplete(value);
      if (res.errorMessage?.isNotEmpty == true ||
          res.status == "REQUEST_DENIED") {
        onResponseError(res);
      } else {
        onResponse(res);
      }
    }else {
      onResponse(null);
    }
  }

  void onResponseError(PlacesAutocompleteResponse res) {
    if (!mounted) return;

    setState(() {
      _response = null;
      _searching = false;
    });
  }

  void onResponse(PlacesAutocompleteResponse res) {
    if (!mounted) return;

    setState(() {
      _response = res;
      _searching = false;
    });
  }

  void pickAddress(Prediction prediction) async
  {
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(prediction.placeId);
    Location location = detail.result.geometry.location;
    Address address = Address(coordinates: Coordinates(location.lat, location.lng), addressLine: prediction.description);
    setState(() {
      _response = null;
    });
    widget.onAutoComplete(address);
  }

  Widget linearLoader()
  {
    if (_searching)
      return _Loader();
    else
      return Container();
  }

  Widget predictResult()
  {
    List<Widget> list = [];

    if (_response == null || _response.predictions.length == 0)
    {
      return Container();
    }

    for (Prediction prediction in _response.predictions)
    {
      if(list.length < 3)
        list.add(GestureDetector(
          child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.location_on),
                    Padding(
                      padding: EdgeInsets.only(right:5),
                    ),
                    Flexible(
                        child: Text(prediction.description, maxLines: 1, overflow: TextOverflow.ellipsis))
                  ])),
          onTap: ()=> pickAddress(prediction),
        ));
    }

    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
          color: Colors.white
      ),
//      height: 150,
      child: Flex(
          mainAxisSize: MainAxisSize.max,
          direction: Axis.vertical,
          children: list
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Card(
              elevation: 6.0,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                          Radius.circular(5.0))),
                  child: TextField(
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(2.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(5.0)),
                          hintText: "Ingresa tu ubicacion",
                          prefixIcon: Icon(Icons.search),
                          hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey)),
                      maxLines: 1,
                      controller: widget.controller,
                      onChanged: (value) =>_onQueryChange()
                  ))),
          linearLoader(),
          Container(child: SingleChildScrollView(child: predictResult()))
        ]);
  }
}

class _Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 5, right: 5),
        constraints: BoxConstraints(maxHeight: 4.0),
        child: LinearProgressIndicator());
  }
}