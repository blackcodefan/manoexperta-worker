import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:workerf/global/index.dart';
import 'package:workerf/model/index.dart';
import 'ActionGenerator.dart';
import 'ActionTypes.dart';
import '../state/index.dart';

String hashPassword(String password) => md5.convert(utf8.encode(password)).toString().toUpperCase();

 logInAction(String email, String password) {

   String hashedPwd = hashPassword(password);

   BackendActionGenerator generator = BackendActionGenerator(
     method: "POST",
     endpoint: "https://back.manoexperta.com/rest/tokens",
     types: [
       ActionTypes.loginRequest,
       ActionTypes.loginSuccess,
       ActionTypes.loginFailed
     ],
     body: {
       "logintype": "me",
       "email": email,
       "pass": hashedPwd
     }
   );

  return generator.generate();
}

getProfileAction(String token){

  BackendActionGenerator generator = BackendActionGenerator(
     method: 'GET',
     endpoint: 'https://back.manoexperta.com/rest/worker/$token',
     types: [
       ActionTypes.profileRequest,
       ActionTypes.profileSuccess,
       ActionTypes.profileFailed,
     ]
   );

  return generator.generate();
}

registerAction(
    {
      String avatar,
      String email,
      String firstName,
      String lastName,
      String mobile,
      String password,
      String marketHandle
    }){

  BackendActionGenerator generator = BackendActionGenerator(
      method: 'POST',
      endpoint: 'https://back.manoexperta.com/rest/users',
      types: [
        ActionTypes.register1,
        ActionTypes.register2,
        ActionTypes.register3
      ],
      body:{
        "email": email,
        "mobile": mobile,
        "pass": base64Encode(utf8.encode(password)),
        "firstname": firstName,
        "lastname": lastName,
        "clientavatar": avatar,
        "mktHandle": marketHandle
      });

  return generator.generate();
}

updateProfileAction(String token,
    {List categories,
      String expertName,
      String expertAvatar,
      String email,
      String firstName,
      String lastName,
      String mobile,
      String password,
      String docUrl,
      String docUrl2,
      bool notification,
      bool getEmail,
      String expertBankDocUrl,
      String bankCode,
      String bankId,
      bool allowDirectHire
    }){

  String platform, hashedPassword;

  if (Platform.isAndroid) platform = 'A';
  else if (Platform.isIOS) platform = 'I';

  String deviceId = notificationToken;
  if (password != null) hashedPassword = base64Encode(utf8.encode(password));
  else{hashedPassword = null;}

   BackendActionGenerator generator = BackendActionGenerator(
     method: 'PUT',
     endpoint: 'https://back.manoexperta.com/rest/worker/$token',
     types: [
       ActionTypes.updateProfileRequest,
       ActionTypes.updateProfileSuccess,
       ActionTypes.updateProfileFailed
     ],
     body:{
       "cats": categories,
       "expertname": expertName,
       "expertavatar": expertAvatar,
       "email": email,
       "deviceID": deviceId,
       "platform": platform,
       "firstname": firstName,
       "lastname": lastName,
       "mobile": mobile,
       "pass": hashedPassword,
       "expertdocurl": docUrl,
       "expertdocurl2": docUrl2,
       "expertpushmsg": notification,
       "optmailnews": getEmail,
       "expertbankdocurl": expertBankDocUrl,
       "expertbankclabe": bankCode,
       "expertbankid": bankId,
       "expertShowInList": allowDirectHire
     });

  return generator.generate();
}

updateStoreUserAction(UserModel user){
   return UserUpdateActionGenerator(ActionTypes.updateProfile, user).generate();
}

initWorkerAction(String token){
  BackendActionGenerator generator = BackendActionGenerator(
      method: 'POST',
      endpoint: 'https://back.manoexperta.com/rest/worker/$token',
      types: [
        ActionTypes.initWorkerRequest,
        ActionTypes.initWorkerSuccess,
        ActionTypes.initWorkerFailed,
      ]
  );

  return generator.generate();
}

recoverPasswordAction(String email){

  BackendActionGenerator generator = BackendActionGenerator(
      method: 'GET',
      endpoint: 'https://back.manoexperta.com/rest/tools/getpass/$email',
      types: [
        ActionTypes.recoverPwd1,
        ActionTypes.recoverPwd2,
        ActionTypes.recoverPwd3,
      ]
  );

  return generator.generate();
}

recommendAction(int me, int friend){
  BackendActionGenerator generator = BackendActionGenerator(
      method: 'GET',
      endpoint: 'https://back.manoexperta.com/rest/tools/referal/$me,$friend',
      types: [
        ActionTypes.recommend1,
        ActionTypes.recommend2,
        ActionTypes.recommend3,
      ]
  );

  return generator.generate();
}

ThunkAction<AppState> login(String email, String password) => (Store<AppState> store) => store.dispatch(logInAction(email, password));
ThunkAction<AppState> getProfile(String token) => (Store<AppState> store) => store.dispatch(getProfileAction(token));
ThunkAction<AppState> updateUser(UserModel user) => (Store<AppState> store) => store.dispatch(updateStoreUserAction(user));
ThunkAction<AppState> initWorker(String token) => (Store<AppState> store) => store.dispatch(initWorkerAction(token));
ThunkAction<AppState> recoverPwd(String email) => (Store<AppState> store) => store.dispatch(recoverPasswordAction(email));
ThunkAction<AppState> recommend(int me, int friend) => (Store<AppState> store) => store.dispatch(recommendAction(me, friend));
ThunkAction<AppState> register({
  String avatar,
  String email,
  String firstName,
  String lastName,
  String mobile,
  String password,
  String marketHandle
}) => (Store<AppState> store) => store.dispatch(
    registerAction(
        avatar: avatar,
        email: email,
        firstName: firstName,
        lastName: lastName,
        mobile: mobile,
        password: password,
        marketHandle: marketHandle
    ));
ThunkAction<AppState> updateProfile(
    String token,
    {List categories,
      String expertName,
      String expertAvatar,
      String email,
      String firstName,
      String lastName,
      String mobile,
      String password,
      String docUrl,
      String docUrl2,
      bool notification,
      bool getEmail,
      String expertBankDocUrl,
      String bankCode,
      String bankId,
      bool allowDirectHire
    }) => (Store<AppState> store)
=> store.dispatch(
    updateProfileAction(
      token,
      categories: categories,
      expertName: expertName,
      expertAvatar: expertAvatar,
      email: email,
      firstName: firstName,
      lastName: lastName,
      mobile: mobile,
      password: password,
      docUrl: docUrl,
      docUrl2: docUrl2,
      notification: notification,
      getEmail: getEmail,
      expertBankDocUrl: expertBankDocUrl,
      bankCode: bankCode,
      bankId: bankId,
      allowDirectHire: allowDirectHire
    ));