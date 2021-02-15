import 'package:redux_api_middleware/redux_api_middleware.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/global/index.dart';
import '../actions/index.dart';
import '../state/index.dart';

AuthState authReducer(AuthState state, action){
  AuthState newState = state;
  FSA res = FSA.fromMap(action);

  switch(res.type){
    case ActionTypes.loginRequest:
      newState.error = null;
      newState.loading = true;
      newState.user = null;
      return newState;
    case ActionTypes.loginSuccess:
      if(res.payload['success']){
        newState.error = null;
        newState.loading = false;
        newState.user = UserModel.fromMap(res.payload['data'], res.payload['token']);
        currentUser = newState.user;
      }else{
        newState.error = res.payload['errormsg'];
        newState.loading = false;
        newState.user = null;
      }
      return newState;
    case ActionTypes.loginFailed:
      print(res.payload.message);
      newState.error = res.payload;
      newState.loading = false;
      newState.user = null;
      return newState;
    case ActionTypes.profileRequest:
      newState.error = null;
      newState.loading = true;
      return newState;
    case ActionTypes.profileSuccess:
      if(res.payload['success']){
        newState.error = null;
        newState.loading = false;
        newState.user = UserModel.fromMap(res.payload['data'], res.payload['token']);
        currentUser = newState.user;
      }else{
        newState.error = res.payload['errorcode'];
        newState.loading = false;
      }
      return newState;
    case ActionTypes.profileFailed:
      newState.error = res.payload.message;
      newState.loading = false;
      return newState;
    case ActionTypes.updateProfileRequest:
      newState.loading = true;
      return newState;
    case ActionTypes.updateProfileSuccess:
      newState.error = null;
      newState.loading = false;
      return newState;
    case ActionTypes.updateProfileFailed:
      newState.error = res.payload['errorcode'];
      newState.loading = false;
      return newState;
    case ActionTypes.updateProfile:
      newState.user = res.payload;
      currentUser = res.payload;
      return newState;
    case ActionTypes.recoverPwd1:
      newState.error = null;
      newState.loading = true;
      return newState;
    case ActionTypes.recoverPwd2:
      if(res.payload['success']){
        newState.error = null;
        newState.loading = false;
      }else{
        newState.error = res.payload['errormsg'];
        newState.loading = false;
      }
      return newState;
    case ActionTypes.recoverPwd3:
      newState.error = res.payload.message;
      newState.loading = false;
      return newState;
    case ActionTypes.register1:
      newState.error = null;
      newState.loading = true;
      return newState;
    case ActionTypes.register2:
      if(res.payload['success']){
        newState.error = null;
        newState.loading = false;
        newState.user = UserModel(userId: res.payload['data']['userid']);
      }else{
        newState.error = res.payload['errormsg'];
        newState.loading = false;
      }
      return newState;
    case ActionTypes.register3:
      newState.error = res.payload.message;
      newState.loading = false;
      return newState;
    case ActionTypes.initWorkerRequest:
      newState.error = null;
      newState.loading = true;
      return newState;
    case ActionTypes.initWorkerSuccess:
      newState.error = null;
      newState.loading = false;
      return newState;
    case ActionTypes.initWorkerFailed:
      newState.error = res.payload.message;
      newState.loading = false;
      return newState;
    case ActionTypes.recommend1:
      newState.error = null;
      newState.loading = true;
      return newState;
    case ActionTypes.recommend2:
      if(res.payload['success']){
        newState.error = null;
        newState.loading = false;
      }else{
        newState.error = res.payload['errormsg'];
        newState.loading = false;
      }
      return newState;
    case ActionTypes.recommend3:
      newState.error = res.payload.message;
      newState.loading = false;
      return newState;
    default:
      return newState;
  }
}
