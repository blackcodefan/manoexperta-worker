import 'dart:io';
import 'package:workerf/global/index.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/provider/index.dart';
import 'package:workerf/redux/index.dart';
import 'package:workerf/ui/Components/index.dart';

class NotificationProvider
{
  final FirebaseMessaging _fcm = FirebaseMessaging();

  static Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) {
    dynamic data, notification;

    if (message.containsKey('data')) {
      data = message['data'];
    }

    if (message.containsKey('notification')) {
      notification = message['notification'];
    }

    return notification;
  }

  Future initialize() async
  {
    if(Platform.isIOS)
      _fcm.requestNotificationPermissions(
          const IosNotificationSettings(
              sound: true, badge: true, alert: true, provisional: false));

    _fcm.onIosSettingsRegistered.listen((event) {
      print('setting registered: $event');
    });

    _fcm.configure(
        onMessage: (Map<String, dynamic> message) async{
          var data;
          Platform.isIOS?data=message:data=message['data'];
          if(data['type'] == 'unread_message' && data['source'] == "request")
          {
            iSocket.trigger(InternalSocketT.notification, data: data);
          }else if(data['type'] == "unread_message" && data['source'] == "inquiry"){
            CToast.smUnread('Tienes mensajes de consulta no leídos');
          }
        },
        onLaunch: (Map<String, dynamic> message) async
        {
          print('onLaunch: $message');
        },
        onResume: (Map<String, dynamic> message) async
        {
          print('onResume: $message');
        }
    );
  }

  Future getToken() async
  {
    String token = await _fcm.getToken();
    return token;
  }

  void listenTokenRefresh(){
    _fcm.onTokenRefresh.listen((String refreshToken) {
      if(currentUser == null) return;
      UserModel user = currentUser;
      user.addDevice();
      store.dispatch(updateUser(user));
      store.dispatch(updateProfile(refreshToken));
    });
  }

}