import 'package:flutter/material.dart';
import 'package:workerf/ui/style.dart';

class ImageViewer extends StatefulWidget{
  final String url;
  ImageViewer(this.url);
  _ImageViewer createState() => _ImageViewer();
}

class _ImageViewer extends State<ImageViewer>{


  @override
  Widget build(BuildContext context) {
    //final Size screenSize = MediaQuery.of(context).size;

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
                    centerTitle: true,
                    title: Text(
                        'Imagen del cliente',
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
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: FadeInImage.assetNetwork(
                      placeholder: 'assets/img/spinner-sm.gif',
                      image: widget.url),
                ))));
  }
}