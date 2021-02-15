import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FullScreenLoaderWhite extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Color(0x33FFFFFF)),
      child: SpinKitFadingCircle(
        color: Color(0xCC000000),
        size: 60));
  }
}