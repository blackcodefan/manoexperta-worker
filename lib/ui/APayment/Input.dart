import 'package:flutter/material.dart';

class CardNumberInput extends StatelessWidget{

  final TextEditingController controller;

  CardNumberInput({
    @required this.controller
  }):assert(
  controller != null
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
          color: Colors.black,
          fontSize: 15),
      controller: controller,
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
                  color: Color(0xFF7E30DA)
              )))
    );
  }
}