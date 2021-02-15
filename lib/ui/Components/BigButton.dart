import 'package:flutter/material.dart';

class BigButton extends StatelessWidget
{
  final String labelText;
  final Color start;
  final Color end;
  final Function onTap;

  BigButton({
    @required this.labelText,
    @required this.start,
    @required this.end,
    @required this.onTap
  }):assert(
  labelText != null &&
      start != null &&
      end != null &&
      onTap != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: RaisedButton(
            onPressed: onTap,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            textColor: Colors.white,
            padding: EdgeInsets.all(0.0),
            child: SizedBox(
                width: double.infinity,
                height: 35,
                child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          start,
                          end,
                        ]),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: EdgeInsets.all(7),
                    child: Text(
                      labelText,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    )))));
  }

}