import 'package:workerf/model/index.dart';

class AuthState{
  dynamic error;
  bool loading;
  UserModel user;

  AuthState({
    this.error,
    this.loading,
    this.user});

  factory AuthState.init() => AuthState(
    error: null,
    loading: false,
    user: null
  );
}