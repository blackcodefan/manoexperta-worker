import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workerf/model/InquiryModel.dart';
import 'package:workerf/provider/index.dart';
import 'package:workerf/repository/index.dart';
import 'package:workerf/ui/Components/404.dart';
import 'package:workerf/ui/Components/index.dart';
import 'InquiryCard.dart';
import 'package:workerf/ui/style.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';


class Inquiry extends StatefulWidget{
  _Inquiry createState() => _Inquiry();
}

class _Inquiry extends State<Inquiry>{

  void _bid(_Props props, InquiryModel model, double price)async{
    await props.placeBid(props.authState.user.token, model.inqId, price);
    if(props.bidState.error == null){
      InquiryProvider.placeBid(model, price);
    }else{
      CToast.error(props.bidState.error);
    }
  }

  void _updateBid(_Props props, InquiryModel model, double price) async{
    await props.placeBid(props.authState.user.token, model.inqId, price);
    if(props.bidState.error == null){
      InquiryProvider.updateBid(model, price);
    }else{
      CToast.error(props.bidState.error);
    }
  }

  @override
  Widget build(BuildContext context) {

    //final Size screenSize = MediaQuery.of(context).size;

    return StoreConnector<AppState, _Props>(
      converter: (store) => _Props.mapStateToProps(store),
      builder: (context, props){
        return Scaffold(
            body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color(0xFF7F30DA),
                          Color(0xFF6732DB)
                        ],
                        stops: [0.05, 0.3]
                    )),
                child: Stack(
                    children: [
                      Scaffold(
                          backgroundColor: Colors.transparent,
                          appBar: AppBar(
                              centerTitle: true,
                              title: Text(
                                  'Cotizaciones',
                                  style: appbarTitle),
                              elevation: 0.0,
                              backgroundColor: Colors.transparent,
                              leading: IconButton(
                                  icon: Icon(Icons.arrow_back_ios),
                                  onPressed: () => Navigator.maybePop(context))),
                          body: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      topLeft: Radius.circular(30))),
                              padding: EdgeInsets.all(20),
                              child: StreamBuilder<List<DocumentSnapshot>>(
                                  stream: InquiryProvider.inquiryStream(),
                                  builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot){

                                    if(!snapshot.hasData) return Center(
                                        child: Text('Loading...', style: TextStyle(fontSize: 25)));
                                    if(snapshot.data.length < 1) return NoResult(message: "No result found.");

                                    InquiryRepository _repository = InquiryRepository.fromList(snapshot.data);
                                    List<InquiryModel> _inquiries = _repository.filter();

                                    return ListView.builder(
                                        itemCount: _inquiries.length,
                                        itemBuilder: (context, int index){
                                          return InquiryCard(
                                            model: _inquiries[index],
                                            onTap: (model) => Navigator.pushNamed(context, '/inqConversation', arguments: model),
                                            onBid: (model, price) => _bid(props, model, price),
                                            onBidUpdate: (model, price) => _updateBid(props, model, price),
                                          );
                                        });
                                  })
                          )),
                      Positioned(
                          top: 0, left: 0,
                          child: props.bidState.loading?FullScreenLoader():Container())
                    ]
                )));
      }
    );
  }
}

class _Props{
  final AuthState authState;
  final BidState bidState;
  final Function placeBid;
  _Props({this.authState, this.bidState, this.placeBid});

  static _Props mapStateToProps(Store<AppState> store){
    return _Props(
        authState: store.state.authState,
        bidState: store.state.bidState,
        placeBid: (String token, int inqId, double price) => store.dispatch(bid(token, inqId, price))
    );
  }
}