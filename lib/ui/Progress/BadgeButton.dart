import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

class BadgeButton extends StatelessWidget
{
  final String labelText;
  final Color start;
  final Color end;
  final Function onTap;
  final int msgCount;

  BadgeButton({
    @required this.labelText,
    @required this.start,
    @required this.end,
    @required this.onTap,
    this.msgCount = 0
  }):assert(
  labelText != null
      && start != null
      && end != null
      && onTap != null
  );

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
                              end
                            ]),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: EdgeInsets.all(2),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              labelText,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                              textAlign: TextAlign.center),
                          msgCount != 0?Badge(
                            badgeContent: Text(msgCount.toString(), style: TextStyle(color: Colors.white)),
                          ):Container()
                        ])))));
  }

}