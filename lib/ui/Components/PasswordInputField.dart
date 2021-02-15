import 'package:flutter/material.dart';

class PasswordInputField extends StatefulWidget
{
  final String labelText;
  final TextEditingController controller;
  final Function validator;

  PasswordInputField({
    @required this.labelText,
    @required this.controller,
    @required this.validator
  }):assert(
  labelText != null &&
      controller != null&&
      validator != null);

  _PasswordInputFieldState createState() => _PasswordInputFieldState();

  static String passwordValidator (String password){
    if(password.isEmpty)
    {
      return 'Se requiere contraseña.';
    }
    else if(password.length < 4)
    {
      return 'La contraseña debe tener al menos 4 caracteres.';
    }
    else{ return null;}
  }

  static String passwordOptionalValidator(String password){
    if(password.isNotEmpty && password.length < 4){
      return 'La contraseña debe tener al menos 4 caracteres.';
    }else{return null;}
  }
}

class _PasswordInputFieldState extends State<PasswordInputField>
{
  bool secure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        validator: widget.validator,
        style: TextStyle(
            color: Colors.black,
            fontSize: 15),
        obscureText: secure,
        controller: widget.controller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 5),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gapPadding: 5,
                borderSide: BorderSide(
                    color: Color(0xFF7E30DA))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gapPadding: 5,
                borderSide: BorderSide(
                    color: Color(0xFF7E30DA))),
            labelText: widget.labelText,
            labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 17),
            suffixIcon: IconButton(
              icon: Icon(Icons.remove_red_eye, color: secure?Colors.black:Colors.blue),
              onPressed: ()
              {
                setState(() {
                  secure = !secure;
                });
              }))));
  }
}