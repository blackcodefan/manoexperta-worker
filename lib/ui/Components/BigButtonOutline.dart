import 'package:flutter/material.dart';

class BigButtonOutline extends StatelessWidget
{
  final String labelText;
  final Function onTap;

  BigButtonOutline({
    @required this.labelText,
    @required this.onTap}):assert(
  labelText != null &&
      onTap != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        onPressed: onTap,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        textColor: Color(0xFF5133DC),
        padding: EdgeInsets.all(0.0),
        child: SizedBox(
          width: double.infinity,
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF5133DC), width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white
              ),
              padding: EdgeInsets.all(7),
              child: Text(
                labelText,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              )))));
  }

}
