import 'package:flutter/material.dart';

class FinishDialog extends StatelessWidget{
  final String label;
  final Function onConfirm;

  FinishDialog(this.label, {@required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 0 , 10, 10),
                        child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Color(0xFF329AF0), size: 30),
                              Text('Notificación', style: TextStyle(fontSize: 18),)
                            ])),
                    Container(
                        child: Text(label)),
                    FlatButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        color: Color(0xFF4285F4),
                        textColor: Colors.white,
                        onPressed: onConfirm,
                        child: Text('Confirmar'))
                  ])),
        ]);
  }
}