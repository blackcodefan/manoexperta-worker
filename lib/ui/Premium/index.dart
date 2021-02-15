import 'package:flutter/material.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:workerf/ui/style.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';

class Premium extends StatefulWidget{
  _Premium createState() => _Premium();
}

class _Premium extends State<Premium>{
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {

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
                  child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                          centerTitle: true,
                          title: Text(
                              'Premium',
                              style: appbarTitle),
                          elevation: 0.0,
                          backgroundColor: Colors.transparent,
                          leading: Navigator.canPop(context)
                              ?IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () => Navigator.pop(context))
                              :Container()),
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
                              initialUrl: 'https://manoexperta.com/premium/?tokenid=${props.authState.user.token}',
                              onWebViewCreated: (WebViewController webViewController){
                                _controller.complete(webViewController);
                              },
                              javascriptMode: JavascriptMode.unrestricted,
                            ),
                          )
                      ))));
        }
    );
  }
}

class _Props{
  final AuthState authState;
  _Props({this.authState});

  static _Props mapStateToProps(Store<AppState> store){
    return _Props(authState: store.state.authState);
  }
}