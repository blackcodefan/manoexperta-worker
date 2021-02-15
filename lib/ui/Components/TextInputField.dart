import 'package:flutter/material.dart';
import 'package:workerf/global/index.dart';

class TextInputField extends StatefulWidget
{
  final String labelText;
  final TextEditingController controller;
  final Function validator;

  TextInputField({
    @required this.labelText,
    @required this.controller,
    @required this.validator
  }):super();


  _TextInputFieldState createState() => _TextInputFieldState();

  static String emailValidator(String email){
    RegExp _emailExp = new RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if(email.isEmpty)
    {
      return 'Correo electronico es requerido.';
    }
    else if(!_emailExp.hasMatch(email))
    {
      return 'Dirección de correo electrónico inválida';
    }
    else{ return null;}

  }

  static String emailOptionalValidator(String email){
    RegExp _emailExp = new RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if(email.isNotEmpty && !_emailExp.hasMatch(email)){
      return 'Correo electronico es requerido.';
    }else{return null;}
  }

  static String firstNameValidator(String firstName){
    if(firstName.isEmpty){
      return "Se requiere el primer nombre";
    }else if(firstName.length > 20 || firstName.length < 2){
      return "Máximo 50, mínimo 2 caracteres";
    }else{return null;}
  }

  static String lastNameValidator(String lastName){
    if(lastName.isNotEmpty && lastName.length > 50){
      return "Apellido excedido longitud máxima 50 caracteres";
    }else return null;
  }

  static String phoneValidator(String phone){
    String filtered = phone.replaceAll('-', '');
    RegExp phoneExp = new RegExp(r"^(?:[+0]\d)?[0-9]{8,13}$");

    if(filtered.isEmpty){
      return "Se requiere número de teléfono.";
    }else if(!phoneExp.hasMatch(filtered)){
      return "Numero de telefono invalido";
    }else return null;
  }

  static String phoneOptionalValidator(String phone){
    String filtered = phone.replaceAll('-', '');
    RegExp phoneExp = new RegExp(r"^(?:[+0]\d)?[0-9]{8,13}$");
    if(filtered.isNotEmpty && !phoneExp.hasMatch(filtered)){
      return "Numero de telefono invalido";
    }else return null;
  }

  static String reviewCommentValidator(String comment){
    if(comment.isEmpty){
      return "comentario requerido";
    }else if(comment.length < 20 || comment.length > 255){
      return "Mínimo 20, máximo 255 caracteres";
    }else return null;
  }

}

class _TextInputFieldState extends State<TextInputField>
{
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
                  color: Color(0xFF7E30DA)
              )),
          labelText: widget.labelText,
          labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 17
          ))));
  }
}