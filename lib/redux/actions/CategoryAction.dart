import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:workerf/global/index.dart';
import 'package:workerf/redux/state/index.dart';
import 'ActionGenerator.dart';
import 'ActionTypes.dart';

getCategoryAction(){

  BackendActionGenerator generator = BackendActionGenerator(
      method: 'GET',
      endpoint: 'https://back.manoexperta.com/rest/tools/categories/$appId',
      types: [
        ActionTypes.fetchCategory1,
        ActionTypes.fetchCategory2,
        ActionTypes.fetchCategory3,
      ]
  );

  return generator.generate();
}

ThunkAction<AppState> getCategory() => (Store<AppState> store) => store.dispatch(getCategoryAction());