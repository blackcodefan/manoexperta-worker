import 'package:flutter/material.dart';
import 'package:workerf/ui/style.dart';

class Layout extends StatefulWidget{
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout>{


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
                    stops: [0.05, 0.3]
                )),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                    centerTitle: true,
                    title: Text(
                        'Layout',
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
                  child: SingleChildScrollView(
                      child: Container(
                        constraints: BoxConstraints(minHeight: screenSize.height * 0.88),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            ]),
                      )),
                ))));
  }
}