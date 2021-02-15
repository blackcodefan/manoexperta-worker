import 'package:workerf/model/index.dart';
import '../actions/index.dart';
import '../state/index.dart';

MarketState marketReducer(MarketState state, action){
  MarketState newState = state;
  FSA res = FSA.fromMap(action);
  switch(res.type){
    case ActionTypes.market1:
      newState.loading = true;
      newState.error = null;
      return newState;
    case ActionTypes.market2:
      if(res.payload['SUCCESS']){
        newState.loading = false;
        newState.error = null;
        newState.market = MarketConfigModel.fromMap(res.payload['data']);
      }else{
        newState.loading = false;
        newState.error = res.payload['errormsg'];
      }
      return newState;
    case ActionTypes.market3:
      newState.loading = false;
      newState.error = res.payload.message;
      return newState;
    default:
      return newState;
  }
}