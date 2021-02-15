import 'package:workerf/model/index.dart';
import 'package:workerf/ui/Components/index.dart';
import 'package:flutter/material.dart';

class PJobCard extends StatelessWidget {
  final bool isRated;
  final double rate;
  final String username;
  final String describe;
  final String comment;
  final int reqId;
  final String clientAvatar;

  PJobCard({
    @required this.isRated,
    @required this.rate,
    @required this.username,
    @required this.describe,
    @required this.comment,
    @required this.reqId,
    @required this.clientAvatar
  });


  Widget rating(double rate)
  {
    List<Widget> stars = [];

    for (var i = 1; i <= 5; i ++)
    {
      if( i <= rate)
      {
        stars.add(Icon(Icons.star, size: 18, color: Color(0xFFf5ad42)),);
      }
      else
      {
        stars.add(Icon(Icons.star_border, size: 18, color: Color(0xFFf5ad42)),);
      }
    }

    return Row(mainAxisAlignment: MainAxisAlignment.end, children: stars);
  }

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;

    return  Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                child: Row(
                  children: [
                    ClipOval(
                      child: FadeInImage(
                        placeholder: AssetImage('assets/img/spinner-sm.gif'),
                        width: 50,
                        image: NetworkImage(clientAvatar))),
                    Text(' '),
                    Expanded(
                      child: Text(
                        username,
                        style: TextStyle(
                            color: Color(0xFF46978B),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis
                      ))]),
                width: screenSize.width/2 -40),
              Expanded(
                  child: isRated?rating(rate):Container()
              )]),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(
              describe,
              style: TextStyle(color: Colors.black, fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            )),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text(
              comment,
              style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
              maxLines: 3,
              overflow: TextOverflow.ellipsis)),
          Container(
            padding: EdgeInsets.all(2),
            child: Row(
              children: [
                SmallButton(
                  width: screenSize.width / 3,
                  height: 30,
                  start: Color(0xFF49988C),
                  end: Color(0xFF47978B),
                  labelText: 'Contacto',
                  onTap: () => Navigator.pushNamed(
                      context, '/hConversation',
                      arguments: ConversationModel(
                          chatType: "project",
                          id: reqId,
                          clientName: username,
                          clientAvatar: clientAvatar))
                )],
              mainAxisAlignment: MainAxisAlignment.center,
            ))]),
      padding: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Color(0xFFC4DBF4),
                  width: 2))));
  }
}
