import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'ActionGenerator.dart';
import 'ActionTypes.dart';
import '../state/index.dart';

marketAction(Position position){
  BackendActionGenerator generator = BackendActionGenerator(
      method: 'GET',
      endpoint: 'https://back.manoexperta.com/rest/markets/${position.latitude},${position.longitude}',
      types: [
        ActionTypes.market1,
        ActionTypes.market2,
        ActionTypes.market3,
      ]
  );

  return generator.generate();
}

ThunkAction<AppState> market(Position position) => (Store<AppState> store) => store.dispatch(marketAction(position));