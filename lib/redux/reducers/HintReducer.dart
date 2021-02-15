import 'package:workerf/repository/index.dart';
import '../actions/index.dart';
import '../state/index.dart';

HintState hintReducer(HintState state, action){
  HintState newState = state;
  FSA res = FSA.fromMap(action);
  if(res.type == ActionTypes.hint2){
    HintRepository _repository = HintRepository.fromList(res.payload['data']);
    newState.hints = _repository.hints;
  }
  return newState;
}