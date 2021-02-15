import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget
{
  final TextEditingController controller;
  final Function sendMessage;
  final Function sendImage;
  final Function sendLocation;

  MessageInput({
    @required this.controller,
    @required this.sendMessage,
    this.sendImage,
    this.sendLocation});
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput>
{
  @override
  Widget build(BuildContext context) {

    //final Size screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE5E5E5),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Expanded(
            //padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              maxLines: 3,
              minLines: 1,
              controller: widget.controller,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent
                    )),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent
                    ))))),
          Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.send),
                  onTap: widget.sendMessage),
                GestureDetector(
                  child: Icon(Icons.camera_alt),
                  onTap: widget.sendImage),
                GestureDetector(
                  child: Icon(Icons.location_on),
                  onTap: widget.sendLocation)
              ]))
        ]));
  }
}