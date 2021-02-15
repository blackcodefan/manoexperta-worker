import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'ActionGenerator.dart';
import 'ActionTypes.dart';
import '../state/index.dart';

bidAction(String token, int inqId, double price){
  BackendActionGenerator generator = BackendActionGenerator(
      method: 'POST',
      endpoint: 'https://back.manoexperta.com/rest/bids/$token/$inqId',
      types: [
        ActionTypes.bid1,
        ActionTypes.bid2,
        ActionTypes.bid3,
      ],
    body: {
        "bidamount": price
    }
  );

  return generator.generate();
}

ThunkAction<AppState> bid(String token, int inqId, double price) => (Store<AppState> store) => store.dispatch(bidAction(token, inqId, price));