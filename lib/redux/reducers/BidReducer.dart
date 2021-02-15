import '../actions/index.dart';
import '../state/index.dart';

BidState bidReducer(BidState state, action){
  BidState newState = state;
  FSA res = FSA.fromMap(action);
  switch(res.type){
    case ActionTypes.bid1:
      newState.error = null;
      newState.loading = true;
      return newState;
    case ActionTypes.bid2:
      if(res.payload['success']){
        newState.error = null;
        newState.loading = false;
      }else{
        newState.error = res.payload['errormsg'];
        newState.loading = false;
      }
      return newState;
    case ActionTypes.bid3:
      newState.error = res.payload.message;
      newState.loading = false;
      return newState;
    default:
      return newState;
  }
}