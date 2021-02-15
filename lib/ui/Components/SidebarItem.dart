import 'package:flutter/material.dart';


class SidebarItem extends StatelessWidget
{
  final String labelText;
  final Function onTap;

  SidebarItem({
    @required this.labelText,
    @required this.onTap
  }):assert(labelText != null && onTap != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0XFF7C30DA), width: 2))
        ),
        padding: EdgeInsets.fromLTRB(40, 0, 10, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(labelText),
            Icon(Icons.arrow_forward_ios, size: 20, color: Color(0xFF5032DC))
          ]
        )),
      onTap: onTap,
    );
  }

}