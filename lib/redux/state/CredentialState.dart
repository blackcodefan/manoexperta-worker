import 'package:workerf/model/index.dart';

class LocalStorageState{
  dynamic error;
  CredentialModel credential;

  LocalStorageState({this.error, this.credential});

  factory LocalStorageState.init()=>LocalStorageState(
    error: null,
    credential: null
  );
}