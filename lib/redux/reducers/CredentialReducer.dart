import 'package:workerf/model/index.dart';
import '../actions/index.dart';
import '../state/index.dart';

LocalStorageState credentialReducer(LocalStorageState state, action) {
  LocalStorageState newState = state;
  FSA res = FSA.fromMap(action);
  switch(res.type){
    case ActionTypes.saveCredential:
      newState.credential = CredentialModel.fromMap(res.payload);
      newState.credential.setCredential();
      return newState;
    default:
      return newState;
  }

}