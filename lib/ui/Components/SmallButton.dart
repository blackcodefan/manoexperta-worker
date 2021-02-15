import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget
{
  final double width;
  final double height;
  final Color start;
  final Color end;
  final String labelText;
  final Function onTap;

  SmallButton({
    @required this.width,
    @required this.height,
    @required this.start,
    @required this.end,
    @required this.labelText,
    @required this.onTap
  }):assert(
  width != null &&
      height != null &&
      start != null &&
      end != null &&
      labelText != null &&
      onTap != null);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.only(bottom: 10),
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                start,
                end
              ],
              stops: [
                0.05,
                0.99
              ]),
          borderRadius: BorderRadius.all(
              Radius.circular(5.0)),
        ),
        child: Text(
          labelText,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}