import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:workerf/redux/state/index.dart';
import 'ActionGenerator.dart';
import 'ActionTypes.dart';

getPProjectAction(String token){

  BackendActionGenerator generator = BackendActionGenerator(
      method: 'GET',
      endpoint: 'https://back.manoexperta.com/rest/history/$token/X',
      types: [
        ActionTypes.fetchPProject1,
        ActionTypes.fetchPProject2,
        ActionTypes.fetchPProject3,
      ]
  );

  return generator.generate();
}

ThunkAction<AppState> getPProject(String token) => (Store<AppState> store) => store.dispatch(getPProjectAction(token));