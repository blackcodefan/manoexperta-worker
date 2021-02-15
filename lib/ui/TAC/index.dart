import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:workerf/ui/style.dart';

class TAC extends StatefulWidget{
  final String url;
  TAC(this.url);
  _TAC createState() => _TAC();
}

class _TAC extends State<TAC>{

  final Completer<WebViewController> _controller = Completer<WebViewController>();

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
                        'Términos y Condiciones',
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: WebView(
                      initialUrl: 'https://manoexperta.com/${widget.url}.cfm',
                      onWebViewCreated: (WebViewController webViewController){
                        _controller.complete(webViewController);
                      },
                      javascriptMode: JavascriptMode.unrestricted,
                    ))
                ))));
  }
}