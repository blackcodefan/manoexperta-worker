import 'package:flutter/material.dart';

class NoResult extends StatelessWidget{
  final String message;
  NoResult({@required this.message}):assert(message != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/img/notfound.png'),
            width: 250),
          Text(message,style: TextStyle(fontSize: 22))
        ]));
  }
}