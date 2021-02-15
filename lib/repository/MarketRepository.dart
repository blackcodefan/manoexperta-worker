import 'package:workerf/model/index.dart';
import 'package:flutter/cupertino.dart';

class MarketRepository{
  List<MarketModel> markets;

  MarketRepository({@required this.markets});

  factory MarketRepository.fromList(List markets){
    List<MarketModel> _markets = [];
    markets.forEach((market) {_markets.add(MarketModel.fromMap(market));});
    return MarketRepository(markets: _markets);
  }
}