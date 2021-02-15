import 'package:workerf/repository/index.dart';
import '../actions/index.dart';
import '../state/index.dart';
import 'package:workerf/Exception/index.dart';

ProjectState projectReducer(ProjectState state, action){
  ProjectState newState = state;
  FSA res = FSA.fromMap(action);

  switch(res.type){
    case ActionTypes.fetchProjects1:
      newState.loading = true;
      return newState;
    case ActionTypes.fetchProjects2:
      newState.loading = false;
      newState.repository = ProjectRepository.fromList(res.payload['data']);
      return newState;
    case ActionTypes.fetchProjects3:
      newState.loading = false;
      newState.error = res.payload;
      return newState;
    case ActionTypes.applyProject1:
      newState.loading = true;
      newState.error = null;
      return newState;
    case ActionTypes.applyProject2:
      if(res.payload['success']){
        newState.loading = false;
        newState.error = null;
      }else{
        newState.loading = false;
        ErrorCode code = ErrorCode.unhandled;
        switch (res.payload['errorcode']){
          case 'BADTOKEN':
            code = ErrorCode.session;break;
          case 'busy':
            code = ErrorCode.busy;break;
          case 'badrate':
            code = ErrorCode.badRate;break;
          case 'notverified':
            code = ErrorCode.notVerified;break;
          case 'category':
            code = ErrorCode.category;break;
          case 'range':
            code = ErrorCode.range;break;
          case 'manager':
            code = ErrorCode.manager;break;
          case 'beaten':
            code = ErrorCode.beaten;break;
          case 'inactive':
            code = ErrorCode.inactive;break;
          case 'blocked':
            code = ErrorCode.blocked;break;
          case 'maxapply':
            code = ErrorCode.maxApply;break;
          case 'invalid':
            code = ErrorCode.invalid;break;
          case 'delay':
            code = ErrorCode.delay;
        }
        newState.error = AppException(code: code, errorMessage: res.payload['errormsg'], data: res.payload['waitsecs']);
      }
      return newState;
    case ActionTypes.applyProject3:
      newState.loading = false;
      newState.error = AppException(code: ErrorCode.internal, errorMessage: "Algo salió mal");
      return newState;
    case ActionTypes.declineProject1:
      newState.loading = true;
      newState.error = null;
      return newState;
    case ActionTypes.declineProject2:
      newState.loading = false;
      newState.error = null;
      return newState;
    case ActionTypes.declineProject3:
      newState.loading = false;
      newState.error = res.payload;
      return newState;
    case ActionTypes.updateProjects:
      newState.repository = res.payload;
      return newState;
    default:
      return newState;
  }
}