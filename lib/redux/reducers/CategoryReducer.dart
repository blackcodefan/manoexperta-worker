import 'package:workerf/repository/index.dart';
import '../actions/index.dart';
import '../state/index.dart';

CategoryState categoryReducer(CategoryState state, action){
  CategoryState newState = state;
  FSA res = FSA.fromMap(action);

  switch(res.type){
    case ActionTypes.fetchCategory1:
      newState.loading = true;
      return newState;
    case ActionTypes.fetchCategory2:
      newState.loading = false;
      newState.repository = CategoryRepository.fromList(res.payload['data']);
      return newState;
    case ActionTypes.fetchCategory3:
      newState.loading = false;
      newState.error = res.payload;
      return newState;
    default:
      return newState;
  }
}