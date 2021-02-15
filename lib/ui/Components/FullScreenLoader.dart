import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FullScreenLoader extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Color(0x22000000)),
        child: SpinKitFadingCircle(color: Color(0xFf000000), size: 60));
  }
}