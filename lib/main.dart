import 'package:firebase_core/firebase_core.dart';
import 'package:workerf/provider/index.dart';
import 'package:workerf/global/index.dart';
import 'package:workerf/routes.dart';
import 'package:flutter/material.dart';

void main() async
{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  NotificationProvider notification = NotificationProvider();

  notificationToken = await notification.getToken();
  notification.listenTokenRefresh();
  notification.initialize();

  Routes();
}