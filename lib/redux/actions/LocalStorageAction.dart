import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:workerf/redux/actions/ActionGenerator.dart';
import 'package:workerf/redux/actions/index.dart';
import '../state/index.dart';

setLocalStorage(String email, password){
  return LocalStorageActionGenerator(ActionTypes.saveCredential).setAction(email, password);
}

ThunkAction<AppState> setCredential(String email, password) => (Store<AppState> store) => store.dispatch(setLocalStorage(email, password));