import 'package:workerf/model/index.dart';

class MarketState{
  dynamic error;
  bool loading;
  MarketConfigModel market;

  MarketState({this.error, this.loading, this.market});

  factory MarketState.init() => MarketState(
      error: null,
      loading: false,
      market: null);
}