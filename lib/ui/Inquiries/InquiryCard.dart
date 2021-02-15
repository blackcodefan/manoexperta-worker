import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/provider/index.dart';
import 'PriceInput.dart';

class InquiryCard extends StatelessWidget{
  final InquiryModel model;
  final Function onTap;
  final Function onBid;
  final Function onBidUpdate;
  InquiryCard({
    @required this.model,
    @required this.onTap,
    @required this.onBid,
    @required this.onBidUpdate
  }):assert(
  model != null && onTap != null);

  final MaskedTextController _controller = MaskedTextController(mask: '000000');

  void _placeBid(){
    String value = _controller.text.trim();
    if(value.isEmpty) onBid(model, 0.0);
      onBid(model, double.parse(value));
  }

  void _update(){
    String value = _controller.text.trim();
    if(value.isEmpty) return;
    onBidUpdate(model, double.parse(value));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints(minHeight: 100),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFF999999)))),
        width: double.infinity,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipOval(
                  child: FadeInImage.assetNetwork(
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      placeholder: 'assets/img/spinner-sm.gif',
                      image: model.image)),
              VerticalDivider(
                  thickness: 1,
                  color: Colors.transparent),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(model.address, maxLines: 2, style: TextStyle(fontSize: 11, color: Color(0xFF7D2EDA))),
                        Text(model.description),
                        Divider(
                            thickness: 1,
                            color: Colors.transparent),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  width: 100,
                                  child: PriceInput(
                                      controller: _controller)),
                              GestureDetector(
                                  onTap: model.hasBid?_update:_placeBid,
                                  child: Container(
                                      width: 80,
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Color(0xFF7D2EDA),
                                          borderRadius: BorderRadius.circular(8)),
                                      child: Text(model.hasBid?'Recotizar':'Enviar', style: TextStyle(color: Colors.white, fontSize: 18))))
                            ])
                      ])),
              model.hasBid?
              GestureDetector(
                onTap: () => onTap(model),
                child: Column(
                  children: [
                    Icon(Icons.sms, color: Color(0xFF7D2EDA)),
                    model.unread == 0?Container():
                        Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15)),
                          child: Text(model.unread.toString(), style: TextStyle(color: Colors.white)))
                  ])
              ):Container()
            ])
    );
  }
}