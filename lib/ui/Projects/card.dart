import 'package:flutter/material.dart';
import 'package:workerf/ui/Components/index.dart';

class ProjectCard extends StatelessWidget
{
  final int reqId;
  final double distance;
  final String description;
  final String imgUrl;
  final Function accept;
  final Function decline;
  final Function viewImage;

  ProjectCard({
    @required this.reqId,
    @required this.distance,
    @required this.description,
    @required this.imgUrl,
    @required this.accept,
    @required this.decline,
    @required this.viewImage
    });

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width / 3;

    String dist;
    if (distance < 1)
    {
      dist = '${(distance * 1000).floor()}m';
    }
    else
    {
      dist = '${distance.floor()}km';
    }

    Widget getImage()
    {
      if (imgUrl == "")
      {
        return Container();
      }
      else
      {
        return GestureDetector(

          child: Padding(
            padding: EdgeInsets.all(2),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: FadeInImage.assetNetwork(
                image: imgUrl,
                placeholder: 'assets/img/spinner-sm.gif',
                width: width /2,
              ))),
          onTap: ()=> imgUrl.isNotEmpty?viewImage(imgUrl):print(''));
      }
    }

    return  Container(
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xDDC4DBF4), width: 2))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trabajo a: $dist',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF826FE3), fontWeight: FontWeight.bold)),
          Container(
              padding: EdgeInsets.all(2),
              child: Text(
                description,
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black, fontSize: 18))),
          getImage(),
          Container(
            padding: EdgeInsets.all(2),
            child: Row(
              children: [
                SmallButton(
                  width: width,
                  height: 30,
                  start: Color(0xFF49988C),
                  end: Color(0xFF47978B),
                  labelText: 'Aplicar',
                  onTap: accept),
                SmallButton(
                  width: width,
                  height: 30,
                  start: Color(0xFFF25F5C),
                  end: Color(0xFFF25F5C),
                  labelText: 'Rechazar',
                  onTap: decline
                )],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ))]));
  }
}