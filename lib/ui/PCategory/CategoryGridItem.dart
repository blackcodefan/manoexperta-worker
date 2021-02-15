import 'package:flutter/material.dart';
import 'style.dart';

class CategoryGridItem extends StatelessWidget
{
  final int catId;
  final String catName;
  final String imgUrl;
  final bool isSelected;
  final Function onTap;

  CategoryGridItem({
    @required this.catId,
    @required this.catName,
    @required this.imgUrl,
    this.isSelected = false,
    @required this.onTap
  }):assert(
  catId != null &&
      catName != null &&
      imgUrl != null &&
      onTap != null);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      child: Padding(
          padding: EdgeInsets.all(3),
          child: Container(
              decoration: BoxDecoration(
                  color: isSelected?Color(0xFF5033DC):Colors.white,
                  image: DecorationImage(
                      image: NetworkImage(imgUrl),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(7))),
              child:  Stack(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(color: isSelected?Color(0x665033DC):Color(0x22000000)),
                              BoxShadow(color: isSelected?Color(0x665033DC):Color(0x22000000))
                            ]),
                        child: Text(
                            catName,
                            style: categoryName,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis)),
                    isSelected
                        ?Positioned(
                        top: 5,
                        right: 5,
                        child: Icon(Icons.check_circle, color: Colors.white))
                        :Container()
                  ]))),
      onTap: () => onTap(catId, catName),
    );
  }
}