import 'package:workerf/model/index.dart';
import '../actions/index.dart';
import '../state/index.dart';

DetailState detailReducer(DetailState state, action){
  DetailState newState = state;
  FSA res = FSA.fromMap(action);

  switch(res.type){
    case ActionTypes.fetchDetail1:
      newState.loading = true;
      return newState;
    case ActionTypes.fetchDetail2:
      newState.loading = false;
      ProjectDetailModel detail = ProjectDetailModel.fromMap(res.payload['data']);
      newState.detail = detail;
      return newState;
    case ActionTypes.fetchDetail3:
      newState.loading = false;
      newState.error = res.payload.message;
      return newState;
    case ActionTypes.finishProject1:
      newState.loading = true;
      newState.error = null;
      return newState;
    case ActionTypes.finishProject2:
      if(res.payload['success']){
        newState.loading = false;
        newState.error = null;
      }else{
        newState.loading = false;
        newState.error = res.payload;
      }
      return newState;
    case ActionTypes.finishProject3:
      newState.loading = false;
      newState.error = res.payload.message;
      return newState;
    default:
      return newState;
  }
}