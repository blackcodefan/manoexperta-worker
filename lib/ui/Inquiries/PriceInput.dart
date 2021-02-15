import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class PriceInput extends StatelessWidget{
  final MaskedTextController controller;
  PriceInput({this.controller}):assert(controller != null);

  String _validator(String price){
    if(price.isEmpty){
      return 'Se requiere precio';
    }else return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 130,
        height: 30,
        child: TextFormField(
            style: TextStyle(
                color: Colors.black,
                fontSize: 15),
            controller: controller,
            validator: _validator,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 5),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gapPadding: 1,
                    borderSide: BorderSide(
                        color: Color(0xFF7E30DA)
                    )),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gapPadding: 1,
                    borderSide: BorderSide(
                        color: Color(0xFF7E30DA))))
        ));
  }
}