import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'ActionGenerator.dart';
import 'ActionTypes.dart';
import '../state/index.dart';

hint(){
  BackendActionGenerator generator = BackendActionGenerator(
      method: 'GET',
      endpoint: 'https://back.manoexperta.com/rest/tools/hints/x',
      types: [
        ActionTypes.hint1,
        ActionTypes.hint2,
        ActionTypes.hint3,
      ]
  );

  return generator.generate();
}

ThunkAction<AppState> getHint() => (Store<AppState> store) => store.dispatch(hint());