import 'package:workerf/repository/index.dart';
import '../actions/index.dart';
import '../state/index.dart';

PProjectState pProjectReducer(PProjectState state, action){
  PProjectState newState = state;
  FSA res = FSA.fromMap(action);

  switch(res.type){
    case ActionTypes.fetchPProject1:
      newState.loading = true;
      return newState;
    case ActionTypes.fetchPProject2:
      newState.loading = false;
      PProjectRepository _repository = PProjectRepository.fromList(res.payload['data']);
      newState.projects = _repository.projects;
      return newState;
    case ActionTypes.fetchPProject3:
      newState.loading = false;
      newState.error = res.payload;
      return newState;
    default:
      return newState;
  }
}